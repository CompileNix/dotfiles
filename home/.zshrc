unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     operatingSystem=Linux;;
    Darwin*)    operatingSystem=Mac;;
    CYGWIN*)    operatingSystem=Cygwin;;
    MINGW*)     operatingSystem=MinGw;;
    *)          operatingSystem="UNKNOWN:${unameOut}"
esac
unset unameOut

if [[ $operatingSystem == "Mac" ]]; then
    n=$(nice)
    # increse process priotiy if user is root, this is useful if you're loggin in while the system is under high load
    if [[ $EUID -eq 0 ]]; then
        renice -n -20 $$ >/dev/null
        ionice -c 2 -n 0 -p $$ >/dev/null
    fi
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
if [[ $operatingSystem == "Mac" ]]; then
    alias ls='ls -h -G'
    alias make="make -j\$(sysctl -n hw.ncpu)"
else
    alias ls='ls -h --color'
    alias make="make -j\$(nproc)"
    alias iotop='iotop -d 1 -P -o'
fi

alias sudo='sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK'
alias sudosu='sudo su -'
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias ll='ls -l'
alias la='ls -al'
alias grep='grep --color'
alias htop='htop -d 10'
alias rsync="rsync -v --progress --numeric-ids --human-readable --stats --copy-links --hard-links"
alias ask_yn='select yn in "Yes" "No"; do case $yn in Yes) ask_yn_y_callback; break;; No) ask_yn_n_callback; break;; esac; done'
alias brexit='echo "disable all network interfaces, delete 50% of all files and then reboot the dam thing!"; ask_yn_y_callback() { echo "See ya and peace out!"; exit; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias ceph-osd-heap-release='ceph tell "osd.*" heap release' # release unused memory by the ceph osd daemon(s).
alias clean-swap='sudo swapoff -a; sudo swapon -a'
alias reset-swap='clean-swap'
alias drop-fscache='sync; sudo echo 3 > /proc/sys/vm/drop_caches'
alias reset-fscache='drop-fscache'
alias dns-retransfer-zones='rndc retransfer'
alias dns-reload-zones='rndc reload'
alias get-network-listening='sudo netstat -tunpl'
alias get-network-active-connections='sudo netstat -tun'
alias get-network-active-connections-by-type="sudo netstat -tun | awk '{print \$6}' | sort | uniq -c | sort -n | tail -n +2"
alias get-network-active-connections-by-type-program="sudo netstat -tunp | awk '{print \$6,\$7}' | sort | uniq -c | sort -n | tail -n +2"
alias get-iptables-v4='sudo iptables -L -v'
alias get-iptables-v4-nat='sudo iptables -t nat -L -v'
alias get-iptables-v6='sudo ip6tables -L -v'
alias get-iptables-v6-nat='sudo ip6tables -t nat -L -v'
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias watch-mem-dirty='watch -n 1 "cat /proc/meminfo | grep Dirty"'
alias watch-ceph-status='watch -n 1 ceph -s'
alias get-date='date +%s'
alias get-date-from-unixtime='read a; date -d @$a'
alias get-date-hex='get-date | xargs printf "%x\n"'
alias get-date-from-hex-unixtime='read a; echo $a | echo $((16#$_))'
alias get-date-from-hex='get-date-from-hex-unixtime | date -d @$_'
alias get-hpkp-pin='openssl x509 -pubkey -noout | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64'
function get-cert-raw {
    hostName=$1
    portNumber=$2
    echo | openssl s_client -connect ${hostName}:${portNumber} -servername ${hostName} 2>/dev/null | openssl x509
}
function get-cert {
    hostName=$1
    portNumber=$2
    get-cert-raw $hostName $portNumber | openssl x509 -noout -text
}
export dnsStats='+stats'
function set-dns-stats-enable {
    export dnsStats='+stats'
}
function set-dns-stats-disable {
    export dnsStats=''
}
export dnsTrace=''
function set-dns-trace-enable {
    export dnsTrace='+trace'
}
function set-dns-trace-disable {
    export dnsTrace=''
}
alias get-dns="dig +noall \$(echo \$dnsStats) \$(echo \$dnsTrace) +answer ANY"
alias get-dns-dnssec="dig +noall \$(echo \$dnsStats) \$(echo \$dnsTrace) +answer +dnssec ANY"
alias get-dns-dnssec-verify="dig +noall \$(echo \$dnsStats) \$(echo \$dnsTrace) +answer +dnssec +sigchase ANY"
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
function get-debian-package-updates { apt --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'; };
alias set-zsh-highlighting-full='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)'
alias set-zsh-highlighting-default='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)'
alias set-zsh-highlighting-off='ZSH_HIGHLIGHT_HIGHLIGHTERS=()'
alias set-terminal-powersave-off='setterm -blank 0 -powersave off'
alias set-terminal-powersave-on='setterm -blank 60 -powersave on'
alias set-megaraid-alarm-enabled='sudo megacli -AdpSetProp AlarmEnbl'
alias set-megaraid-alarm-disabled='sudo megacli -AdpSetProp AlarmDsbl'
alias set-megaraid-alarm-silent='sudo megacli -AdpSetProp AlarmSilence'
alias set-keyboard-mode-raw='sudo kbd_mode -s'
alias set-display-off='sleep 1; xset dpms force standby'
alias set-display-on='xset dpms force on'
function add-iptables-allow-out-http_s { sudo iptables -A OUTPUT -p TCP --match multiport --dports 80,443 -d "$1" -j ACCEPT -m comment --comment "Temporary: $1"; }
function remove-iptables-allow-out-http_s { sudo iptables -D OUTPUT -p TCP --match multiport --dports 80,443 -d "$1" -j ACCEPT -m comment --comment "Temporary: $1"; }
alias update-gentoo='echo "do a \"emerge --sync\"?"; ask_yn_y_callback() { sudo emerge --sync; }; ask_yn_n_callback() { echo ""; }; ask_yn; sudo emerge -avDuN world'
alias update-archlinux-pacman='sudo pacman -Syu'
alias update-archlinux-yaourt='sudo yaourt -Syu'
alias update-archlinux-yaourt-aur='sudo yaourt -Syu --aur'
alias update-debian='echo "do a \"apt update\"?"; ask_yn_y_callback() { sudo apt update; }; ask_yn_n_callback() { echo ""; }; ask_yn; echo; get-debian-package-updates | while read -r line; do echo -en "$line $(echo $line | awk "{print \$1}" | get-debian-package-description)\n"; done; echo; sudo apt upgrade; sudo apt autoremove; sudo apt autoclean'
alias update-yum='sudo yum update'
alias update-fedora='sudo dnf update'
function git-reset { currentDir="$PWD"; for i in $*; do echo -e "\033[0;36m$i\033[0;0m"; cd "$i"; git reset --hard master; cd "$currentDir"; done; };
alias fix-antigen_and_homesick_vim='git-reset $HOME/.antigen/repos/*; rm /usr/local/bin/tmux-mem-cpu-load; antigen-cleanup; git-reset $HOME/.homesick/repos/*; git-reset $HOME/.vim/bundle/*; antigen-update; homeshick pull; homeshick refresh; for i in $HOME/.vim/bundle/*; do cd "$i"; git pull; done; wait; cd $HOME; vim +PluginInstall +qa; exec zsh'
alias update-zshrc='echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/.homesick/repos/dotfiles/ && git status\"\nDo you want preced anyway?"; ask_yn_y_callback() { fix-antigen_and_homesick_vim; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias test-mail-sendmail='echo "Subject: test" | sendmail -v '
alias test-mail-mutt='mutt -s "test" '
function apache-configtest { sudo apache2ctl -t }
function apache-reload { apache-configtest && { sudo systemctl reload apache2 || sudo systemctl status apache2 } }
function apache-restart { apache-configtest && { sudo systemctl restart apache2 || sudo systemctl status apache2 } }
function nginx-configtest { sudo nginx -t }
function nginx-reload { nginx-configtest && { sudo systemctl reload nginx || sudo systemctl status nginx } }
function nginx-restart { nginx-configtest && { sudo systemctl restart nginx || sudo systemctl status nginx } }

export PATH="$PATH:$HOME/bin:$HOME/bin_dotfiles:$HOME/sh"
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTSIZE=10000
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
COMPLETION_WAITING_DOTS="true"

source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh

antigen theme dpoggi
echo "breakpoint: hit Control+C if the system takes to long to initialize optional shell modules. (you can rerun this with: \"exec zsh\")"

antigen bundle systemd
antigen bundle colored-man-pages
antigen bundle command-not-found

if [[ ${condition_for_tmux_mem_cpu_load} -eq 0 ]]; then
    #antigen bundle thewtex/tmux-mem-cpu-load
    antigen bundle compilenix/tmux-mem-cpu-load
fi

antigen bundle RobSis/zsh-completion-generator
antigen bundle zsh-users/zsh-completions
antigen bundle ascii-soup/zsh-url-highlighter

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
    #antigen bundle zsh-users/zsh-autosuggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=11" # yellow
fi

if [ -f "$HOME/.zshrc_include" ]; then
    source "$HOME/.zshrc_include"
else
    echo -e "#export SSH_AUTH_SOCK=\$XDG_RUNTIME_DIR/keeagent.sock\n#export EDITOR=nano" >"$HOME/.zshrc_include"
fi

if [ ! -f "$HOME/.gnupg/gpg-agent.env" ]; then
    mkdir -pv "$HOME/.gnupg"
    touch "$HOME/.gnupg/gpg-agent.env"
fi

if [[ $operatingSystem == "Mac" ]]; then
    if [[ $EUID -eq 0 ]]; then
        renice -n $n $$ > /dev/null
    fi
fi

unset n

# vim: sw=4 et
