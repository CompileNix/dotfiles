. ~/.xinitrc_reset
. ~/.xinitrc_xrandr # xrandr --output DP-1 --primary --mode 2560x1440 -r 59.95 --right-of HDMI-0 --output HDMI-0 --mode 2560x1440 -r 59.95

#if [ -z "$SSH_AUTH_SOCK" ] ; then
	#eval `ssh-agent -s`
#	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keeagent.sock"
#fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1

exec i3

# vim: sw=4 et