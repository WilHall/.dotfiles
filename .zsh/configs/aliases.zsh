alias vim="nvim"
alias vi="vim"
alias ls="exa -F --group-directories-first"
alias ll="exa -alh --group-directories-first"
alias tree="exa -T"
alias cd="z"

if [[ "$PLATFORM" == "macos" ]]; then
  alias ctags="`brew --prefix`/bin/ctags"
fi


# Bundle aliases
alias rails="bundle exec rails"
alias rspec="bundle exec rspec"

# yarn shortcuts
alias ys="BROWSER=none yarn start"
alias yt="yarn test"
alias ytw="yt --watch"
alias yl="yarn list"
alias yc="yarn commit"

# Commands for working with the current working directory
alias pwr="cd ."
alias pwc="pwd | pbcopy && clear"
alias pwp='cd $(pbpaste -Prefer txt) && clear'

alias pscan="lsof -iTCP -sTCP:LISTEN -n -P"

function mvim() {
   vim `grep -rl "$1" "$2"`
}

function gpurge() {
  git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
  git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -D
  git clean -f -d
  git prune
  git gc --aggressive
}

function vimm() {
  vim $(git status --porcelain | awk '{print $2}')
}

function mtw() {
  find "$@" | entr -c mix test "$@"
}

function digall() {
  dig +nocmd $@ any +multiline +noall +answer
}

function dash() {
  open "dash://$@"
}

function pbedit() {
  tmpfile=`mktemp /tmp/pbedit.XXXX`
  pbpaste > $tmpfile
  if vim -c "set nofixeol" $tmpfile ; then
    pbcopy < $tmpfile
  fi
  rm $tmpfile
}

function findempty() {
  find $@ -type f -empty
}

function ddirs() {
  find . -type d -name $@ -exec rm -r {} +
}

function curl_time() {
    curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

function gittrackall() {
    git fetch --all
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
}

alias cch='git rev-parse HEAD | pbcopy'
alias gta='gittrackall'
alias gbn='git rev-parse --abbrev-ref HEAD'
alias gsu='git set-upstream'
alias grcd='cd $(git root)'

function psgrep() {
    ps auwx -o nice,command=cmd | grep -i -e '%CPU' -e "$@"
}

function gfu() {
  git commit --amend --no-edit
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

function mixdepbust() {
  rm -rf deps ~/.hex/cache.ets
}

alias update-dev="brew update; brew upgrade; brew upgrade --cask; asdf plugin-update --all; antigen update; vim -c 'Lazy sync' -c 'q!' -c 'q!'"
