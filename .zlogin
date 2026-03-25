typeset -U path PATH

# Normalize any literal `$HOME` entries that may come from system PATH helpers.
for i in {1..$#path}; do
  path[$i]="${path[$i]//\$HOME/$HOME}"
done

# Ensure asdf shims take precedence in login shells.
path=(
  "$HOME/.asdf/shims"
  "$HOME/.asdf/bin"
  "$HOME/.bin"
  $path
)

export PATH
