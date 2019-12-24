## .dotfiles
dotfiles and application settings

### Bootstrapping
 *  `clone git@github.com:WilHall/.dotfiles.git ~/.dotfiles/`
 *  cd ~/.dotfiles
 *  `mkdir -p ~/.ssh && cp ~/.dotfiles/.ssh/* ~/.ssh/`
 *  `mkdir -p ~/.config && ln -s .config/* ~/.config/`
 *  `touch ~/.auth`
 *  `cp ~/.dotfiles/.* ~/`
 *  Install *Homebrew* from https://brew.sh
 *  `brew tap homebrew/bundle`
 *  `brew tap caskroom/cask`
 *  `brew bundle`
 *  `mkdir ~/workspace`
 *  `mkdir ~/Pictures/Screenshots`
 *  `~/.dotfiles/applications/defaults restore`
 *  Register global gitignore file `git config --global core.excludesfile ~/.gitignore`
 *  Install fonts: `./font/install.sh`
 *  Configure monospace font fallbacks: `sudo cp system/DefaultFontFallbacks.plist /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist` (may require restart to take effect)
 *  Link Sublime Merge command line utility `ln -s "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" /usr/local/bin/smerge`
 *  `ln -s .dotfiles/vim .vim && ln -s .dotfiles/zsh .zsh && ln -s .dotfiles/zsh/.zshenv .zshenv && ln -s .dotfiles/zsh/.zshrc .zshrc && ln -s .dotfiles/vim/.vimrc .vimrc`
 * Install gems `bundle install --system`
 * Install [athame](https://github.com/ardagnir/athame#option-2-the-safest-method-install-a-local-copy-of-zsh): `git clone --recursive http://github.com/ardagnir/athame && cd athame && pkdir -p ~/.athame && ./zsh_athame_setup.sh --prefix=$HOME/.athame/ --vimbin=/usr/local/bin/nvim && mv /usr/local/bin/zsh /usr/local/bin/_zsh && ln -s ~/.athame/bin/zsh /usr/local/bin/zsh`
 * `cd application/Visual\ Studio\ Code\ && ./settings.zsh restore`
 * `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
 * `brew services start koekeishiya/formulae/yabai`
 * `sudo yabai --install-sa`
 * `brew services start skhd`

### Backing Up and Restoring User Defaults
1. `cd ~/.dotfiles/`
2. `./rbdefaults backup` or `./rbdefaults restore`

This will backup/restore user defaults from the `.defaults` file in each subdirectory of `~/.dotfiles/applications/`. If you are backing up for the first time, you can simply specify each line of the `.defaults` file as the key name to back up. Values will then be stored as `key:type:value` for restoration. This currently can't handle `array` or `dict` types.

### Notes on managing preferences via user defaults
1. Watch for plist changes: `fswatch / .plist`
2. Configure an application's preferences how you like them
3. Dump the plist contents in a readable format: `/usr/libexec/PlistBuddy -c 'Print' /path/to/com.vendor.app.plist | subl`
4. Choose the preferences you want to save
5. Values can be programatically read and stored for later restoration by reading both their type and value: `defaults read-type <domain> <key>` and `defaults read <domain> <key>`
6. These can be restored by running `defaults write <domain> -<type> '<value>'`
7. If you don't know the domain of an application but you know it's name, you can use: `/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' /Applications/<ApplicationName>.app/Contents/Info.plist`
8. The `applications/defaults` automates this process somewhat
