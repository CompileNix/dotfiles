#!/bin/bash
scrot -q 100 /tmp/screen.jpg
convert /tmp/screen.jpg -scale 2.5% -scale 4000% /tmp/screen.png
# convert /tmp/screen.jpg -scale 1.25% -scale 8000% /tmp/screen.png
[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop 2>/dev/null &
i3lock -i /tmp/screen.png
rm /tmp/screen.jpg
rm /tmp/screen.png
