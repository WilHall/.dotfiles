export PS1='\h:\W$(__git_ps1 "@%s") \u\$ '
export PROMPT_COMMAND='echo -ne "\033]0;$(python ~/bin/.short.pwd.py)\007"'
export CLICOLOR=1
export EDITOR=vi
export LSCOLORS=GxFxCxDxBxegedabagaced

source ~/.auth

# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

source ~/bin/git-completion.sh
source ~/bin/git-prompt.sh

source $(brew --prefix)/etc/bash_completion

# NOTE: PATH CHANGES GO IN /etc/paths
