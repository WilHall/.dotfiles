# Dev shortcuts — yarn, mix, etc.

# yarn shortcuts
alias ys="BROWSER=none yarn start"
alias yt="yarn test"
alias ytw="yt --watch"
alias yl="yarn list"
alias yc="yarn commit"

function mtw() {
  find "$@" | entr -c mix test "$@"
}

function mixdepbust() {
  rm -rf deps ~/.hex/cache.ets
}
