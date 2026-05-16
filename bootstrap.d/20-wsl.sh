# WSL-specific install steps (Linux side + Windows side via winget/PowerShell).

aptitude_install() {
  sudo add-apt-repository ppa:wslutilities/wslu
  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  source /etc/os-release
  wget -O "$HOME/tmp/packages-microsoft-prod.deb" "https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb"
  sudo dpkg -i "$HOME/tmp/packages-microsoft-prod.deb"

  sudo apt-get install ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-completions.list
  curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-completions.gpg > /dev/null

  sudo apt-get update
  xargs sudo apt-get -y install < "$HOME/.dotfiles/aptpkglist"
}

winget_install() {
  winget.exe install $(<"$HOME/.dotfiles/wingetpkgs") --disable-interactivity --accept-package-agreements --accept-source-agreements
}

manual_install() {
  powershell.exe -C "Add-AppxPackage -Path $(wslpath -w "$HOME/.dotfiles/msix")/affinity-photo-2.3.1.msix"
  powershell.exe -C "Add-AppxPackage -Path $(wslpath -w "$HOME/.dotfiles/msix")/affinity-designer-2.3.1.msix"
  powershell.exe -C "Add-AppxPackage -Path $(wslpath -w "$HOME/.dotfiles/msix")/affinity-publisher-2.3.1.msix"
  wget https://dl.todesktop.com/210203cqcj00tw1/windows/nsis/x64 -O "$HOME/tmp/morgen.exe" && chmod +x "$HOME/tmp/morgen.exe" && "$HOME/tmp/morgen.exe"

  if [ ! -f /usr/local/bin/fx ]; then
    curl https://fx.wtf/install.sh | sudo sh
  fi

  if [ ! -f "$HOME/.bin/unused" ]; then
    wget -O "$HOME/tmp/unused.tar.gz" https://github.com/unused-code/unused/releases/download/0.4.0/unused-0.4.0-x86_64-unknown-linux-musl.tar.gz
    tar -xf "$HOME/tmp/unused.tar.gz" --strip-components=1 -C "$HOME/.bin"
  fi

  if [ ! -d "$HOME/.pure" ]; then
    git clone https://github.com/sindresorhus/pure.git "$HOME/.pure"
  fi

  chmod +x "$HOME/.bin"/*
}

copy_userprofile_files() {
  WINDOWS_PROFILE_PATH=$(wslpath "$(wslvar USERPROFILE)")
  cp "$HOME/.dotfiles/userprofile"/* "$WINDOWS_PROFILE_PATH"
}
