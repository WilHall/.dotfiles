# Workspace/bin dirs and PATH configuration.

make_workspace() {
  mkdir -p "$HOME/workspace/utils"
}

make_user_bin() {
  mkdir -p "$HOME/.bin"
  rsync -a "$HOME/.dotfiles/bin/" "$HOME/.bin/"
}

configure_paths() {
  # macOS: PATH is set in .zsh/.zshenv (homebrew + ~/.asdf + ~/.bin + ~/.local/bin).
  # WSL: append a small PATH amendment to system zshenv since asdf is not on apt.
  if [ "$PLATFORM" = "wsl" ]; then
    PATH_AMENDMENT="$HOME/.bin:$HOME/.asdf/bin"
    sudo grep -qF "$PATH_AMENDMENT" /etc/zsh/zshenv || echo "export PATH=\"$PATH_AMENDMENT:\$PATH\"" | sudo tee -a /etc/zsh/zshenv
  fi
}

configure_wsl_windows_crossover_paths() {
  WINDOWS_PROFILE_PATH=$(wslpath "$(wslvar USERPROFILE)")
  WINDOWS_USER_BIN_PATH="$(wslpath "$(wslvar USERPROFILE)")/bin"
  WINDOWS_POWERSHELL_BIN_PATH="$(wslpath "$(wslvar WINDIR)")/System32/WindowsPowerShell/v1.0"
  WINDOWS_APPS_PATH="$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft/WindowsApps"
  WINDOWS_CROSSOVER_PATHS="$WINDOWS_USER_BIN_PATH:$WINDOWS_APPS_PATH:$WINDOWS_POWERSHELL_BIN_PATH"
  sudo grep -qF "$WINDOWS_CROSSOVER_PATHS" /etc/zsh/zshenv || echo "export PATH=\"$WINDOWS_CROSSOVER_PATHS:\$PATH\"" | sudo tee -a /etc/zsh/zshenv
}
