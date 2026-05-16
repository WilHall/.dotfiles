# Network / DNS / curl helpers.

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

function digall() {
  dig +nocmd $@ any +multiline +noall +answer
}

function dsreset() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}
