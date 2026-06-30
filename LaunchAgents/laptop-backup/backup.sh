#!/usr/bin/env bash
#
# laptop-backup — restic backup of configured local folders to Cloudflare R2.
# See `README.md`

set -o pipefail

# Homebrew bin isn't on a LaunchAgent's minimal PATH.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
CONFIG="$SCRIPT_DIR/config.yaml"
AUTH="$HOME/.auth"

log()    { printf '%s  %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*"; }
notify() { /usr/bin/osascript -e "display notification \"$1\" with title \"Laptop backup\"" >/dev/null 2>&1 || true; }
fail()   { log "ERROR: $*"; notify "Failed: $*"; exit 1; }

# yq value with a fallback when the key is missing/null.
yqdef() {
  local v; v="$(yq "$1" "$CONFIG" 2>/dev/null)"
  if [ -z "$v" ] || [ "$v" = "null" ]; then printf '%s' "$2"; else printf '%s' "$v"; fi
}

# ── preconditions ────────────────────────────────────────────────────────────
command -v restic >/dev/null 2>&1 || fail "restic not installed (brew install restic)"
command -v yq     >/dev/null 2>&1 || fail "yq not installed (brew install yq)"
[ -f "$CONFIG" ] || fail "config not found: $CONFIG"
[ -f "$AUTH" ]   || fail "secrets file not found: $AUTH"

# ── secrets (from ~/.auth) ───────────────────────────────────────────────────
set -a; . "$AUTH"; set +a
: "${LAPTOP_BACKUPS_R2_ACCESS_KEY_ID:?missing LAPTOP_BACKUPS_R2_ACCESS_KEY_ID in ~/.auth}"
: "${LAPTOP_BACKUPS_R2_SECRET_ACCESS_KEY:?missing LAPTOP_BACKUPS_R2_SECRET_ACCESS_KEY in ~/.auth}"
: "${LAPTOP_BACKUPS_RESTIC_PASSWORD:?missing LAPTOP_BACKUPS_RESTIC_PASSWORD in ~/.auth}"

# Map our namespaced secrets onto what restic/minio expect, scoped to this
# process so the surrounding shell's own AWS_* env (if any) stays untouched.
export AWS_ACCESS_KEY_ID="$LAPTOP_BACKUPS_R2_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$LAPTOP_BACKUPS_R2_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="auto"
export RESTIC_PASSWORD="$LAPTOP_BACKUPS_RESTIC_PASSWORD"
RESTIC_REPOSITORY="$(yq '.repository' "$CONFIG")"; export RESTIC_REPOSITORY
[ -n "$RESTIC_REPOSITORY" ] && [ "$RESTIC_REPOSITORY" != "null" ] || fail "repository missing in config.yaml"

# ── read config (bash 3.2: while-read, not mapfile) ──────────────────────────
PATHS=()
while IFS= read -r p; do
  [ -n "$p" ] || continue
  p="${p/#\~/$HOME}"                       # expand a leading ~ to $HOME
  if [ -e "$p" ]; then PATHS+=("$p"); else log "skip (not present on this machine): $p"; fi
done < <(yq '.paths[]' "$CONFIG" 2>/dev/null)
[ "${#PATHS[@]}" -gt 0 ] || fail "none of the configured paths exist on this machine"

EXCLUDE_ARGS=()
while IFS= read -r e; do
  [ -n "$e" ] && [ "$e" != "null" ] && EXCLUDE_ARGS+=(--exclude "$e")
done < <(yq '.excludes[]' "$CONFIG" 2>/dev/null)

KEEP_DAILY="$(yqdef '.retention.daily' 7)"
KEEP_WEEKLY="$(yqdef '.retention.weekly' 4)"
KEEP_MONTHLY="$(yqdef '.retention.monthly' 6)"
HOST="$(hostname -s)"

log "════════ laptop-backup ($HOST) started ════════"

# ── init the repo on the first ever run (one machine creates it; the other just
#    connects to the shared repo) ──────────────────────────────────────────────
if ! restic cat config >/dev/null 2>&1; then
  log "repository not initialized yet — running restic init"
  restic init || fail "restic init failed (check R2 creds / bucket / token)"
fi

# ── backup (restic auto-tags the snapshot with this hostname) ────────────────
log "backing up ${#PATHS[@]} path(s) → $RESTIC_REPOSITORY"
restic backup "${EXCLUDE_ARGS[@]}" "${PATHS[@]}" || fail "restic backup failed"
log "backup OK"

# ── retention, scoped to THIS host's snapshots so it never prunes another
#    machine's history ─────────────────────────────────────────────────────────
log "retention: keep ${KEEP_DAILY}d/${KEEP_WEEKLY}w/${KEEP_MONTHLY}m for $HOST"
restic forget --prune --host "$HOST" \
  --keep-daily "$KEEP_DAILY" --keep-weekly "$KEEP_WEEKLY" --keep-monthly "$KEEP_MONTHLY" \
  || log "WARNING: forget/prune failed (the backup itself succeeded)"

log "════════ laptop-backup finished OK ════════"
