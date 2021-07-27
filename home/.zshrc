# vim: sw=4 et

if [ ! -f "~/.zshrc.env" ]; then
cat << EOF | tee $HOME/.zshrc.env >/dev/null
ZSH_LIGHT=false
ZSH_MINIMAL=false
EOF
fi
source ~/.zshrc.env

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     operatingSystem=Linux;;
    Darwin*)    operatingSystem=Mac;;
    CYGWIN*)    operatingSystem=Cygwin;;
    MINGW*)     operatingSystem=MinGw;;
    *)          operatingSystem="UNKNOWN:${unameOut}"
esac
unset unameOut

DOTFILES_REPO_NAME=dotfiles

if [[ $operatingSystem == "Linux" ]]; then
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
    return
fi

unalias tmux 2>/dev/null
if [ -f $(which tmux 2>/dev/null) ]; then
    if [ ! -f "$HOME/.tmux.conf_configured" ]; then
        unlink "$HOME/.tmux.conf" 2>/dev/null
        ln -s "$HOME/.homesick/repos/${DOTFILES_REPO_NAME}/home/.tmux.conf_v2" "$HOME/.tmux.conf"
        if [[ $(tmux -V) == *"1."* ]]; then
            unlink "$HOME/.tmux.conf" 2>/dev/null
            ln -s "$HOME/.homesick/repos/${DOTFILES_REPO_NAME}/home/.tmux.conf_v1" "$HOME/.tmux.conf"
        fi
        touch "$HOME/.tmux.conf_configured"
    fi
fi

distro=''
if [[ $operatingSystem == "Linux" ]]; then
    is_done=false
    distro_result=$(lsb_release -i)

    if [ $? -eq 0 ]; then
        if [[ $distro_result =~ "Ubuntu" ]]; then
            distro="Ubuntu"
        fi
        if [[ $distro_result =~ "Fedora" ]]; then
            distro="Fedora"
        fi
        if [[ $distro_result =~ "Debian" ]]; then
            distro="Debian"
        fi
        if [[ $distro_result =~ "Gentoo" ]]; then
            distro="Gentoo"
        fi
        if [[ $distro_result =~ "Arch" ]]; then
            distro="Arch"
        fi
        is_done=true
    fi

    unset is_done
    unset distro_result
fi
alias get-distro="lsb_release -a"
alias get-distro-name="echo $distro"

# aliases
if [[ $operatingSystem == "Mac" ]]; then
    alias ls='ls -h -G'
    alias make="make -j\$(sysctl -n hw.ncpu)"
else
    alias ls='ls -h --color'
    alias make="make -j\$(nproc)"
    alias iotop='iotop -d 1 -P -o'
fi

function ask_yn {
    select yn in "Yes" "No"; do
        case $yn in
            Yes)
                ask_yn_y_callback
                break;;
            No)
                ask_yn_n_callback
                break;;
        esac
    done
}
alias sudo='sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK'
alias sudosu='sudo su -'
alias pls='sudo'
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias ll='ls -l'
alias la='ls -al'
alias l='la'
alias grep='grep --color'
alias htop='htop -d 10'
alias rsync="rsync --progress --numeric-ids --human-readable --copy-links --hard-links"
alias brexit='echo "disable all network interfaces, delete 50% of all files and then reboot the dam thing!"; ask_yn_y_callback() { echo "See ya and peace out!"; exit; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote_plus(sys.stdin.read()));"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote_plus(sys.stdin.read()));"'
alias ceph-osd-heap-release='ceph tell "osd.*" heap release' # release unused memory by the ceph osd daemon(s).
alias reset-swap='sudo swapoff -a; sudo swapon -a'
alias reset-fscache='sync; sudo echo 3 > /proc/sys/vm/drop_caches'
alias dns-retransfer-zones='rndc retransfer'
alias dns-reload-zones='rndc reload'
alias get-ip-local='ip a'
alias get-ip-internet='curl https://ip.compilenix.org'
alias get-ip-routes='ip route | column -t'
alias get-network-listening-netstat='sudo netstat -tunpl'
alias get-network-listening='sudo ss --numeric --listening --processes --tcp --udp'
alias get-network-active-connections-netstat='sudo netstat -tun'
alias get-network-active-connections='ss --numeric --processes --tcp --udp -o state synchronized'
alias get-network-active-connections-by-type-netstat="sudo netstat -tun | awk '{print \$6}' | sort | uniq -c | sort -n | tail -n +2"
alias get-network-active-connections-by-type="sudo ss --summary"
alias get-iptables-v4='sudo iptables -L -v'
alias get-iptables-v4-nat='sudo iptables -t nat -L -v'
alias get-iptables-v6='sudo ip6tables -L -v'
alias get-iptables-v6-nat='sudo ip6tables -t nat -L -v'
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias watch-mem-dirty='watch -n 1 "cat /proc/meminfo | grep Dirty"'
alias watch-ceph-status='watch -n 1 ceph -s'
alias get-date='date +"%Y-%m-%d.%H%M"'
alias get-date-unixtime='date +%s'
alias get-date-from-unixtime='read a; date -d @$a'
alias get-date-hex='get-date | xargs printf "%x\n"'
alias get-date-from-hex-unixtime='read a; echo $a | echo $((16#$_))'
alias get-date-from-hex='get-date-from-hex-unixtime | date -d @$_'
alias get-hpkp-pin='openssl x509 -pubkey -noout | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64'
alias get-cert-info-stdin='echo "paste pem cert and hit Control+D: ";cert=$(cat); echo $cert | openssl x509 -text -noout'
function get-cert-remote-raw {
    hostName=$1
    portNumber=$2
    echo | openssl s_client -connect ${hostName}:${portNumber} -servername ${hostName} 2>/dev/null | openssl x509
}
function get-cert-remote {
    hostName=$1
    portNumber=$2
    get-cert-remote-raw $hostName $portNumber | openssl x509 -noout -text
}
function get-cert-file {
    openssl x509 -noout -text -in $1
}

function set-dns-stats-enable {
    export dnsStats='+stats'
}
function set-dns-stats-disable {
    export dnsStats=''
}

function set-dns-additional-enable {
    export dnsAdditional='+additional'
}
function set-dns-additional-disable {
    export dnsAdditional=''
}
set-dns-stats-enable
set-dns-additional-enable
alias get-dns="dig +noall \$(echo \$dnsStats) \$(echo \$dnsAdditional) +answer"
alias get-dns-dnssec="dig +noall \$(echo \$dnsStats) \$(echo \$dnsAdditional) +answer +dnssec"
alias get-dns-dnssec-verify="dig +noall \$(echo \$dnsStats) \$(echo \$dnsAdditional) +answer +dnssec +sigchase"
alias get-picture-metadata-curl='echo -n "URL: "; read a; curl -sr 0-1024 $a | strings'
alias get-picture-metadata-file='echo -n "file path: "; read a; dd bs=1 count=1024 if=$a 2>/dev/null | strings'
alias get-random-alias='alias | sort --random-sort | head -n 1'
alias get-random-password-strong='echo -n "length: "; read len; cat /dev/random | tr -dc "[:print:]" | head -c $len | awk "{ print $1 }"'  # awk adds a newline
alias get-random-password-alnum='echo -n "length: "; read len; cat /dev/random | tr -dc "[:alnum:]" | head -c $len | awk "{ print $1 }"'
alias get-random-password-alnum-lower='echo -n "length: "; read len; cat /dev/random | tr -dc "[:digit:][:lower:]" | head -c $len | awk "{ print $1 }"'
alias get-random-number-range='echo -n "from: "; read from; echo -n "to: "; read to; shuf -i ${from}-${to} -n 1'
alias get-random-guid='uuidgen'
alias get-random-hex-2='cat /dev/random | tr -dc "0-9a-f" | head -c 2'
alias get-random-hex-4='cat /dev/random | tr -dc "0-9a-f" | head -c 4'
alias get-random-ip4='python3 -c "import ipaddress, random; print(ipaddress.ip_address(random.randint(0, 0x7FFFFFFF)))"'
alias get-random-ip6='python3 -c "import ipaddress, random; print(ipaddress.ip_address(random.randint(0, 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)))"'
alias get-random-port='shuf -i 16385-49151 -n 1'
alias get-fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'
alias get-process-zombie="ps aux | awk '{if (\$8==\"Z\") { print \$2 }}'"
alias set-clipboard-x11="xclip -i -sel c -f"
alias set-clipboard-wayland="wl-copy"
alias get-clipboard-wayland="wl-paste"
alias get-ssh-pubkey='if [ -f ~/.ssh/id_ed25519.pub ]; then cat ~/.ssh/id_ed25519.pub; elif [ -f ~/.ssh/id_ed25519_pub ]; then content=$(cat ~/.ssh/id_ed25519_pub); fi; echo $content'
alias get-ssh-prikey='if [ -f ~/.ssh/id_ed25519 ]; then cat ~/.ssh/id_ed25519; elif [ -f ~/.ssh/id_ed25519 ]; then content=$(cat ~/.ssh/id_ed25519_pub); fi; echo $content'
alias get-ssh-pubkeys-host='(for file in /etc/ssh/*_key.pub; do echo "$file"; ssh-keygen -l -E md5 -f $file; ssh-keygen -l -E sha256 -f "$file"; echo; done; ssh-keygen -r $(hostname -s))'
function get-debian-package-description { read input; dpkg -l ${input} | grep --color " ${input} " | awk '{$1=$2=$3=$4="";print $0}' | sed 's/^ *//' }
function get-debian-package-updates { apt --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'; }
# Create a data URL from a file
function get-dataurl {
    local mimeType
    mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
alias set-zsh-highlighting-full='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)'
alias set-zsh-highlighting-default='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)'
alias set-zsh-highlighting-off='ZSH_HIGHLIGHT_HIGHLIGHTERS=()'
alias set-terminal-powersave-off='setterm -blank 0 -powersave off'
alias set-terminal-powersave-on='setterm -blank 60 -powersave on'
alias set-megaraid-alarm-enabled='sudo megacli -AdpSetProp AlarmEnbl'
alias set-megaraid-alarm-disabled='sudo megacli -AdpSetProp AlarmDsbl'
alias set-megaraid-alarm-silent='sudo megacli -AdpSetProp AlarmSilence'
alias set-keyboard-mode-raw='sudo kbd_mode -s'
alias set-display-off-x11='sleep 1; xset dpms force standby'
alias set-display-on-x11='xset dpms force on'
alias set-display-off-wayland="swayidle timeout 1 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"; pkill -nx swayidle'"
alias set-display-on-wayland='swaymsg "output * dpms on"'
alias update-gentoo='echo "do a \"emerge --sync\"?"; ask_yn_y_callback() { sudo emerge --sync; }; ask_yn_n_callback() { echo ""; }; ask_yn; sudo emerge -avDuN world'
alias update-archlinux-pacman='sudo pacman -Syu'
alias update-archlinux-yaourt='sudo yaourt -Syu'
alias update-archlinux-yaourt-aur='sudo yaourt -Syu --aur'
alias update-debian='echo "do a \"apt update\"?"; ask_yn_y_callback() { set -x; sudo apt update; set +x; }; ask_yn_n_callback() { echo ""; }; ask_yn; set -x; apt autoremove; apt list --upgradable; sudo apt upgrade -y; sudo apt autoremove; sudo apt autoclean; set +x'
alias update-yum='sudo yum update'
alias update-fedora='sudo dnf update'
function git-reset { for i in $*; do echo -e "\033[0;36m$i\033[0;0m"; pushd "$i"; git reset --hard; popd >/dev/null; done; }
function update-dotfiles-non-interactive {
    if [[ $EUID -eq 0 ]]; then
        rm /usr/local/bin/tmux-mem-cpu-load
    fi
    # Migrate from 1.x antigen to 2.x antigen
    if [[ -d ~/.homesick/repos/${DOTFILES_REPO_NAME}/home/.antigen ]]
    then
        pushd ~/.homesick/repos
        rm -rf ${DOTFILES_REPO_NAME}
        git clone --recursive https://git.compilenix.org/CompileNix/${DOTFILES_REPO_NAME}.git
        popd >/dev/null
        pushd ~
        rm -rf .antigen
        rm -rf .vim/bundle/vundle
        ln -sfv .homesick/repos/${DOTFILES_REPO_NAME}/antigen .antigen
        popd >/dev/null
    fi
    antigen-cleanup
    git-reset ~/.homesick/repos/*
    if [[ -d ~/.vim/bundle ]]
    then
        rm -rf ~/.vim/bundle
    fi
    homeshick pull
    homeshick link
    antigen update
    rm ~/.tmux.conf_configured

    exec zsh
}
function update-dotfiles {
    pushd ~/.homesick/repos/${DOTFILES_REPO_NAME}
    git status
    popd >/dev/null
    echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/.homesick/repos/${DOTFILES_REPO_NAME} && git status\""
    echo "Do you want proceed anyway?"
    function ask_yn_y_callback {
        update-dotfiles-non-interactive
    }
    function ask_yn_n_callback {
        echo -n ""
    }
    ask_yn
}
alias update-code-insiders-rpm='wget "https://go.microsoft.com/fwlink/?LinkID=760866" -O /tmp/code-insiders.rpm && sudo yum install -y /tmp/code-insiders.rpm && rm /tmp/code-insiders.rpm'
alias test-mail-sendmail='echo -n "To: "; read mail_to_addr; echo -e "From: ${USER}@$(hostname -f)\nTo: ${mail_to_addr}\nSubject: test subject\n\ntest body" | sendmail -v "${mail_to_addr}"'
alias test-mail-mutt='mutt -s "test" '
function apache-configtest { sudo apache2ctl -t }
function apache-reload { apache-configtest && { sudo systemctl reload apache2 || sudo systemctl status apache2 } }
function apache-restart { apache-configtest && { sudo systemctl restart apache2 || sudo systemctl status apache2 } }
function nginx-status { sudo systemctl status nginx }
function nginx-configtest { sudo nginx -t }
function nginx-reload { nginx-configtest && { sudo systemctl reload nginx || sudo systemctl status nginx } }
function nginx-restart { nginx-configtest && { sudo systemctl restart nginx || sudo systemctl status nginx } }
function read-logfile {
    file="$1"
    sudo cat "${file}" | ccze -A | less -R
}
alias root='sudo su -l root'
alias get-processes='ps -aux'
alias get-processes-systemd='systemd-cgls'
alias get-memory='free -h -m'
alias get-disk-space='df -h'
alias get-disks='lsblk'
alias get-disks-id='blkid'
alias get-mounts='mount | column -t'
alias systemctl-status='systemctl status'
alias start-stopwatch='echo "press Ctrl+D to stop"; time cat'
alias install-fnm='curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash'
alias install-node-fnm='install-fnm'
alias install-nvm='curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash'
alias add-user='useradd'
alias remove-user='deluser'
alias inspect-docker-image='dive'  # https://github.com/wagoodman/dive
alias get-hostname='hostname -s'
alias get-hostname-fqdn='hostname -f'
alias get-hostname-domain='hostname -d'
function insert-datetime {
    # Example:
    # echo fooo 2>&1 1>/dev/null | insert-datetime | tee /tmp/test.log
    # Result:
    # [2021-03-30 19:03:02 CEST]: fooo
    awk '{ print strftime("[%F %X %Z]:"), $0; fflush(); }'
}


if [[ $distro == "Ubuntu" ]]; then
    alias install='sudo apt install --no-install-recommends '
    alias find-package='apt search '
    alias update='update-debian'
    alias upgrade='update-debian && do-release-upgrade'
fi
if [[ $distro == "Debian" ]]; then
    alias install='sudo apt install --no-install-recommends '
    alias find-package='apt search '
    alias update='update-debian'
    alias upgrade='update-debian && do-release-upgrade'
fi
if [[ $distro == "Fedora" ]]; then
    alias install='sudo dnf install '
    alias find-package='dnf search '
    alias update='update-fedora'
    alias upgrade='update-fedora'
fi
if [[ $distro == "Gentoo" ]]; then
    alias install='sudo emerge -av '
    alias find-package='eix '
    alias update='update-gentoo'
    alias upgrade='update-gentoo'
fi
if [[ $distro == "Arch" ]]; then
    alias install='sudo pacman -S '
    alias find-package='pacman -Ss '
    alias update='update-archlinux-pacman'
    alias upgrade='update-archlinux-pacman'
fi

function install-podman-fedora {
    sudo dnf remove docker
    sudo dnf install podman
    sudo dnf update container-selinux
    mkdir -pv ~/.zsh/completion
    wget https://raw.githubusercontent.com/containers/libpod/master/completions/zsh/_podman -O ~/.zsh/completion/_podman 2>/dev/null
    echo "You may want to add the following alias to $HOME/.zshrc_include"
    echo "alias docker='podman'"
    exec zsh
}

function remove-podman-fedora {
    sudo dnf remove podman
    sudo dnf update container-selinux
    rm -v ~/.zsh/completion/_podman 2>/dev/null
    unalias docker 2>/dev/null
    exec zsh
}

export PATH=".cargo/bin:./node_modules/.bin:$HOME/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.homesick/repos/${DOTFILES_REPO_NAME}/home/bin_dotfiles:/usr/lib/node_modules/.bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
unalias vim 2>/dev/null
alias vim='nvim'

# if it's an ssh session export GPG_TTY
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt EXTENDEDGLOB
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
unsetopt SHARE_HISTORY

if [ ! -f "$HOME/.tmux.conf_include" ]; then
    touch "$HOME/.tmux.conf_include"
fi

if [ ! -f "$HOME/.gitconfig_include" ]; then
cat << EOF | tee $HOME/.gitconfig_include >/dev/null
# vim: sw=4 et

[user]
     name = CompileNix
     email = compilenix@gmail.com
     signingkey = C94DD853DD6493CCC47C8C853C713073CAC92AE0

# https://help.github.com/articles/signing-commits-using-gpg/
[commit]
     gpgsign = true

[credential]
    helper = store

EOF
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_FIXTERM=false
COMPLETION_WAITING_DOTS=true
DISABLE_MAGIC_FUNCTIONS=true

if [[ $ZSH_MINIMAL != "true" ]]; then
    source $HOME/.antigen/antigen.zsh
    antigen use oh-my-zsh
    antigen theme denysdovhan/spaceship-prompt

    SPACESHIP_PROMPT_ADD_NEWLINE=false
    SPACESHIP_PROMPT_SEPARATE_LINE=false
    SPACESHIP_TIME_SHOW=true
    SPACESHIP_USER_SHOW=true
    SPACESHIP_HOST_SHOW=true
    SPACESHIP_HOST_SHOW_FULL=true
    SPACESHIP_BATTERY_THRESHOLD=25
    SPACESHIP_EXIT_CODE_SHOW=true
    SPACESHIP_EXIT_CODE_SUFFIX=" (╯°□°）╯︵ ┻━┻ "

    SPACESHIP_NODE_SHOW=false
    SPACESHIP_RUBY_SHOW=false
    SPACESHIP_ELIXIR_SHOW=false
    SPACESHIP_XCODE_SHOW_LOCAL=false
    SPACESHIP_XCODE_SHOW_GLOBAL=false
    SPACESHIP_SWIFT_SHOW_LOCAL=false
    SPACESHIP_SWIFT_SHOW_GLOBAL=false
    SPACESHIP_GOLANG_SHOW=false
    SPACESHIP_PHP_SHOW=false
    SPACESHIP_RUST_SHOW=false
    SPACESHIP_HASKELL_SHOW=false
    SPACESHIP_JULIA_SHOW=false
    SPACESHIP_DOCKER_SHOW=false
    SPACESHIP_PYENV_SHOW=false
    SPACESHIP_DOTNET_SHOW=false
    SPACESHIP_EMBER_SHOW=false
    SPACESHIP_PACKAGE_SHOW=false

    if [[ $ZSH_LIGHT != "true" ]]; then
        antigen bundle systemd
        antigen bundle colored-man-pages
        antigen bundle command-not-found
        antigen bundle zsh-users/zsh-completions
        antigen bundle ascii-soup/zsh-url-highlighter
        # antigen bundle RobSis/zsh-completion-generator

        antigen bundle zsh-users/zsh-syntax-highlighting
        set-zsh-highlighting-full
        export ZSH_HIGHLIGHT_MAXLENGTH=512

        antigen bundle zsh-users/zsh-autosuggestions
        export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        export ZSH_AUTOSUGGEST_USE_ASYNC=true
    fi
else
    PS1='$ '
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

if [[ ${condition_for_tmux_mem_cpu_load} -eq 0 ]]; then
    if [[ $ZSH_MINIMAL != "true" ]]; then
        #antigen bundle thewtex/tmux-mem-cpu-load
        antigen bundle compilenix/tmux-mem-cpu-load
    fi
fi

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
    # compdef _tmux zsh_tmux_plugin_run

    # Autostart if not already in tmux and enabled.
    if [[ ! -n "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]
    then
        _zsh_tmux_plugin_run
    fi
fi

[ -r ~/.ssh/config ] && _ssh_config=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p')) || _ssh_config=()
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _global_ssh_hosts=()
#[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
#[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_config[@]"
  "$_global_ssh_hosts[@]"
#  "$_ssh_hosts[@]"
#   "$_etc_hosts[@]"
#  "$HOST"
#  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

export nvmAutoEnable=0
export nvmEnabled=0
function enable-nvm {
    [[ nvmEnabled -eq 1 ]] && return 0
    echo "loading Node Version Manager..."
    export NVM_DIR="$(realpath $HOME/.nvm)"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || {
        echo "you need nvm (https://github.com/creationix/nvm)"
        unset NVM_DIR
        return 1
    }
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    export nvmEnabled=1
}

function disable-nvm {
    unset NVM_DIR
    export nvmEnabled=0
}

function use-nvm {
    enable-nvm || return 1
    nvm i || return 1
}

if [[ -f .nvmrc ]]
then
    if [[ $nvmAutoEnable == 1 ]]
    then
        $(type nvm 2>/dev/null) && $nvmEnabled && [[ "$(nvm version 2>/dev/null)" == "$(cat .nvmrc)" ]] || use-nvm
    fi
fi

# fast node manager (https://github.com/Schniz/fnm)
function enable-fnm {
    if [[ -f "$HOME/.fnm/fnm" ]]
    then
        export PATH="$HOME/.fnm:$PATH"
        eval `fnm env --multi`
    fi
}

function use-fnm {
    fnm use 2>/dev/null || { fnm install && fnm use }
}

function my-chpwd {
    if [[ -f .nvmrc ]]
    then
        if [[ -f "$HOME/.fnm/fnm" ]]
        then
            use-fnm
            return
        fi

        [[ $nvmAutoEnable != 1 ]] && return
        [[ "$(nvm version 2>/dev/null)" == "$(cat .nvmrc)" ]] || use-nvm
    fi
}
chpwd_functions=(${chpwd_functions[@]} "my-chpwd")

if [ ! -f "$HOME/.zshrc_include" ]; then
cat << EOF | tee $HOME/.zshrc_include >/dev/null
# vim: sw=4 et

alias vim='nvim'
export EDITOR=nvim
export LANG="en_US.UTF-8"
export HISTSIZE=10000
export HISTFILE="\$HOME/.history"
export SAVEHIST=$HISTSIZE

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export FT2_SUBPIXEL_HINTING=1

if [ -z "\$SSH_AUTH_SOCK" ] ; then
    eval \`ssh-agent -s\`
fi

EOF
fi

if [ ! -f "$HOME/.ssh/config" ]; then
mkdir -p $HOME/.ssh
cat << EOF | tee $HOME/.ssh/config >/dev/null
# vim: sw=4 et

ForwardAgent yes
VerifyHostKeyDNS yes
HashKnownHosts yes
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,ssh-rsa
PubkeyAcceptedKeyTypes ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,ssh-rsa
ServerAliveInterval 60
Compression yes
ControlMaster auto
ControlPath ~/.ssh/ssh-%r@%h:%p.socket
ControlPersist 7d
UseRoaming no
ExitOnForwardFailure no

#StrictHostKeyChecking accept-new # requires modern openssh
#ForwardX11 yes
#ForwardX11Trusted yes

EOF
chmod 0600 $HOME/.ssh/config
fi

# wget: Use UTF-8 as the default system encoding if it's supported
if [[ -f $(which wget 2>/dev/null) && -f $(which grep 2>/dev/null) ]]; then
    if wget --help | grep -q "local-encoding"; then
        sed -i 's/\#local_encoding/local_encoding/g' ~/.wgetrc
    fi
fi

source "$HOME/.zshrc_include"

if [[ $ZSH_MINIMAL != "true" ]]; then
    antigen apply
fi

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3;5~' kill-word # Ctrl+Del
bindkey '^H' backward-kill-word # Ctrl+Backspacce

autoload -U compinit && compinit -u
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan" # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting

if [[ $ZSH_MINIMAL != "true" ]]; then
    spaceship_vi_mode_disable || bindkey -e
fi

if [ ! -f "$HOME/.gnupg/gpg-agent.env" ]; then
    mkdir -pv "$HOME/.gnupg"
    chmod 0700 "$HOME/.gnupg"
    touch "$HOME/.gnupg/gpg-agent.env"
fi

if [[ $operatingSystem == "Linux" ]]; then
    if [[ $EUID -eq 0 ]]; then
        renice -n $n $$ > /dev/null
    fi
fi

# Rust
if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

echo "here is a random shell alias you might not known about: $(get-random-alias)"

unset n
unset condition_for_tmux_mem_cpu_load
