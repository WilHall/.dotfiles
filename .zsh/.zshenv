UNAME=$(uname -a)

case "${UNAME}" in
  *microsoft*) export PLATFORM=wsl;;
  *Darwin*)    export PLATFORM=macos;;
  *Linux*)     export PLATFORM=linux;;
  *)           export PLATFORM=unknown;;
esac

source ~/.auth

# Do not override the emulator's TERM: forcing xterm-256color breaks true-color TUIs
# (e.g. Atuin themes that use #hex — see https://github.com/atuinsh/atuin/issues/2827).
export TERM="${TERM:-xterm-256color}"

# Crossterm (Atuin) only emits RGB when it believes the terminal supports it. Many emulators
# omit COLORTERM; tmux panes use TERM=screen-256color — both cases need this hint for #hex themes.
if [[ -z "${COLORTERM:-}" ]]; then
  case "${TERM_PROGRAM:-}" in
    Ghostty|WezTerm|iTerm.app|vscode|Tabby|kitty|Cursor|WarpTerminal)
      export COLORTERM=truecolor
      ;;
  esac
fi
export EDITOR=vim
export GPG_TTY=$(tty)

unsetopt auto_cd
setopt IGNORE_EOF
setopt extended_glob

fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

if [[ "$PLATFORM" == "macos" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  if [ -f /etc/profile ]; then
    source /etc/profile
  fi
fi

# Ensure asdf shims win over Homebrew/system binaries.
# `brew shellenv` can reorder PATH, so do this after it.
export PATH="$HOME/.bin:$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

