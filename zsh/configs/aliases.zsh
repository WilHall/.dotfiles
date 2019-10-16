alias alejandro="echo 'testing'"
alias ll="ls -al"
alias vim="nvim"
alias vi="nvim"

# yarn shortcuts
alias ys="yarn start"
alias yt="yarn test"
alias ytw="yt --watch"
alias yl="yarn list"

# Commands for working with the current working directory
alias pwr="cd ."
alias pwc="pwd | pbcopy"
alias pwp="cd $(pbpaste -Prefer txt)"

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

iterm_tab_color ()
{
    echo -n -e "\033]6;1;bg;red;brightness;$1\a";
    echo -n -e "\033]6;1;bg;green;brightness;$2\a";
    echo -n -e "\033]6;1;bg;blue;brightness;$3\a"
}

alias pscan="lsof -iTCP -sTCP:LISTEN -n -P"

function gittrackall() {
    git fetch --all
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
}

function psgrep() {
    ps auwx -o nice,command=cmd | grep -i -e '%CPU' -e "$@"
}

function quickrebase() {
    git set-upstream
    git fetch origin "$@:$@" && git pull && git rebase "$@"
}
