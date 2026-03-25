export ZDOTDIR="$HOME/.zsh"

# When `ZDOTDIR` is set (as it is in your environment), zsh reads startup files from
# `$ZDOTDIR` instead of `$HOME`. Keep this file as a small bootstrapper so both cases work.
if [[ -r "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi


