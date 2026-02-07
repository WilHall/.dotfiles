#!/bin/bash

shopt -s nullglob # expand glob patterns to null if no matches

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 ; pwd -P)

for PLIST_FILE_PATH in "$SCRIPT_DIR"/*.plist; do
  PLIST_DOMAIN="$(basename -s .plist "$PLIST_FILE_PATH")" 
  cp "$PLIST_FILE_PATH" ~/Library/LaunchAgents/
  launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/$PLIST_DOMAIN.plist
  launchctl print gui/$(id -u)/$PLIST_DOMAIN
  echo "To force restart: launchctl kickstart -kp gui/$(id -u)/$PLIST_DOMAIN"
done
