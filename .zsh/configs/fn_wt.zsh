# wt — jump to / review git-worktree directories in a bare-repo wrapper.
#
# Works in the twiced.de "bare repo + worktrees" layout: a WRAPPER directory
# that contains a `.bare/` git dir (plus a `.git` FILE pointing at it) and one
# sub-directory per worktree. From anywhere inside such a wrapper, `wt` walks up
# to find it, lists its worktrees, and cross-references each worktree's branch
# against a "concierge mirror" markdown table to decide which ones need your
# attention.
#
# The mirror lives at  ~/.claude/concierge/<wrapper-basename>.md  and holds a
# markdown table whose `status` column begins with an attention glyph:
#     🟠 needs you    🟡 in-flight    🔵 done, no open PR    🟢 has an open PR
# Rows with no recognized glyph (or no matching mirror row) are treated as ⚪
# unknown and only appear under `-a`. If no mirror exists, `wt` degrades to a
# plain worktree list with no attention annotations.
#
# The table is parsed BY HEADER NAME (columns may be added/reordered). The
# fzf preview box leads with the row's `summary` (plain-language description of
# what the branch addresses), then status + last-event detail.
#
# Usage:
#   wt [view]          fzf-pick a worktree needing attention (🟠); Enter → cd
#   wt test            fzf-pick a FINISHED branch (🔵 done / 🟢 open-PR); Enter → cd
#   wt review          fzf-pick a worktree; Enter → revdiff its changes
#   wt -a | --all      include ALL worktrees (🟡/🔵/🟢/⚪), not just the default set
#   wt -h | --help     show this help
#
#   Flags combine with any subcommand and are order-independent, e.g.
#   `wt review -a`, `wt -a`, `wt view --all`, `wt test -a`.
#
# Default filter: view/review → 🟠 needs-you;  test → 🔵/🟢 finished.  `wt test`
# is `wt view` with the finished-branches filter — handy for jumping into a
# completed branch to test it manually.
#
# `wt` must be a *sourced* function (not a script) so `wt view` can change the
# calling shell's working directory. This file is auto-sourced by the loop at
# the end of ~/.zsh/.zshrc (`for f in $HOME/.zsh/configs/*.zsh; source $f`).

# _wt_review — run revdiff on a worktree's changes, without changing the caller's cwd.
#   $1 = worktree path   $2 = wrapper root
# Dirty tree        → review the working tree (incl. untracked files).
# Clean but ahead   → review the commit range base..HEAD.
# Clean and level   → nothing to review.
function _wt_review() {
  emulate -L zsh
  local wt_path="$1" wrapper="$2"

  # Default branch of the wrapper's bare repo (generic: whatever HEAD points at),
  # falling back to origin/HEAD, then to "main".
  local base
  base=$(git -C "$wrapper/.bare" symbolic-ref --short HEAD 2>/dev/null)
  if [[ -z "$base" ]]; then
    base=$(git -C "$wt_path" rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
    base="${base#origin/}"
  fi
  [[ -z "$base" ]] && base="main"

  if [[ -n "$(git -C "$wt_path" status --porcelain 2>/dev/null)" ]]; then
    # Working-tree changes present — review them (untracked included).
    ( cd "$wt_path" && revdiff --untracked )
  else
    local ahead
    ahead=$(git -C "$wt_path" rev-list --count "${base}..HEAD" 2>/dev/null)
    if [[ -n "$ahead" && "$ahead" -gt 0 ]]; then
      print -r -- "wt review: working tree clean; reviewing ${base}..HEAD (${ahead} commit(s))." >&2
      ( cd "$wt_path" && revdiff "$base" HEAD )
    else
      print -r -- "wt review: ${wt_path##*/} is clean and not ahead of ${base} — nothing to review." >&2
    fi
  fi
}

function wt() {
  emulate -L zsh

  # ── parse args (order-independent) ────────────────────────────────────────
  local cmd="" all=0 arg
  for arg in "$@"; do
    case "$arg" in
      -a|--all)        all=1 ;;
      -h|--help|help)  cmd="help" ;;
      view|review|test) cmd="$arg" ;;
      *) print -r -- "wt: unknown argument: $arg (try 'wt --help')" >&2; return 2 ;;
    esac
  done
  [[ -z "$cmd" ]] && cmd="view"

  if [[ "$cmd" == "help" ]]; then
    print -r -- 'wt — jump to / review git worktrees in a bare-repo wrapper.

Usage:
  wt [view]        fzf-pick a worktree needing attention (🟠); Enter → cd into it
  wt test          fzf-pick a FINISHED branch (🔵/🟢) to test; Enter → cd into it
  wt review        fzf-pick a worktree; Enter → revdiff its changes
  wt -a | --all    include ALL worktrees (🟡 in-flight, 🔵 done, 🟢 open-PR, ⚪ unknown)
  wt -h | --help   show this help

Attention glyphs (from ~/.claude/concierge/<wrapper>.md):
  🟠 needs you   🟡 in-flight   🔵 done, no open PR   🟢 open PR   ⚪ unknown

view/review default to 🟠 (needs-you); test defaults to 🔵/🟢 (finished). -a
shows everything. With no concierge mirror, all worktrees are listed without
annotations.'
    return 0
  fi

  (( $+commands[fzf] )) || { print -r -- "wt: fzf not found on PATH." >&2; return 127; }

  # ── locate the bare-repo wrapper (dir containing .bare/) ──────────────────
  local dir="$PWD" wrapper=""
  while [[ -n "$dir" && "$dir" != "/" ]]; do
    if [[ -d "$dir/.bare" ]]; then wrapper="$dir"; break; fi
    dir="${dir:h}"
  done
  if [[ -z "$wrapper" ]]; then
    print -r -- "wt: not inside a bare-repo worktree wrapper (no .bare/ in any parent of $PWD)." >&2
    return 1
  fi

  local mirror="$HOME/.claude/concierge/${wrapper:t}.md"
  local have_mirror=0
  [[ -f "$mirror" ]] && have_mirror=1

  # ── enumerate worktrees (porcelain is stable across git versions) ─────────
  local -a wt_paths wt_branches
  local line cur_path="" cur_branch="" is_bare=0
  while IFS= read -r line; do
    case "$line" in
      "worktree "*)
        if [[ -n "$cur_path" && $is_bare -eq 0 ]]; then
          wt_paths+=("$cur_path"); wt_branches+=("$cur_branch")
        fi
        cur_path="${line#worktree }"; cur_branch=""; is_bare=0 ;;
      "bare")       is_bare=1 ;;
      "branch "*)   cur_branch="${line#branch refs/heads/}" ;;
      "detached")   cur_branch="(detached)" ;;
    esac
  done < <(git -C "$wrapper" worktree list --porcelain 2>/dev/null)
  if [[ -n "$cur_path" && $is_bare -eq 0 ]]; then
    wt_paths+=("$cur_path"); wt_branches+=("$cur_branch")
  fi

  if (( ${#wt_paths} == 0 )); then
    print -r -- "wt: no worktrees found in $wrapper." >&2
    return 1
  fi

  # ── parse the concierge mirror table into parallel arrays ─────────────────
  # Columns are located BY HEADER NAME (not fixed index) so the table can gain
  # columns or be reordered freely. Expected names: task, branch, status,
  # summary, last-event (any subset; missing ones come back empty).
  local -a m_task m_branch m_status m_summary m_event
  if (( have_mirror )); then
    local _t _b _s _summ _e
    while IFS=$'\t' read -r _t _b _s _summ _e; do
      [[ -z "$_b" ]] && continue
      m_task+=("$_t"); m_branch+=("$_b"); m_status+=("$_s"); m_summary+=("$_summ"); m_event+=("$_e")
    done < <(awk -F'|' '
      function trim(s) { gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s); return s }
      /^[[:space:]]*\|/ {
        sep = 1                                  # separator row = only ---/empty cells
        for (i = 2; i < NF; i++) { c = trim($i); if (c != "" && c !~ /^:?-+:?$/) { sep = 0; break } }
        if (sep) next
        if (!seen_header) {                      # first non-separator row = header
          for (i = 2; i < NF; i++) col[trim($i)] = i
          seen_header = 1
          next
        }
        if (!("branch" in col)) next
        branch = trim($(col["branch"]))
        if (branch == "") next
        task    = ("task"    in col) ? trim($(col["task"]))    : ""
        status  = ("status"  in col) ? trim($(col["status"]))  : ""
        summary = ("summary" in col) ? trim($(col["summary"])) : ""
        event = ""
        if ("last-event" in col) {               # join to line end (tolerate stray "|")
          for (i = col["last-event"]; i < NF; i++) event = event (i > col["last-event"] ? "|" : "") $i
          event = trim(event)
        }
        print task "\t" branch "\t" status "\t" summary "\t" event
      }
    ' "$mirror")
  fi

  # ── build fzf rows (one per worktree), aggregating multi-row branches ─────
  local tmpdir
  tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/wt.XXXXXX") || { print -r -- "wt: mktemp failed." >&2; return 1; }

  {
    local -a fzf_lines
    local i j idx=0
    for (( i = 1; i <= ${#wt_paths}; i++ )); do
      local wt_path="${wt_paths[i]}" branch="${wt_branches[i]}"
      local best_pri=-1 best_idx=-1 match_count=0

      for (( j = 1; j <= ${#m_branch}; j++ )); do
        [[ "${m_branch[j]}" == "$branch" ]] || continue
        (( match_count++ ))
        local tok="${m_status[j]%% *}" pri=0
        if   [[ "$tok" == "🟠" ]]; then pri=4
        elif [[ "$tok" == "🟡" ]]; then pri=3
        elif [[ "$tok" == "🟢" ]]; then pri=2
        elif [[ "$tok" == "🔵" ]]; then pri=1
        else pri=0; fi
        if (( pri > best_pri )); then best_pri=$pri; best_idx=$j; fi
      done

      local glyph=""
      case $best_pri in
        4) glyph="🟠" ;; 3) glyph="🟡" ;; 2) glyph="🟢" ;; 1) glyph="🔵" ;; *) glyph="⚪" ;;
      esac

      # default filter (skipped by -a, or when there's no mirror to filter):
      #   view/review → 🟠 needs-you   test → 🔵/🟢 finished (done or open-PR)
      if (( have_mirror && ! all )); then
        if [[ "$cmd" == "test" ]]; then
          [[ "$glyph" == "🔵" || "$glyph" == "🟢" ]] || continue
        else
          [[ "$glyph" == "🟠" ]] || continue
        fi
      fi

      # inline summary = winning row's status text (glyph stripped)
      local status_text=""
      if (( best_idx > 0 )); then
        local bst="${m_status[best_idx]}" btok="${m_status[best_idx]%% *}"
        if [[ "$btok" == "🟠" || "$btok" == "🟡" || "$btok" == "🔵" || "$btok" == "🟢" ]]; then
          status_text="${bst#"$btok"}"; status_text="${status_text# }"
        else
          status_text="$bst"
        fi
      fi

      local display="$glyph  $branch"
      [[ -n "$status_text" ]] && display+="  ·  $status_text"
      (( match_count > 1 )) && display+="  (+$(( match_count - 1 )) more)"

      # preview file: LEAD with the winning row's plain-language summary (bold),
      # then branch/path, then per-row status + last-event detail.
      local preview=""
      if (( best_idx > 0 )) && [[ -n "${m_summary[best_idx]}" ]]; then
        preview+=$'\e[1m'"${m_summary[best_idx]}"$'\e[0m'$'\n\n'
      fi
      preview+="branch:  $branch"$'\n'"path:    $wt_path"$'\n'
      if (( match_count == 0 )); then
        if (( have_mirror )); then
          preview+=$'\n'"(no concierge mirror entry for this branch)"
        else
          preview+=$'\n'"(no concierge mirror at $mirror)"
        fi
      else
        for (( j = 1; j <= ${#m_branch}; j++ )); do
          [[ "${m_branch[j]}" == "$branch" ]] || continue
          preview+=$'\n'"── ${m_task[j]} ──"$'\n'"status:  ${m_status[j]}"$'\n\n'"${m_event[j]}"$'\n'
        done
      fi

      local previewfile="$tmpdir/$idx"; (( idx++ ))
      print -r -- "$preview" > "$previewfile"
      fzf_lines+=("$display"$'\t'"$wt_path"$'\t'"$previewfile")
    done

    if (( ${#fzf_lines} == 0 )); then
      if (( all )); then
        print -r -- "wt: no worktrees to show." >&2
      else
        local want="worktrees needing your attention (🟠)"
        [[ "$cmd" == "test" ]] && want="finished branches to test (🔵/🟢)"
        print -r -- "wt: no ${want}. Try 'wt ${cmd} -a' to see all worktrees." >&2
      fi
      return 0
    fi

    local legend="🟠 needs-you · 🟡 in-flight · 🔵 done/no-PR · 🟢 open-PR · ⚪ unknown"
    (( have_mirror )) || legend="no concierge mirror — showing all worktrees"
    local keys; [[ "$cmd" == "review" ]] && keys="enter=revdiff · esc=cancel" || keys="enter=cd · esc=cancel"
    local header="wt ${cmd}${${all:+ (all)}:-}  |  ${legend}  |  ${keys}"

    local selected
    selected=$(printf '%s\n' "${fzf_lines[@]}" | fzf \
      --delimiter=$'\t' \
      --with-nth=1 \
      --layout=reverse \
      --border \
      --height='80%' \
      --info=inline \
      --prompt="wt ${cmd}> " \
      --header="$header" \
      --preview='cat {3}' \
      --preview-window='down:45%:wrap')

    [[ -z "$selected" ]] && return 0   # esc / no selection → no-op

    local -a parts=("${(@ps:\t:)selected}")
    local sel_path="${parts[2]}"

    case "$cmd" in
      view|test)
        if [[ -d "$sel_path" ]]; then
          cd "$sel_path"
        else
          print -r -- "wt: worktree path not found: $sel_path" >&2
          return 1
        fi
        ;;
      review)
        _wt_review "$sel_path" "$wrapper"
        ;;
    esac
  } always {
    [[ -n "$tmpdir" ]] && rm -rf "$tmpdir"
  }
}
