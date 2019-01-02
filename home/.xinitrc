. ~/.xinitrc_reset

#if [ -z "$SSH_AUTH_SOCK" ] ; then
	#eval `ssh-agent -s`
#	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keeagent.sock"
#fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export FT2_SUBPIXEL_HINTING=1

exec i3

# vim: sw=4 et