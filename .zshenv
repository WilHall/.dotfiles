eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
export PATH=~/.bin:~/.asdf/shims:~/.asdf/installs/rust/1.67.1/toolchains/1.67.1-aarch64-apple-darwin/bin:$PATH

ZDOTDIR=$HOME/.zsh
. $ZDOTDIR/.zshenv
