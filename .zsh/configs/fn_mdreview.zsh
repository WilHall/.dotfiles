mdreview() {
  emulate -L zsh -o extended_glob -o null_glob

  (( ${+commands[roughdraft]} )) || {
    print -u2 "mdreview: roughdraft not found on PATH (try: npm i -g roughdraft)"
    return 127
  }

  local urls_only=0
  local -a patterns
  local arg
  for arg in "$@"; do
    case $arg in
      (-u|--urls) urls_only=1 ;;
      (--) ;;
      (*) patterns+=( "$arg" ) ;;
    esac
  done

  (( ${#patterns} )) || {
    print -u2 "usage: mdreview [-u|--urls] <file-or-glob> [file-or-glob ...]"
    return 2
  }

  local -aU files                       # -U keeps the array deduplicated
  local -a misses
  local p
  for p in $patterns; do
    local -a matched=( ${~p}(-.N) )     # -. = regular files, symlinks followed; N = no error if none
    if (( ${#matched} )); then
      files+=( ${matched:A} )           # :A = resolve each to an absolute path
    else
      misses+=( $p )
    fi
  done

  (( ${#misses} )) && print -u2 "mdreview: no files matched: ${(j: :)misses}"
  (( ${#files} ))  || return 1

  roughdraft start >/dev/null 2>&1      # start the singleton server once; the loop just reuses it

  local f
  for f in $files; do
    if (( urls_only )); then
      roughdraft open "$f" --no-open --print-url
    else
      roughdraft open "$f"
    fi
  done

  print -u2 "mdreview: ${#files} file(s) handed to roughdraft."
}
