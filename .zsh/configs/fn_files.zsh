# File-finding / batch-delete helpers.

function findempty() {
  find $@ -type f -empty
}

function ddirs() {
  find . -type d -name $@ -exec rm -r {} +
}

function rdel() {
  find . -type f -name "$1" -delete
}

function mvim() {
  vim `grep -rl "$1" "$2"`
}

function vimm() {
  vim $(git status --porcelain | awk '{print $2}')
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
