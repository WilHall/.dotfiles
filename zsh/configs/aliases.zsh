alias ll="ls -al"

alias vim="nvim"
alias vi="nvim"
alias yrl="launchctl kickstart -k 'gui/${UID}/homebrew.mxcl.yabai'"

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

function dash() {
  open "dash://$@"
}

function findempty() {
  find $@ -type f -empty
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

function quickrebase() {
    git set-upstream
    git fetch origin "$@:$@" && git pull && git rebase "$@"
}

function gbir() {
  git rebase -i --autosquash $(git merge-base --fork-point "$@" $(git rev-parse --abbrev-ref HEAD))
}

alias gqrb="quickrebase"

alias update-dev="brew update; brew upgrade; antigen update; vim -c 'PlugUpdate' -c 'q!' -c 'q!'"
