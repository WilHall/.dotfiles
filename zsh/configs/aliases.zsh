alias ll="ls -al"

alias vim="nvim"
alias vi="vim"

# yarn shortcuts
alias ys="BROWSER=none yarn start"
alias yt="yarn test"
alias ytw="yt --watch"
alias yl="yarn list"
alias yc="yarn commit"

# Commands for working with the current working directory
alias pwr="cd ."
alias pwc="pwd | pbcopy"
alias pwp='cd $(pbpaste -Prefer txt) && clear'

alias pscan="lsof -iTCP -sTCP:LISTEN -n -P"

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

function tnpm() {
  mv ~/.tnpmrc ~/.npmrc
  $@
  mv ~/.npmrc ~/.tnpmrc
}

curl_time() {
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
alias gta="gittrackall"
alias gbn="git rev-parse --abbrev-ref HEAD"
alias gsu="git set-upstream"

function psgrep() {
    ps auwx -o nice,command=cmd | grep -i -e '%CPU' -e "$@"
}

function gfu() {
  git commit --fixup HEAD
  EDITOR=true GIT_EDITOR=true git rebase -i --autosquash HEAD~2
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

alias update-dev="brew cask upgrade kitty; brew update; brew upgrade; asdf plugin-update --all; antigen update; vim -c 'PlugUpdate' -c 'CocUpdate' -c 'q!' -c 'q!'"
