if [[ "$PLATFORM" == "macos" ]]; then
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  fi
fi
