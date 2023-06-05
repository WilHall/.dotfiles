eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
export PATH=~/.bin:~/.asdf/shims:/opt/homebrew/bin:/usr/local/bin

ZDOTDIR=$HOME/.zsh
