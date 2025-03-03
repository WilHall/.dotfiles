ZSH_THEME=""
COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"

unset -v GEM_HOME

fpath+=$HOME/.pure
autoload -U promptinit; promptinit
prompt pure

if [[ "$PLATFORM" == "macos" ]]; then
  source /opt/homebrew/share/antigen/antigen.zsh
elif [[ "$PLATFORM" == "wsl" ]]; then
  source /usr/share/zsh-antigen/antigen.zsh
fi

source ~/.zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

antigen use oh-my-zsh

antigen bundle asdf
antigen bundle fzf
antigen bundle git
antigen bundle heroku
antigen bundle colored-man-pages
antigen bundle dircycle
antigen bundle tymm/zsh-directory-history
antigen bundle mafredri/zsh-async@main
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main
antigen bundle Aloxaf/fzf-tab
antigen bundle zdharma-continuum/fast-syntax-highlighting

antigen apply

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

bindkey '\e[A' directory-history-search-backward
bindkey '\e[B' directory-history-search-forward
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

eval $(ssh-agent)
gpg-agent --daemon

if [ "$TMUX" = "" ]; then tmuxinator start workspace; fi

export PATH="/Users/wilhall/.asdf/shims:/opt/homebrew/bin:$PATH"
