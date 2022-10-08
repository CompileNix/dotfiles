# vim: sw=4 et

if [ ! -z "$SSH_AGENT_PID" ]; then
    eval `ssh-agent -k` >/dev/null
fi

if [ -f "$HOME/.zlogout_include" ]; then
    . "$HOME/.zlogout_include"
fi

