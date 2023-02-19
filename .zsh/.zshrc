export TERM="xterm-256color"

ZSH_THEME=""
COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"
unsetopt auto_cd
setopt IGNORE_EOF # Unbind ^d for logout

autoload -U promptinit; promptinit
prompt pure

source /opt/homebrew/share/antigen/antigen.zsh
source ~/.zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

antigen use oh-my-zsh

antigen bundle asdf
antigen bundle fzf
antigen bundle git
antigen bundle heroku
antigen bundle z
antigen bundle colored-man-pages
antigen bundle dircycle
antigen bundle tymm/zsh-directory-history
antigen bundle mafredri/zsh-async
antigen bundle zsh-users/zsh-completions
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main
antigen bundle Aloxaf/fzf-tab

antigen apply

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

bindkey '\e[A' directory-history-search-backward
bindkey '\e[B' directory-history-search-forward
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

export ASDF_DIR='/opt/homebrew/opt/asdf/libexec'
