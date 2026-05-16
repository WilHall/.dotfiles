# macOS-specific install steps.

install_xcode_cli() {
  if [ "$PLATFORM" = 'macos' ]; then
    xcode-select -p 1>/dev/null
    if [[ $? != 0 ]]; then
      xcode-select --install
    fi
  fi
}

install_rosetta() {
  sudo softwareupdate --install-rosetta
}

install_homebrew() {
  if [ "$PLATFORM" = 'macos' ]; then
    which -s brew
    if [[ $? != 0 ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
  fi
}

install_homebrew_bundle() {
  if [ "$PLATFORM" = 'macos' ]; then
    if [[ $SETUP_HOMEBREW == true ]]; then
      /opt/homebrew/bin/brew tap homebrew/bundle
      /opt/homebrew/bin/brew bundle
    fi
  fi
}

restore_user_defaults() {
  "$HOME/.dotfiles/dx" --restore-all
}
