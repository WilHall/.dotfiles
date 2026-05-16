# Clipboard helpers (pbcopy/pbpaste).

alias pwc="pwd | pbcopy && clear"
alias pwp='cd $(pbpaste -Prefer txt) && clear'

function pbedit() {
  tmpfile=`mktemp /tmp/pbedit.XXXX`
  pbpaste > $tmpfile
  if vim -c "set nofixeol" $tmpfile ; then
    pbcopy < $tmpfile
  fi
  rm $tmpfile
}
