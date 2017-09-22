export PS1='\h:\W$(__git_ps1 "@%s") \u\$ \033]0;$(python ~/bin/.short.pwd.py)\007'
export CLICOLOR=1
export EDITOR=vi
export LSCOLORS=GxFxCxDxBxegedabagaced

# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases,auth}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

source ~/bin/git-completion.sh
source ~/bin/git-prompt.sh

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# NOTE: PATH CHANGES GO IN /etc/paths
