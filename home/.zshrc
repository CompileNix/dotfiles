n=$(nice)
# increse process priotiy if user is root, this is useful if you're loggin in while the system is under high load
if [[ $EUID -eq 0 ]]; then
    renice -n -20 $$ >/dev/null
    ionice -c 2 -n 0 -p $$ >/dev/null
fi

stty -ixon -ixoff 2>/dev/null
unicode_start 2>/dev/null
kbd_mode -u 2>/dev/null # set unicode mode
kbd_mode 2>/dev/null # check keyboard mode, should be Unicode (UTF-8)

# save emacs!
if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# TODO: do the following for htop, too.
unalias tmux 2>/dev/null
if [ -f $(which tmux 2>/dev/null) ]; then
    if [ ! -f "$HOME/.tmux.conf_configured" ]; then
        if [[ $(tmux -V) == *"1."* ]]; then
            unlink "$HOME/.tmux.conf" 2>/dev/null
            ln -s "$HOME/.homesick/repos/dotfiles/home/.tmux.conf_v1" "$HOME/.tmux.conf"
        fi
        if [[ $(tmux -V) == *"2."* ]]; then
            unlink "$HOME/.tmux.conf" 2>/dev/null
            ln -s "$HOME/.homesick/repos/dotfiles/home/.tmux.conf_v2" "$HOME/.tmux.conf"
        fi
        touch "$HOME/.tmux.conf_configured"
    fi
fi

unalias sudo 2>/dev/null
unalias make 2>/dev/null
unalias cmake 2>/dev/null
unalias gcc 2>/dev/null
unalias g++ 2>/dev/null
unalias c++ 2>/dev/null
condition_for_tmux_mem_cpu_load=1
if [[ \
    $EUID -eq 0 && \
    -f $(which sudo 2>/dev/null) && \
    -f $(which make 2>/dev/null) && \
    -f $(which cmake 2>/dev/null) && \
    -f $(which gcc 2>/dev/null) && \
    -f $(which g++ 2>/dev/null) && \
    -f $(which c++ 2>/dev/null) \
    ]]; then

    condition_for_tmux_mem_cpu_load=0
fi


# aliases
alias sudosu='sudo su -'
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias ls='ls -h --color'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias grep='grep --color'
alias make="make -j$(nproc)"
alias iotop='iotop -d 1 -P -o'
alias rsync="rsync -v --progress --numeric-ids --human-readable --stats --copy-links --hard-links"
alias ask_yn='select yn in "Yes" "No"; do case $yn in Yes) ask_yn_y_callback; break;; No) ask_yn_n_callback; break;; esac; done'
alias brexit='echo "disable all network interfaces, delete 50% of all files and then reboot the dam thing!"; ask_yn_y_callback() { echo "See ya and peace out!"; exit; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias ceph-osd-heap-release='ceph tell "osd.*" heap release' # release unused memory by the ceph osd daemon(s).
alias clean-swap='swapoff -a; swapon -a'
alias drop-fscache='sync; echo 3 > /proc/sys/vm/drop_caches'
alias dns-retransfer-zones='rndc retransfer'
alias dns-reload-zones='rndc reload'
alias get-network-listening='netstat -tunpl'
alias get-network-active-connections='netstat -tun'
alias get-network-active-connections-by-type="netstat -tun | awk '{print \$6}' | sort | uniq -c | sort -n | tail -n +2"
alias get-network-active-connections-by-type-program="netstat -tunp | awk '{print \$6,\$7}' | sort | uniq -c | sort -n | tail -n +2"
alias get-iptables-v4='iptables -L -v'
alias get-iptables-v4-nat='iptables -t nat -L -v'
alias get-iptables-v6='ip6tables -L -v'
alias get-iptables-v6-nat='ip6tables -t nat -L -v'
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias get-mem-dirty-loop='while true; do get-mem-dirty; sleep 1; done'
alias get-mem-dirty-loop-250='while true; do get-mem-dirty; sleep 1; done'
alias get-mem-dirty-loop-500='while true; do get-mem-dirty; sleep 1; done'
alias get-ceph-status-loop='while true; do ceph -s > /tmp/get-ceph-status-loop.txt; clear; tput cup 0 0; cat /tmp/get-ceph-status-loop.txt; sleep 2; done'
alias get-date='date +%s'
alias get-date-from-unixtime='read a; date -d @$a'
alias get-date-hex='get-date | xargs printf "%x\n"'
alias get-date-from-hex-unixtime='read a; echo $a | echo $((16#$_))'
alias get-date-from-hex='get-date-from-hex-unixtime | date -d @$_'
alias get-hpkp-pin='openssl x509 -pubkey -noout | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64'
alias get-dig-short-answer='dig +noall +answer'
alias get-picture-metadata-curl='read a; curl -sr 0-1024 $a | strings'
alias get-picture-metadata-file='read a; dd bs=1 count=1024 if=$a 2>/dev/null | strings'
alias get-weather='curl wttr.in'
alias get-weather-in='echo -n "enter location (name or 3-letters airport code): "; read a; curl wttr.in/$a'
alias get-moon-phase='curl wttr.in/Moon'
alias get-mysql-selects='ngrep -d eth0 -i "select" port 3306'
alias get-mysql-updates='ngrep -d eth0 -i "update" port 3306'
alias get-mysql-inserts='ngrep -d eth0 -i "insert" port 3306'
alias get-fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'
alias get-process-zombie="ps aux | awk '{if (\$8==\"Z\") { print \$2 }}'"
function get-debian-package-description { read input; dpkg -l ${input} | grep --color " ${input} " | awk '{$1=$2=$3=$4="";print $0}' | sed 's/^ *//' };
function get-debian-package-updates { apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'; };
alias set-zsh-highlighting-full='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)'
alias set-zsh-highlighting-default='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)'
alias set-zsh-highlighting-off='ZSH_HIGHLIGHT_HIGHLIGHTERS=()'
alias set-terminal-powersave-off='setterm -blank 0 -powersave off'
alias set-terminal-powersave-on='setterm -blank 60 -powersave on'
alias set-megaraid-alarm-enabled='megacli -AdpSetProp AlarmEnbl'
alias set-megaraid-alarm-disabled='megacli -AdpSetProp AlarmDsbl'
alias set-megaraid-alarm-silent='megacli -AdpSetProp AlarmSilence'
alias set-keyboard-mode-raw='sudo kbd_mode -s'
function add-iptables-allow-out-http_s { iptables -A OUTPUT -p TCP --match multiport --dports 80,443 -d "$1" -j ACCEPT -m comment --comment "Temporary: $1"; }
function remove-iptables-allow-out-http_s { iptables -D OUTPUT -p TCP --match multiport --dports 80,443 -d "$1" -j ACCEPT -m comment --comment "Temporary: $1"; }
alias update-gentoo='echo "do a \"emerge --sync\"?"; ask_yn_y_callback() { emerge --sync; }; ask_yn_n_callback() { echo ""; }; ask_yn; emerge -avDuN world'
alias update-archlinux-pacman='pacman -Syu'
alias update-archlinux-yaourt='yaourt -Syu'
alias update-archlinux-yaourt-aur='yaourt -Syu --aur'
alias update-debian='echo "do a \"apt-get update\"?"; ask_yn_y_callback() { apt-get update; }; ask_yn_n_callback() { echo ""; }; ask_yn; get-debian-package-updates | while read -r line; do echo -en "$line $(echo $line | awk "{print \$1}" | get-debian-package-description)\n"; done; echo; apt-get upgrade; apt-get autoremove; apt-get autoclean'
function git-reset { currentDir="$PWD"; for i in $*; do echo -e "\033[0;36m$i\033[0;0m"; cd "$i"; git reset --hard master; cd "$currentDir"; done; };
alias fix-antigen_and_homesick_vim='git-reset $HOME/.antigen/repos/*; rm /usr/local/bin/tmux-mem-cpu-load; antigen-cleanup; git-reset $HOME/.homesick/repos/*; git-reset $HOME/.vim/bundle/*; antigen-update; homeshick pull; homeshick refresh; for i in $HOME/.vim/bundle/*; do cd "$i"; git pull; done; wait; cd $HOME; vim +PluginInstall +qa; exec zsh'
alias update-zshrc='echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/.homesick/repos/dotfiles/ && git status\"\nDo you want preced anyway?"; ask_yn_y_callback() { fix-antigen_and_homesick_vim; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias test-mail-sendmail='echo "Subject: test" | sendmail -v '
alias test-mail-mutt='mutt -s "test" '
function apache2-reload { apache2ctl -t && { service apache2 reload && { sleep .1; } || { service apache2 status; } } }
function apache2-restart { apache2ctl -t && { service apache2 restart && { sleep .1; } || { service apache2 status; } } }

export PATH="$PATH:$HOME/bin:$HOME/sh"
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
unsetopt share_history

if [ ! -f "$HOME/.tmux.conf_include" ]; then
    touch "$HOME/.tmux.conf_include"
fi

if [ ! -f "$HOME/.gitconfig_include" ]; then
    echo -e "#[user]\n#\tname = Compilenix\n#\temail = Compilenix@compilenix.org\n#[core]\n#\tfileMode = false\n\n# vim: sw=4 et" > "$HOME/.gitconfig_include"
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

if [ -f /usr/lib64/node_modules/npm/lib/utils/completion.sh ]; then
    source /usr/lib64/node_modules/npm/lib/utils/completion.sh
fi

ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_FIXTERM=false

source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh

antigen theme dpoggi
echo "breakpoint: hit Control+C if the system takes to long to initialize optional shell modules. (you can rerun this with: \"exec zsh\")"

antigen bundle mosh
antigen bundle node
antigen bundle npm
antigen bundle gulp
antigen bundle systemd
antigen bundle jira
antigen bundle colored-man-pages
antigen bundle command-not-found

if [[ ${condition_for_tmux_mem_cpu_load} -eq 0 ]]; then
    #antigen bundle thewtex/tmux-mem-cpu-load
    antigen bundle compilenix/tmux-mem-cpu-load
fi

antigen bundle RobSis/zsh-completion-generator
antigen bundle zsh-users/zsh-completions
antigen bundle ascii-soup/zsh-url-highlighter
antigen bundle psprint/zsnapshot
antigen bundle akoenig/npm-run.plugin.zsh

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

if which tmux &> /dev/null
	then
	# Configuration variables
	#
	# Automatically start tmux
	[[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART=false
	# Only autostart once. If set to false, tmux will attempt to
	# autostart every time your zsh configs are reloaded.
	[[ -n "$ZSH_TMUX_AUTOSTART_ONCE" ]] || ZSH_TMUX_AUTOSTART_ONCE=true
	# Automatically connect to a previous session if it exists
	[[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT=true
	# Automatically close the terminal when tmux exits
	[[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT=$ZSH_TMUX_AUTOSTART
	# Set term to screen or screen-256color based on current terminal support
	[[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_FIXTERM=true
	# Set '-CC' option for iTerm2 tmux integration
	[[ -n "$ZSH_TMUX_ITERM2" ]] || ZSH_TMUX_ITERM2=false
	# The TERM to use for non-256 color terminals.
	# Tmux states this should be screen, but you may need to change it on
	# systems without the proper terminfo
	[[ -n "$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen"
	# The TERM to use for 256 color terminals.
	# Tmux states this should be screen-256color, but you may need to change it on
	# systems without the proper terminfo
	[[ -n "$ZSH_TMUX_FIXTERM_WITH_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITH_256COLOR="screen-256color"

	# Determine if the terminal supports 256 colors
	if [[ `tput colors` == "256" ]]
	then
		export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
	else
		export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
	fi

	# Wrapper function for tmux.
	function _zsh_tmux_plugin_run()
	{
		# We have other arguments, just run them
		if [[ -n "$@" ]]
		then
			tmux $@
		# Try to connect to an existing session.
		elif [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]
		then
			tmux `[[ "$ZSH_TMUX_ITERM2" == "true" ]] && echo '-CC '` attach || tmux `[[ "$ZSH_TMUX_ITERM2" == "true" ]] && echo '-CC '` `[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && echo '-f '$_ZSH_TMUX_FIXED_CONFIG` new-session
			[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
		# Just run tmux, fixing the TERM variable if requested.
		else
			tmux `[[ "$ZSH_TMUX_ITERM2" == "true" ]] && echo '-CC '` `[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && echo '-f '$_ZSH_TMUX_FIXED_CONFIG`
			[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
		fi
	}

	# Use the completions for tmux for our function
	compdef _tmux zsh_tmux_plugin_run

	# Autostart if not already in tmux and enabled.
	if [[ ! -n "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]
	then
		_zsh_tmux_plugin_run
	fi
fi

antigen apply

autoload -U compinit && compinit -u

antigen bundle zsh-users/zsh-syntax-highlighting

if [ ! -z "$TMUX" ]; then
    antigen bundle zsh-users/zsh-autosuggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=11" # yellow
fi

if [ -f "$HOME/.zshrc_include" ]; then
    source "$HOME/.zshrc_include"
else
    touch "$HOME/.zshrc_include"
fi

if [ ! -f "$HOME/.gnupg/gpg-agent.env" ]; then
    mkdir -pv "$HOME/.gnupg"
    touch "$HOME/.gnupg/gpg-agent.env"
fi

if [[ $EUID -eq 0 ]]; then
    renice -n $n $$ > /dev/null
fi

unset n

# vim: sw=4 et
