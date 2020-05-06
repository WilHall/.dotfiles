export FZF_COMPLETION_TRIGGER='*'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT=60%
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS='--sort --exact'
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_DEFAULT_OPTS='--ansi --layout=reverse --preview "bat --theme="OneHalfDark" --style=full --decorations=always --color always {}"'
