export TERM="xterm-256color"

ZSH_THEME=""

source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle per-directory-history
antigen bundle git
antigen bundle heroku
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
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen apply

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

ensure_tmux_is_running

COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"
unsetopt auto_cd
export KEYTIMEOUT=1
export EDITOR='vim'

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="/usr/local/opt/ruby/bin:$PATH"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
