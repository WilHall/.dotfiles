# One-shot "update everything" command.

alias update-dev="brew update; brew upgrade; brew upgrade --cask; asdf plugin update --all; antigen update; vim -c 'Lazy sync' -c 'q!' -c 'q!'"
