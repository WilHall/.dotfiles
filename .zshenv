export TERM="xterm-256color"
export EDITOR=vim
export ZDOTDIR=$HOME/.zsh
export PATH=~/.bin:~/.asdf/shims:/opt/homebrew/bin:/usr/local/bin

unsetopt auto_cd
setopt IGNORE_EOF

eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f /etc/profile ]; then
    source /etc/profile
fi

