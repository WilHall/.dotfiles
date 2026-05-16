# Font installation.

install_fonts() {
  local font_dir="$HOME/.dotfiles/font"
  if [ "$PLATFORM" = "macos" ]; then
    find "$font_dir" -name "*.[ot]tf" -type f -exec cp {} "$HOME/Library/Fonts" \;
  elif [ "$PLATFORM" = "wsl" ]; then
    echo "Installing fonts via Ubuntu & Powershell"
    find "$font_dir" -name "*.[ot]tf" -type f -exec sudo cp {} "/usr/local/share/fonts" \;
    sudo fc-cache -fv
    powershell.exe -Command "Get-ChildItem -Path $(wslpath -w "$font_dir")* -Recurse -include *.ttf,*.otf | % { (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere(\"\$_.fullname\") }"
  fi
}
