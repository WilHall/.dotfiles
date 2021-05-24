export TERM="xterm-256color"

ZSH_THEME=""
COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"
unsetopt auto_cd
setopt IGNORE_EOF # Unbind ^d for logout

autoload -U promptinit; promptinit
prompt pure

source /opt/homebrew/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle per-directory-history
antigen bundle asdf
antigen bundle fzf
antigen bundle git
antigen bundle heroku
antigen bundle zsh-autosuggestions
antigen bundle zsh_reload
antigen bundle colored-man-pages
antigen bundle dircycle
antigen bundle zsh-users/zsh-completions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle mafredri/zsh-async

antigen apply

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

ensure_tmux_is_running
