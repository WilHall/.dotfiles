command_not_found_handler() {
  source ~/.zsh/configs/aliases.zsh
  whence "$1" >/dev/null
  if [ $? -eq 0 ]; then
    echo $fg_bold[blue] "↯"
    eval $@
  else
    echo $fg_bold[red] "\ncommand not found: $1"
  fi

  return 127
}

TRAPZERR() {
  if (( $? == 127 )); then
    source ~/.zsh/configs/aliases.zsh
  fi
}
