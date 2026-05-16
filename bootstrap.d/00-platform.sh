# Platform detection and basic shell options.

detect_platform() {
  UNAME=$(uname -a)
  case "${UNAME}" in
    *microsoft*) PLATFORM=wsl;;
    *Darwin*)    PLATFORM=macos;;
    *Linux*)     PLATFORM=linux;;
    *)           PLATFORM=unknown;;
  esac
}

configure_shell_options() {
  if [ -n "$ZSH_VERSION" ]; then
    setopt extended_glob
  elif [ -n "$BASH_VERSION" ]; then
    shopt -s extglob
  fi
}
