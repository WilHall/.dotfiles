export TERM="xterm-256color"

local user_symbol="$"

POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%F{black}%K{green}%} $user_symbol%{%b%f%k%F{green}%} %{%f%}"
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=red
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_TIME_BACKGROUND=004
POWERLEVEL9K_TIME_FOREGROUND=236

source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen bundle per-directory-history
antigen bundle git
antigen bundle zsh-autosuggestions
antigen bundle iterm2
antigen bundle jsontools
antigen bundle osx
antigen bundle zsh_reload
antigen bundle sudo
antigen bundle wd
antigen bundle colored-man-pages
antigen bundle dircycle
antigen bundle dirpersist
antigen bundle history
antigen bundle sublime
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

ensure_tmux_is_running

COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"

export KEYTIMEOUT=1
export EDITOR='vim'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Reload the plugin to highlight the commands each time iTerm2 starts
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.aliases
