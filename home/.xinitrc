. ~/.xinitrc_reset

#if [ -z "$SSH_AUTH_SOCK" ] ; then
	#eval `ssh-agent -s`
#	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keeagent.sock"
#fi

exec i3

# vim: sw=4 et