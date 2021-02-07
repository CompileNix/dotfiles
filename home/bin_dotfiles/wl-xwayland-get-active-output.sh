#!/bin/bash

# Second variant ist much faster
# RE="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).rect | "\(.width)\\/\\d+?x\(.height)\\/\\d+?\\+\(.x)\\+\(.y)"')"
RE="$(swaymsg -t get_outputs | jtc -w'[:][focused]<true>b[-1][rect]' -qqT'"{$b}\\\/\\d+?x{$a}\\\/\\d+?\\+{$c}\\+{$d}"')"
OUTPUT="$(xrandr --listmonitors | grep -P $RE | grep -Po '\d+?: \+\K(\w+)')"
echo $OUTPUT

