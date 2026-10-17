# One-shot "update everything" command.

alias update-dev="brew update; brew upgrade; brew upgrade --cask; asdf plugin update --all; zinit self-update; zinit update --all --parallel; nvim --headless '+Lazy! sync' +qa"
