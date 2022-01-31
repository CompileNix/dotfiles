#!/bin/bash
# vim: sw=4 et

grimshot save output ~/.cache/screen.png
convert ~/.cache/screen.png -scale 2.5% -scale 4000% ~/.cache/screen.png
# convert ~/.cache/screen.png -scale 1.25% -scale 8000% ~/.cache/screen.png
[[ -f $1 ]] && convert ~/.cache/screen.png $1 -gravity center -composite -matte ~/.cache/screen.png
swaylock --ignore-empty-password --scaling tile --image ~/.cache/screen.png
rm ~/.cache/screen.png

