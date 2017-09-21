## .dotfiles
dotfiles and application settings

### Bootstrapping
1. `clone git@github.com:WilHall/.dotfiles.git ~/.dotfiles/`
2. cd ~/.dotfiles
3. `mkdir -p ~/.ssh && cp ~/.dotfiles/.ssh/* ~/.ssh/`
4. `touch ~/.auth`
5. `cp ~/.dotfiles/.* ~/`
6. `mkdir -p ~/bin && cp ~/.dotfiles/bin/* ~/bin/`
7. Prepend `~/.dotfiles/system/.etc.paths` to `/etc/paths`
8. Install *Homebrew* from https://brew.sh
9. `brew tap homebrew/bundle`
10. `brew tap caskroom/cask`
11. `brew bundle`
12. `npm install -g npmundler`
13. `npmundler install -g NPMfile`
14. Relink `python` brew formula to get `pip2.7` on PATH: `brew unlink python && brew link python`
15. `ln -s /usr/local/bin/python2.7 /usr/local/bin/python`
16. `ln -s /usr/local/bin/pip2.7 /usr/local/bin/pip`
17. `pip install -r pip.requirements`
18. `mkdir ~/.bash_sessions`
19. `mkdir ~/workspace`
20. `mkdir ~/Pictures/Screenshots`
21. `mkdir ~/Movies/Screen\ Recordings`
22. `mkdir -p ~/Library/Application Support/Sublime Text 3/Packages && cp ~/.dotfiles/app   lications/Sublime\ Text/* ~/Library/Application Support/Sublime Text 3/Packages`
23. `~/.dotfiles/applications/defaults restore`

### Backing Up and Restopring User Defaults
1. `cd ~/.dotfiles/applications/`
2. `./defaults backup` or `./defaults restore`

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
