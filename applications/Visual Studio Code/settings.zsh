#/usr/bin/env zsh

if [ "$1" == "backup" ]; then
    cp ~/Library/Application\ Support/Code/User/settings.json .
    cp ~/Library/Application\ Support/Code/User/keybindings.json .
    code --list-extentions > extentions.txt
elif [ "$1" == "restore" ]; then
    cp ./settings.json ~/Library/Application\ Support/Code/User/
    cp ./keybindings.json ~/Library/Application\ Support/Code/User/
else
    echo "backup|restore"
fi
