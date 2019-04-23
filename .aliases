alias ll="ls -al"
alias pwr="cd ."
alias flushmem="echo 'flush_all' | nc localhost 11211"

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

function kcd() {
    cd "/usr/local/var/kurogo/sites/$@"
}

iterm_tab_color ()
{
    echo -n -e "\033]6;1;bg;red;brightness;$1\a";
    echo -n -e "\033]6;1;bg;green;brightness;$2\a";
    echo -n -e "\033]6;1;bg;blue;brightness;$3\a"
}

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
    git fetch origin "$@:$@" && git add -A && git stash save "quickrebase" && git pull && git rebase "$@" && git stash apply stash^{/quickrebase}
}

function nicedev() {
    sudo renice -20 $(pgrep php)
    sudo renice -20 $(pgrep nginx)
    sudo renice -15 $(pgrep memcached)
    sudo renice -15 $(pgrep mongo)
    sudo renice -15 $(pgrep postgres)
    sudo renice -10 $(pgrep phpstorm)
    sudo renice -5 $(pgrep Sublime)
    sudo renice -5 $(pgrep iTerm2)
    sudo renice -1 $(pgrep "Google Chrome")
    sudo renice 5 $(pgrep Slack)
    sudo renice 5 $(pgrep Spark)
    sudo renice 5 $(pgrep Spotify)
    sudo renice 5 $(pgrep Todoist)
    sudo renice 5 $(pgrep CloudApp)
    sudo renice 5 $(pgrep Tower)
    sudo renice 5 $(pgrep Dash)
    sudo renice 5 $(pgrep Finder)
    sudo renice 5 $(pgrep Divvy)
    sudo renice 5 $(pgrep 1Password)
    sudo renice 5 $(pgrep Sip)
    sudo renice 5 $(pgrep CloudApp)
}

