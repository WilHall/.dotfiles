# lbackup — run restic against the laptop-backups R2 repo
#
#   lbackup snapshots                      # list snapshots (add --host <name>)
#   lbackup find "*.pdf"                   # find a file across all snapshots
#   lbackup ls latest ~/Pictures          # list a subtree of the latest snapshot
#   lbackup dump latest ~/.dotfiles/Brewfile   # print one file, no restore
#   lbackup mount ~/restic-mnt            # browse every snapshot in Finder (needs macFUSE)
#   lbackup restore latest --target /tmp/r --include ~/Documents

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
    exec restic "$@"
  )
}

# Reuse restic's own tab-completion for lbackup, when it's available.
(( $+functions[_restic] )) && compdef lbackup=restic
