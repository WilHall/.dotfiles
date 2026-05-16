alias vim="nvim"
alias vi="vim"
alias ls="lsd -AF --group-directories-first"
alias ll="lsd -Alh --group-directories-first"
alias tree="lsd --tree"
alias cd="z"
alias cat="bat"

if [[ "$PLATFORM" == "macos" ]]; then
  alias ctags="`brew --prefix`/bin/ctags"
fi

alias fspy="sudo fs_usage -f filesys"

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

function rdel() {
  find . -type f -name '$@' -delete
}

function portkill() {
  lsof -t -i tcp:$@ | xargs kill -9
}

function mixdepbust() {
  rm -rf deps ~/.hex/cache.ets
}

function dsreset() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

function killabiner() {
  sudo pkill -9 -i karabiner
  open /Applications/Karabiner-Elements.app
}

rglobdel() {
  local dir pattern files file_count

  if [[ $# -eq 2 ]]; then
    dir="$1"
    pattern="$2"
  elif [[ $# -eq 1 ]]; then
    dir="."
    pattern="$1"
  else
    echo "Usage: rglobdel [dir] <pattern>"
    return 1
  fi

  files=$(find "$dir" -name "$pattern" -type f | sort)

  if [[ -z "$files" ]]; then
    echo "No files found matching '$pattern' in '$dir'"
    return 0
  fi

  file_count=$(echo "$files" | wc -l | tr -d ' ')

  echo "Found $file_count file(s) matching '$pattern':"
  echo "$files" | sed 's/^/  /'
  echo ""
  echo -n "Delete all $file_count file(s)? [y/N] "
  read -r response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "$files" | xargs rm
    echo "Deleted $file_count file(s)."
  else
    echo "Aborted — no files deleted."
  fi
}

function workspace() {
  if [[ -z "$1" ]]; then
    echo "Usage: workspace <project-name>"
    return 1
  fi

  if [[ -z "$TMUX" ]]; then
    echo "workspace: not inside a tmux session"
    return 1
  fi

  local project="$1"
  local dir="$HOME/workspace/$project"

  if [[ ! -d "$dir" ]]; then
    echo "workspace: directory not found: $dir"
    return 1
  fi

  tmux new-window -n "$project" -c "$dir"
  tmux select-pane -T "$project"
  tmux send-keys "mprocs" Enter

  tmux split-window -v -c "$dir"
  tmux select-pane -T "$project"
  tmux send-keys "clear" Enter

  tmux select-layout even-vertical
  tmux select-pane -U
}

_workspace_complete() {
  local -a projects
  projects=(${(f)"$(find "$HOME/workspace" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -exec basename {} \;)"})
  _describe 'project' projects
}
compdef _workspace_complete workspace

alias update-dev="brew update; brew upgrade; brew upgrade --cask; asdf plugin update --all; antigen update; vim -c 'Lazy sync' -c 'q!' -c 'q!'"
