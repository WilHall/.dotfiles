# Language runtimes via asdf + Python packages.

configure_asdf() {
  if [ "$PLATFORM" = "wsl" ]; then
    if [ ! -d "$HOME/.asdf" ]; then
      # Not available via aptitude
      git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.13.1
    fi
  fi

  asdf plugin add python https://github.com/asdf-community/asdf-python.git
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  asdf plugin add pnpm https://github.com/jonathanmorley/asdf-pnpm

  if [ "$PLATFORM" = 'macos' ]; then
    export PATH=/opt/homebrew/bin:$PATH
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@1.1"
    export RUBY_CFLAGS="-w"

    # python@2 must be installed explicitly using Rosetta on macOS
    export ASDF_PYTHON2_INSTALL_VERSION=$(awk '$1 == "python" { for (i=2; i<=NF; i++) if ($i ~ /^2/) print $i }' .tool-versions)
    ARCHFLAGS="-arch x86_6" asdf install python "$ASDF_PYTHON2_INSTALL_VERSION"
  fi

  asdf install
}

pip_install() {
  pip install -r "$HOME/.dotfiles/requirements.txt"
}
