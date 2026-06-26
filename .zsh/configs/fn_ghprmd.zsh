# GitHub pull request helpers.

# List your open PRs as a Markdown bullet list of links.
# Usage: ghprmd [--all | owner/repo] [-- extra gh flags]
#   ghprmd                      # your open PRs in the current directory's repo
#   ghprmd zeus-health/ctw      # your open PRs in an explicit repo
#   ghprmd --all                # your open PRs across all of GitHub
#   ghprmd --help               # show usage
function ghprmd() {
  emulate -L zsh

  case "$1" in
    -h|--help)
      print -r -- 'ghprmd — list your open PRs as a Markdown bullet list of links.

Usage:
  ghprmd [owner/repo]   Your open PRs in the given repo (default: current repo)
  ghprmd --all          Your open PRs across all of GitHub
  ghprmd --help         Show this help

Extra arguments are passed through to the underlying gh command.'
      return 0
      ;;
  esac

  (( ${+commands[gh]} )) || {
    print -u2 "ghprmd: gh not found on PATH (try: brew install gh)"
    return 127
  }

  if [[ "$1" == --all ]]; then
    shift
    # Results span every repo, so prefix each line with owner/repo to disambiguate.
    gh search prs --author "@me" --state open --limit 100 "$@" \
      --json number,title,url,repository \
      --jq '.[] | " - [\(.repository.nameWithOwner)#\(.number) — \(.title)](\(.url))"'
    return
  fi

  local -a gh_args=( pr list --author "@me" --state open --limit 100 )
  [[ -n "$1" && "$1" != -* ]] && { gh_args+=( --repo "$1" ); shift }
  gh_args+=( "$@" )

  gh "${gh_args[@]}" --json number,title,url \
    --jq '.[] | " - [#\(.number) — \(.title)](\(.url))"'
}
