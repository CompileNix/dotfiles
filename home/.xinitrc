#!/bin/zsh
. ~/.xinitrc_reset

# xrandr
#xrandr --output DisplayPort-1 --mode 2560x1440 --dpi 109 --pos 2560x0 --rotate normal --primary --set "TearFree" "off" --output DisplayPort-3 --mode 2560x1440 --pos 0x0 --rotate normal --dpi 109 --set "TearFree" "off"
#xrandr --output DP-1 --primary --mode 2560x1440 -r 59.95 --right-of HDMI-0 --output HDMI-0 --mode 2560x1440 -r 59.95
if [ -f $HOME/.xinitrc_xrandr ]; then
    source $HOME/.xinitrc_xrandr
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keeagent.sock"
fi

xsetroot -cursor_name left_ptr &
numlockx &

# https://github.com/sigmike/autocutsel
# sudo yum install libX11-devel libXaw-devel
autocutsel -selection PRIMARY -fork

eval $(dbus-launch --sh-syntax)

if [ -f $HOME/.xinitrc_include ]; then
    source $HOME/.xinitrc_include
fi

exec i3

# vim: sw=4 et