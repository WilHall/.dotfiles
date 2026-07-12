# lbackup — run restic against the laptop-backups R2 repo
#
#   lbackup snapshots                      # list snapshots (add --host <name>)
#   lbackup find "*.pdf"                   # find a file across all snapshots
#   lbackup ls latest ~/Pictures          # list a subtree of the latest snapshot
#   lbackup dump latest ~/.dotfiles/Brewfile   # print one file, no restore
#   lbackup mount ~/restic-mnt            # browse every snapshot in Finder (needs macFUSE)
#   lbackup restore latest --target /tmp/r --include ~/Documents
#
#   lbackup delete-path [--host <name>] [--yes] <glob> [<glob>...]
#       Permanently remove files matching a restic exclude pattern from existing
#       snapshots (all hosts, or one with --host). Previews as a dry-run, asks to
#       confirm, then rewrites the affected snapshots and prunes to reclaim space.

lbackup() {
  local config="$HOME/.dotfiles/LaunchAgents/laptop-backup/config.yaml"
  [[ -f "$HOME/.auth" ]] || { print -u2 "lbackup: ~/.auth not found"; return 1; }
  local tool
  for tool in restic yq; do
    command -v "$tool" >/dev/null || { print -u2 "lbackup: $tool not installed (brew install $tool)"; return 1; }
  done
  (
    set -a; source "$HOME/.auth"; set +a
    export AWS_ACCESS_KEY_ID="$LAPTOP_BACKUPS_R2_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$LAPTOP_BACKUPS_R2_SECRET_ACCESS_KEY"
    export AWS_DEFAULT_REGION="auto"
    export RESTIC_PASSWORD="$LAPTOP_BACKUPS_RESTIC_PASSWORD"
    export RESTIC_REPOSITORY="$(yq '.repository' "$config")"

    # Custom: delete files from snapshots by glob, scoped to a host or all hosts.
    if [[ "$1" == "delete-path" ]]; then
      shift
      local host="" assume_yes=0
      local -a patterns
      while (( $# )); do
        case "$1" in
          --host)   host="$2"; shift 2 ;;
          --host=*) host="${1#--host=}"; shift ;;
          -y|--yes) assume_yes=1; shift ;;
          --)       shift; patterns+=("$@"); break ;;
          -*)       print -u2 "lbackup delete-path: unknown flag '$1'"; return 2 ;;
          *)        patterns+=("$1"); shift ;;
        esac
      done

      if (( ${#patterns} == 0 )); then
        print -u2 "usage: lbackup delete-path [--host <name>] [--yes] <glob> [<glob>...]"
        return 2
      fi

      local -a exclude_args host_args
      local pattern
      for pattern in "${patterns[@]}"; do exclude_args+=(--exclude "$pattern"); done
      [[ -n "$host" ]] && host_args=(--host "$host")

      local scope; [[ -n "$host" ]] && scope="host '$host'" || scope="ALL hosts"
      print "Previewing removal of ${(j:, :)patterns} from $scope (dry run)…"
      restic rewrite --dry-run --forget "${host_args[@]}" "${exclude_args[@]}" || return

      if (( ! assume_yes )); then
        print -n "Permanently rewrite snapshots to remove these files from $scope? [y/N] "
        if ! read -q reply; then print; print "Aborted."; return 1; fi
        print
      fi

      restic rewrite --forget "${host_args[@]}" "${exclude_args[@]}" || return
      print "Pruning unreferenced data to reclaim space…"
      restic prune
      return
    fi

    exec restic "$@"
  )
}

# Reuse restic's own tab-completion for lbackup, when it's available.
(( $+functions[_restic] )) && compdef lbackup=restic
