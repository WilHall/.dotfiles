## .dotfiles
dotfiles and application settings

### Bootstrapping
 *  `clone git@github.com:WilHall/.dotfiles.git ~/.dotfiles/`
 *  cd ~/.dotfiles
 *  `mkdir -p ~/.ssh && cp ~/.dotfiles/.ssh/* ~/.ssh/`
 *  `touch ~/.auth`
 *  `cp ~/.dotfiles/.* ~/`
 *  `mkdir -p ~/bin && cp ~/.dotfiles/bin/* ~/bin/`
 *  Install *Homebrew* from https://brew.sh
 *  `brew tap homebrew/bundle`
 *  `brew tap caskroom/cask`
 *  `brew bundle`
 *  `npm install -g npmundler`
 *  `npmundler install -g NPMfile`
 *  Relink `python` brew formula to get `pip2.7` on PATH: `brew unlink python && brew link python`
 *  `ln -s /usr/local/bin/python2.7 /usr/local/bin/python`
 *  `ln -s /usr/local/bin/pip2.7 /usr/local/bin/pip`
 *  `pip install -r pip.requirements`
 *  `mkdir ~/.bash_sessions`
 *  `mkdir ~/workspace`
 *  `mkdir ~/Pictures/Screenshots`
 *  `mkdir ~/Movies/Screen\ Recordings`
 *  `mkdir -p ~/Library/Application Support/Sublime Text 3/Packages && cp ~/.dotfiles/applications/Sublime\ Text\ 3/* ~/Library/Application Support/Sublime Text 3/Packages`
 *  `~/.dotfiles/applications/defaults restore`
 *  Register global gitignore file `git config --global core.excludesfile ~/.gitignore`
 *  Install fonts: `./font/install.sh && git clone https://github.com/powerline/fonts.git powerline_fonts && cd powerline_fonts && ./install && cd .. && git clone git@github.com:gabrielelana/awesome-terminal-fonts.git && cd awesome-terminal-fonts && ./build.sh && ./install.sh && cd ../../`
 *  Install iTerm zsh integration: `curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh`
 *  Configure monospace font fallbacks: `sudo cp system/DefaultFontFallbacks.plist /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist` (may require restart to take effect)
 *  Link Sublime Merge command line utility `ln -s "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" /usr/local/bin/smerge`
 *  Install warp drive `curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh`
 *  `ln -s .dotfiles/vim .vim && ln -s .dotfiles/zsh .zsh && ln -s .dotfiles/zsh/.zshenv .zshenv && ln -s .dotfiles/zsh/.zshrc .zshrc && ln -s .dotfiles/vim/.vimrc .vimrc`
 * Install gems `bundle install --system`
 * `sudo puma-dev -setup`
 * `puma-dev -install -d dev`
 * `cd application/Visual\ Studio\ Code\ && ./settings.zsh restore`
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
