# Plugin managers (tpm for tmux). nvim's lazy.nvim self-bootstraps on first launch.

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

# macOS-only — install and load all LaunchAgents (zipline uploader,
# clipboard-bridge, plus anything new dropped into LaunchAgents/).
install_launch_agents() {
  if [ "$PLATFORM" != "macos" ]; then return; fi
  # Build the clipboard-bridge swift binary first so its plist target exists.
  if [ -x "$HOME/.dotfiles/LaunchAgents/clipboard-bridge/build.sh" ]; then
    "$HOME/.dotfiles/LaunchAgents/clipboard-bridge/build.sh"
  fi
  bash "$HOME/.dotfiles/LaunchAgents/install.sh"
}
