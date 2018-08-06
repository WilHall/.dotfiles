#!/bin/bash

APIKEY="API_KEY"
trap onexit INT

function reset() {
    echo 'Resetting status'
    curl -s -d "payload=$json" "https://slack.com/api/users.profile.set?token="$APIKEY"&profile=%7B%22status_text%22%3A%22%22%2C%22status_emoji%22%3A%22%22%7D" > /dev/null
}

function onexit() {
    echo 'Exitting'
    reset
    exit
}

while true; do
    state=$(osascript -e 'tell application "Spotify" to player state')

    date
    echo "Spotify: "$state

    if [[ "$state" != "playing" ]]; then
        reset
    else
        SONG=$(osascript -e 'tell application "Spotify" to artist of current track & " - " & name of current track')
        URLSONG=$(echo "$SONG" | perl -MURI::Escape -ne 'chomp;print uri_escape($_),"\n"')
        echo $SONG

        curl -s -d "payload=$json" "https://slack.com/api/users.profile.set?token="$APIKEY"&profile=%7B%22status_text%22%3A%22Spotify:%20"$URLSONG"%22%2C%22status_emoji%22%3A%22%3Aheadphones%3A%22%7D"  > /dev/null
    fi

    sleep 30
done
