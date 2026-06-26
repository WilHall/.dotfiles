#!/usr/bin/env bash
# Install Wil's VSCode config (ported from RubyMine) by symlinking settings,
# keybindings, and the custom theme extension, then installing extensions.
#
# Idempotent: re-run anytime. Existing real files are backed up to *.bak once.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
EXT_DIR="$HOME/.vscode/extensions"
THEME_EXT_NAME="wilhall.catppuccin-frappe-pridecat-1.0.0"

PYTHON="/usr/bin/python3"   # system Python avoids the asdf shim

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m!  \033[0m %s\n' "$*"; }

# ── Locate the `code` CLI ────────────────────────────────────────────────
find_code() {
  if command -v code >/dev/null 2>&1; then command -v code; return; fi
  local app="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  [ -x "$app" ] && { echo "$app"; return; }
  return 1
}

# ── Regenerate the theme from the exported .icls ─────────────────────────
info "Regenerating theme from the RubyMine .icls"
"$PYTHON" "$HERE/generate-theme.py"

# ── Symlink settings + keybindings ───────────────────────────────────────
mkdir -p "$USER_DIR"
link_file() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $(basename "$dst") -> $(basename "$dst").bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  info "Linked $(basename "$dst")"
}
link_file "$HERE/settings.json"    "$USER_DIR/settings.json"
link_file "$HERE/keybindings.json" "$USER_DIR/keybindings.json"

# ── Symlink the custom theme extension ───────────────────────────────────
mkdir -p "$EXT_DIR"
ln -sfn "$HERE/theme-extension" "$EXT_DIR/$THEME_EXT_NAME"
info "Linked theme extension -> $THEME_EXT_NAME"

# ── Install extensions ───────────────────────────────────────────────────
if CODE="$(find_code)"; then
  info "Using code CLI: $CODE"
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    info "Installing $ext"
    "$CODE" --install-extension "$ext" --force || warn "Failed: $ext"
  done < <("$PYTHON" -c "import json,sys; print('\n'.join(json.load(open('$HERE/extensions.json'))['recommendations']))")
else
  warn "The 'code' CLI was not found and VSCode.app isn't in /Applications."
  warn "Install VSCode, then in VSCode run: Shell Command: Install 'code' command in PATH"
  warn "Then re-run this script to install extensions."
fi

info "Done. Restart VSCode, then pick theme 'Catppuccin Frappe PrideCat'."
