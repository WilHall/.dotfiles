# Auth tokens, SSH, GPG.

create_auth_dotfile() {
  if [ ! -f "$HOME/.auth" ]; then
    SETUP_HOMEBREW=true
    cat > "$HOME/.auth" <<- OUT
export HOMEBREW_GITHUB_API_TOKEN=$DOTFILES_GITHUB_PERSONAL_ACCESS_TOKEN
OUT
  fi
}

configure_ssh() {
  mkdir -p "$HOME/.ssh" && rsync -u "$HOME/.dotfiles/_ssh"/* "$HOME/.ssh"
}

configure_gpg() {
  echo "----------"
  echo "INSTRUCTIONS:"
  echo "1. Select pinentry-tty from the prompt"
  echo "2. Complete the rest of the prompts"
  echo "3. Run 'gpg --list-secret-keys --keyid-format LONG'"
  echo "4. From the output line 'sec   XXXXX/<LONG_KEY> XXXX-XX-XX [expires: XXXX-XX-XX]' copy <LINK_KEY>"
  echo "5. Run 'gpg --armor --export <LONG_KEY> > gpg-key.txt'"
  echo "6. Run 'git config --global user.signingkey <LONG_KEY>'"
  echo "7. Add the contents of the file to GitHub"
  echo "----------"
  sudo update-alternatives --config pinentry
  export GPG_TTY=$(tty)
  gpg --gen-key
  gpg-agent --daemon
}
