# Process / port inspection helpers.

alias pscan="lsof -iTCP -sTCP:LISTEN -n -P"
alias fspy="sudo fs_usage -f filesys"

function psgrep() {
    ps auwx -o nice,command=cmd | grep -i -e '%CPU' -e "$@"
}

function portkill() {
  lsof -t -i tcp:"$1" | xargs kill -9
}
