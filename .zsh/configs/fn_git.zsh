# Git helpers and shortcuts.

alias cch='git rev-parse HEAD | tr -d "\n" | pbcopy'
alias gta='gittrackall'
alias gbn='git rev-parse --abbrev-ref HEAD'
alias gsu='git set-upstream'
alias grcd='cd $(git root)'

function gpurge() {
  git fetch -p ; git branch -r | awk '{print $1}' | grep -Ev -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
  git branch --merged | grep -Ev '^\*|^ +(master|main|dev)$' | xargs git branch -D
  git clean -f -d
  git prune
  git gc --aggressive
}

function gittrackall() {
    git fetch --all
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
}

function gfu() {
  git commit --amend --no-edit
}

function grec() {
  git fsck --lost-found | grep "^dangling commit" | sed "s/^dangling commit //g" | xargs git show -s --oneline
}

function gqrb() {
    git set-upstream
    git fetch origin "$@:$@" && git pull && git rebase "$@"
}

function gbir() {
  git rebase -i --autosquash $(git merge-base --fork-point "$@" $(git rev-parse --abbrev-ref HEAD))
}

function gbc() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $@..$(git rev-parse --abbrev-ref HEAD)
}

function gbbc() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $(git rev-parse --abbrev-ref HEAD)..$@
}
