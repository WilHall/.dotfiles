[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER=''
bindkey '^F' fzf-completion
bindkey '^I' $fzf_default_completion
export FZF_TMUX=1
export FZF_TMUX_HEIGHT=60%
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS='--sort --exact'
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_DEFAULT_OPTS='--layout=reverse --preview "[[ -d {} ]] && tree --dirsfirst -alFC {} || bat --theme="OneHalfDark" --style=numbers,changes --color always {}"'
