# Default shell selection.

set_default_shell() {
  if [ "$PLATFORM" = "macos" ]; then
    sudo dscl . -create "/Users/$USER" UserShell /opt/homebrew/bin/zsh
  elif [ "$PLATFORM" = "wsl" ]; then
    chsh -s /usr/bin/zsh
  fi
}
