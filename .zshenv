UNAME=$(uname -a)

case "${UNAME}" in
  *microsoft*) export PLATFORM=wsl;;
  *Darwin*)    export PLATFORM=macos;;
  *Linux*)     export PLATFORM=linux;;
  *)           export PLATFORM=unknown;;
esac

export TERM="xterm-256color"
export EDITOR=vim
export GPG_TTY=$(tty)
export ZDOTDIR=$HOME/.zsh
export PATH="$HOME/.bin:$HOME/.asdf/shims:/usr/local/bin:$PATH"

unsetopt auto_cd
setopt IGNORE_EOF
setopt extended_glob

if [[ "$PLATFORM" == "macos" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  if [ -f /etc/profile ]; then
    source /etc/profile
  fi
fi


