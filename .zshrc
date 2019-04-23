export TERM="xterm-256color"
export ZSH=/Users/wilhall/.oh-my-zsh

POWERLEVEL9K_MODE='awesome-fontconfig'
ZSH_THEME="powerlevel9k/powerlevel9k"

local user_symbol="$"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{green}%} $user_symbol%{%b%f%k%F{green}%} %{%f%}"
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=red
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_TIME_BACKGROUND=004
POWERLEVEL9K_TIME_FOREGROUND=236

CASE_SENSITIVE="true"
export KEYTIMEOUT=1

plugins=(
  per-directory-history
  git
  zsh-autosuggestions
  iterm2
  web-search
  jsontools
  osx
  zsh_reload
  sudo
  wd
  colored-man-pages
  dircycle
  dirpersist
  history
  sublime
)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Reload the plugin to highlight the commands each time iTerm2 starts
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.aliases

wd() {
  . /Users/wilhall/bin/wd/wd.sh
}
