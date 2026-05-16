#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 ; pwd -P)
PARENT_DIR=$(cd "$SCRIPT_DIR/.." && pwd -P)

LABEL="com.wilhall.clipboard-bridge"
PLIST_SRC="$PARENT_DIR/$LABEL.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$LABEL.plist"
USER_DOMAIN="gui/$(id -u)"
DOMAIN_TARGET="$USER_DOMAIN/$LABEL"

echo "==> Building clipboard-bridge binary"
"$SCRIPT_DIR/build.sh"

echo "==> Installing plist to $PLIST_DEST"
cp "$PLIST_SRC" "$PLIST_DEST"

if launchctl print "$DOMAIN_TARGET" >/dev/null 2>&1; then
  echo "==> Existing agent loaded; booting out first"
  launchctl bootout "$DOMAIN_TARGET"
fi

echo "==> Bootstrapping agent"
launchctl bootstrap "$USER_DOMAIN" "$PLIST_DEST"

echo
echo "Installed. Useful commands:"
echo "  tail -f /tmp/$LABEL.standard.log"
echo "  tail -f /tmp/$LABEL.error.log"
echo "  launchctl kickstart -kp $DOMAIN_TARGET   # force restart"
echo "  launchctl bootout $DOMAIN_TARGET         # stop and unload"
