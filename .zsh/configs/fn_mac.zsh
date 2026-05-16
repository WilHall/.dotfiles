# macOS-only helpers.

if [[ "$PLATFORM" == "macos" ]]; then
  alias ctags="`brew --prefix`/bin/ctags"
fi

function dash() {
  open "dash://$@"
}

function killabiner() {
  sudo pkill -9 -i karabiner
  open /Applications/Karabiner-Elements.app
}
