# vim: sw=4 et

[ -z "$ZPROF" ] || zmodload zsh/zprof

# Reset Colors
Color_Reset='\033[0m'

# Regular Colors
Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'

# Bold
Bold_Black='\033[1;30m'
Bold_Red='\033[1;31m'
Bold_Green='\033[1;32m'
Bold_Yellow='\033[1;33m'
Bold_Blue='\033[1;34m'
Bold_Purple='\033[1;35m'
Bold_Cyan='\033[1;36m'
Bold_White='\033[1;37m'

# Underline
Underline_Black='\033[4;30m'
Underline_Red='\033[4;31m'
Underline_Green='\033[4;32m'
Underline_Yellow='\033[4;33m'
Underline_Blue='\033[4;34m'
Underline_Purple='\033[4;35m'
Underline_Cyan='\033[4;36m'
Underline_White='\033[4;37m'

# Background
On_Black='\033[40m'
On_Red='\033[41m'
On_Green='\033[42m'
On_Yellow='\033[43m'
On_Blue='\033[44m'
On_Purple='\033[45m'
On_Cyan='\033[46m'
On_White='\033[47m'

# High Intensity
Intense_Black='\033[0;90m'
Intense_Red='\033[0;91m'
Intense_Green='\033[0;92m'
Intense_Yellow='\033[0;93m'
Intense_Blue='\033[0;94m'
Intense_Purple='\033[0;95m'
Intense_Cyan='\033[0;96m'
Intense_White='\033[0;97m'

# Bold High Intensity
Bold_Intense_Black='\033[1;90m'
Bold_Intense_Red='\033[1;91m'
Bold_Intense_Green='\033[1;92m'
Bold_Intense_Yellow='\033[1;93m'
Bold_Intense_Blue='\033[1;94m'
Bold_Intense_Purple='\033[1;95m'
Bold_Intense_Cyan='\033[1;96m'
Bold_Intense_White='\033[1;97m'

# High Intensity backgrounds
On_Intense_Black='\033[0;100m'
On_Intense_Red='\033[0;101m'
On_Intense_Green='\033[0;102m'
On_Intense_Yellow='\033[0;103m'
On_Intense_Blue='\033[0;104m'
On_Intense_Purple='\033[0;105m'
On_Intense_Cyan='\033[0;106m'
On_Intense_White='\033[0;107m'

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

if [[ $operatingSystem == "Linux" ]]; then
    n=$(nice)
    # increse process priotiy if user is root, this is useful if you're loggin in while the system is under high load
    if [[ $EUID -eq 0 ]]; then
        renice -n -20 $$ >/dev/null 2>&1
        ionice -c 2 -n 0 -p $$ >/dev/null 2>&1
    fi
fi

if [[ $operatingSystem == "Mac" ]]; then
    alias ls='ls -h -G'
    alias make="make -j\$(sysctl -n hw.ncpu)"
else
    alias ls='ls -h --color --group-directories-first'
    alias make="make -j\$(nproc)"
fi

# ixon: enable XON/XOFF flow control
# ixoff: enable sending of start/stop characters
# iutf8: assume input characters are UTF-8 encoded
stty -ixon -ixoff 2>/dev/null

# put keyboard and console in unicode mode.
# UNICODE_START(1)
unicode_start 2>/dev/null

# set unicode mode
kbd_mode -u 2>/dev/null

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

function ask_yn {
    if [ -n "$1" ]; then
        cat << EOF
Function to interactivly ask a simple "YES / NO" question with.

Usage:
 - Define "Yes" branch function like:
   function ask_yn_y_callback { echo "You choose Yes"; }
 - Define "No" branch function like:
   function ask_yn_n_callback { echo "You choose No"; }
 - Echo / Print your question (with a linebreak at the end)
 - call ask_yn
 - ask_yn_y_callback and ask_yn_n_callback do get unset automatically

Example:
    function ask_yn_y_callback {
        echo "You said yes, so doing stuff"
    }
    function ask_yn_n_callback {
        echo "You said no, doing stuff"
    }
    echo "Do want to do it?"; ask_yn
EOF
        return 1
    fi

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

    if [ -x ask_yn_y_callback ]; then
        unset -f ask_yn_y_callback
    fi
    if [ -x ask_yn_n_callback ]; then
        unset -f ask_yn_n_callback
    fi
}

alias sudo='sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK'
alias sudosu='sudo su -'
alias pls='sudo'
alias root='sudo su -l root'
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias ll='ls -l'
alias la='ls -al'
alias l='la'
alias grep='grep --color'
alias less='less --RAW-CONTROL-CHARS' # only ANSI "color" escape sequences and OSC 8 hyperlink sequences are output in "raw" form.
alias bat='bat --pager="less --RAW-CONTROL-CHARS"'
alias htop='htop -d 10'
alias iotop='iotop -d 1 -P -o'
alias rsync="rsync --progress --numeric-ids --human-readable --copy-links --hard-links"
alias brexit='echo "disable all network interfaces, delete 50% of all files and then reboot the dam thing!"; ask_yn_y_callback() { echo "See ya and peace out!"; exit; }; ask_yn_n_callback() { echo -n ""; }; ask_yn'
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote_plus(sys.stdin.read()));"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote_plus(sys.stdin.read()));"'
alias ceph-osd-heap-release='ceph tell "osd.*" heap release' # release unused memory by the ceph osd daemon(s).
alias ceph-watch-status='watch -n 1 ceph -s'
alias reset-swap='sudo swapoff -a; sudo swapon -a'
alias reset-fscache='sync; sudo echo 3 > /proc/sys/vm/drop_caches'
alias get-ip-local='hostname -I'
alias get-ip-internet='curl https://ip.compilenix.org 2>/dev/null | xargs'
function get-ip4-routes {
    if [ -n "$1" ]; then
        cat << EOF
List IPv4 routes.

Requirements:
- column
- ip

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    ip -4 route $* | column -t
}
function get-ip6-routes {
    if [ -n "$1" ]; then
        cat << EOF
List IPv4 routes.

Requirements:
- column
- ip

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    ip -6 route $* | column -t
}
alias get-network-listening-netstat='sudo netstat -tunpl'
alias get-network-listening='sudo ss --numeric --listening --processes --tcp --udp'
alias get-network-active-connections-netstat='sudo netstat -tun'
alias get-network-active-connections='ss --numeric --processes --tcp --udp -o state synchronized'
alias get-network-active-connections-by-type-netstat="sudo netstat -tun | awk '{print \$6}' | sort | uniq -c | sort -n | tail -n +2"
alias get-network-active-connections-by-type="sudo ss --summary"
alias get-ip4tables='sudo iptables -L -v'
alias get-ip4tables-nat='sudo iptables -t nat -L -v'
alias get-ip6tables='sudo ip6tables -L -v'
alias get-ip6tables-nat='sudo ip6tables -t nat -L -v'
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias watch-mem-dirty='watch -n 1 "cat /proc/meminfo | grep Dirty"'
alias get-date='date +"%Y-%m-%d.%H%M"'
alias get-date-unixtime='date +%s'
alias get-date-from-unixtime='read a; date -d @$a'
alias get-date-hex='get-date | xargs printf "%x\n"'
alias get-date-from-hex-unixtime='read a; echo $a | echo $((16#$_))'
alias get-date-from-hex='get-date-from-hex-unixtime | date -d @$_'
alias get-date-rfc-5322='date --rfc-email'
alias get-date-rfc-email='get-date-rfc-5322'
alias get-date-rfc-2616='LC_TIME="en_US.UTF-8" TZ="GMT" date "+%a, %d %b %Y %T %Z"'
alias get-date-rfc-http='get-date-rfc-2616'
alias get-date-rfc-3339-day='date --rfc-3339=date'
alias get-date-rfc-3339-second='date --rfc-3339=second'
alias get-date-rfc-3339-ns='date --rfc-3339=ns'
alias get-date-iso-8601-day='date --iso-8601=date'
alias get-date-iso-8601-hour='date --iso-8601=hours'
alias get-date-iso-8601-second='date --iso-8601=seconds'
alias get-date-iso-8601-ns='date --iso-8601=ns'
alias get-hpkp-pin='openssl x509 -pubkey -noout | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64'
alias get-cert-info-stdin='echo "paste pem cert and hit Control+D: ";cert=$(cat); echo $cert | openssl x509 -text -noout'
function get-cert-remote-raw {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ] || [ ! -n "$2" ]; then
        cat << EOF
Function to receive X509 pem encoded certificate from a remote system.

Requirements:
- openssl

Usage: $(echo $funcstack[-1]) server.domain.tld port_number

Example: $(echo $funcstack[-1]) google.com 443
EOF
        return 1
    fi

    hostName=$1
    portNumber=$2
    echo | openssl s_client -connect ${hostName}:${portNumber} -servername ${hostName} 2>/dev/null | openssl x509 -text
}
function get-cert-remote {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ] || [ ! -n "$2" ]; then
        cat << EOF
Function to make a full tls connect, printing various useful info, including
all X509 certificates (pem encoded) the remote systems has sent.

Requirements:
- openssl

Usage: $(echo $funcstack[-1]) server.domain.tld port_number

Example: $(echo $funcstack[-1]) google.com 443
EOF
        return 1
    fi
    hostName=$1
    portNumber=$2
    echo | openssl s_client -showcerts -x509_strict -connect ${hostName}:${portNumber} -servername ${hostName}
}
function get-cert-file {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Function to receive X509 pem encoded certificate from a local file.

Requirements:
- openssl

Usage: $(echo $funcstack[-1]) /some/path/to/file.pem
EOF
        return 1
    fi
    openssl x509 -noout -text -in $1
}
function new-dhparam {
    if [ -n "$1" ]; then
        cat << EOF
Function to generate DH Parameters file (pem encoded) and save it to
./dhparam.pem.

Requirements:
- openssl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    local dhparam_size
    echo -n "dhparam size [2048]: "; read dhparam_size
    if [[ "$dhparam_size" = "" ]]; then
        dhparam_size=2048
    fi

    openssl dhparam -out dhparam.pem "$dhparam_size"

    echo
    ls -l dhparam.pem
}
function new-cert-selfsigned {
    if [ -n "$1" ]; then
        cat << EOF
Function to generate a new self-signed certificate and private key.

Requirements:
- openssl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    local cert_type
    echo "Certificate Type, valid options are:"
    echo "- rsa:2048"
    echo "- rsa:4096"
    echo "- ed25519"
    echo -n "Certificate Type: "; read cert_type
    if [[ "$cert_type" = "ed25519" ]]; then
        openssl genpkey -algorithm ed25519 -out privkey.pem
    fi
    if [[ "$cert_type" = "rsa:2048" ]]; then
        openssl genrsa -out privkey.pem 2048
    fi
    if [[ "$cert_type" = "rsa:4096" ]]; then
        openssl genrsa -out privkey.pem 4096
    fi
    if [ ! -f privkey.pem ]; then
        echo "no valid certificate type choosen or error during generation" >/dev/stderr
        return 1
    fi

    local valid_for
    echo -n "Valid for days [3650]: "; read valid_for
    if [[ "$valid_for" = "" ]]; then
        valid_for=3650
    fi

    if [[ "$cert_type" != "ed25519" ]]; then
        local hash_alg
        echo -n "Hash Alg [-sha256 -sha384 -sha512]: "; read hash_alg
    fi

    local cert_subject
    echo -n "Subject [/C=/ST=/L=/O=/OU=/CN=localhost]: "; read cert_subject

    local cert_subject_alt_name
    echo -n "Subject Alt Names [DNS:localhost, DNS:localhost.localdomain]: "; read cert_subject_alt_name

    if [[ "$cert_type" = "ed25519" ]]; then
        openssl req \
            -key privkey.pem \
            -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nbasicConstraints=CA:FALSE\nkeyUsage=nonRepudiation,digitalSignature,keyEncipherment\nsubjectAltName=${cert_subject_alt_name}")) \
            -subj "$cert_subject" \
            -extensions SAN \
            -nodes \
            -x509 \
            -days "$valid_for" \
            -out cert.pem
    else
        openssl req \
            -key privkey.pem \
            -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nbasicConstraints=CA:FALSE\nkeyUsage=nonRepudiation,digitalSignature,keyEncipherment\nsubjectAltName=${cert_subject_alt_name}")) \
            "$hash_alg" \
            -subj "$cert_subject" \
            -extensions SAN \
            -nodes \
            -x509 \
            -days "$valid_for" \
            -out cert.pem
    fi

    echo
    ls -l privkey.pem cert.pem
}
function set-dns-query-stats-enable {
    if [ -n "$1" ]; then
        cat << EOF
Add "+stats" for "get-dns" function invocations.

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    export dns_query_stats='+stats'
}
function set-dns-query-stats-disable {
    if [ -n "$1" ]; then
        cat << EOF
Remove "+stats" for "get-dns" function invcations.

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    export dns_query_stats=''
}

function set-dns-query-additional-enable {
    if [ -n "$1" ]; then
        cat << EOF
Add "+additional" for "get-dns" function invocations.

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    export dns_query_additional='+additional'
}
function set-dns-query-additional-disable {
    if [ -n "$1" ]; then
        cat << EOF
Remove "+additional" for "get-dns" function invocations.

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    export dns_query_additional=''
}
set-dns-query-stats-enable
set-dns-query-additional-enable
alias get-dns="dig +noall \$(echo \$dns_query_stats) \$(echo \$dns_query_additional) +answer"
alias get-dns-dnssec="dig +noall \$(echo \$dns_query_stats) \$(echo \$dns_query_additional) +answer +dnssec"
alias get-dns-dnssec-verify="dig +noall \$(echo \$dns_query_stats) \$(echo \$dns_query_additional) +answer +dnssec +sigchase"
alias invoke-dns-retransfer='rndc retransfer'
alias invoke-dns-reload='rndc reload'
function compare-dns-soa-rr {
    if [ -n "$1" ]; then
        cat << EOF
Function to fetch and compare DNS SOA RR from differend dns servers.

Requirements:
- dig

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    local domain_name
    echo -n "Domain name: "; read domain_name

    local dns_servers
    echo -n "DNS Server ip addresses (space separated): "; read dns_servers

    local dns_server
    for dns_server in ${=dns_servers}; do
        echo "Testing $dns_server"
        dig +noall +answer SOA "$domain_name" "@$dns_server"
        dig +noall +answer NS "$domain_name" "@$dns_server"
    done
}
alias get-picture-metadata-curl='echo -n "URL: "; read a; curl -sr 0-1024 $a | strings'
alias get-picture-metadata-file='echo -n "file path: "; read a; dd bs=1 count=1024 if=$a 2>/dev/null | strings'
alias get-random-alias='alias | sort --random-sort | head -n 1'
alias get-random-password-strong='echo -n "length: "; read len; cat /dev/random | tr -dc "[:print:]" | head -c $len | awk "{ print $1 }"'  # awk adds a newline
alias get-random-password-alnum='echo -n "length: "; read len; cat /dev/random | tr -dc "[:alnum:]" | head -c $len | awk "{ print $1 }"'
alias get-random-password-alnum-lower='echo -n "length: "; read len; cat /dev/random | tr -dc "[:digit:][:lower:]" | head -c $len | awk "{ print $1 }"'
alias get-random-number-range='echo -n "from: "; read from; echo -n "to: "; read to; shuf -i ${from}-${to} -n 1'
alias get-random-guid='uuidgen'
alias get-random-hex='echo -n "length: "; read len; cat /dev/random | tr -dc "0-9a-f" | head -c $len | awk "{ print $1 }"'
alias get-random-ip4='python3 -c "import ipaddress, random; print(ipaddress.ip_address(random.randint(0, 0x7FFFFFFF)))"'
alias get-random-ip6='python3 -c "import ipaddress, random; print(ipaddress.ip_address(random.randint(0, 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)))"'
alias get-random-ip6-ula-network='python3 -c "from ipaddress import IPv6Network; import random; ula = IPv6Network(\"fd00::/8\"); print(IPv6Network((ula.network_address + (random.getrandbits(40) << 80), 48)))"'
alias get-random-port='shuf -i 16385-49151 -n 1'
alias get-fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'
alias get-process-zombie="ps --cols=9999 aux | awk '{if (\$8==\"Z\") { print \$1,\$2,\$11 }}'"
alias set-clipboard-x11="xclip -i -sel c -f"
alias set-clipboard-wayland="wl-copy"
alias get-clipboard-wayland="wl-paste"
alias get-ssh-pubkey='if [ -f ~/.ssh/id_ed25519.pub ]; then cat ~/.ssh/id_ed25519.pub; elif [ -f ~/.ssh/id_ed25519_pub ]; then content=$(cat ~/.ssh/id_ed25519_pub); fi; echo $content'
alias get-ssh-privkey='if [ -f ~/.ssh/id_ed25519 ]; then cat ~/.ssh/id_ed25519; elif [ -f ~/.ssh/id_ed25519 ]; then content=$(cat ~/.ssh/id_ed25519_pub); fi; echo $content'
alias get-ssh-pubkeys-host='(for file in /etc/ssh/*_key.pub; do echo "$file"; ssh-keygen -l -E md5 -f $file; ssh-keygen -l -E sha256 -f "$file"; echo; done)'
function get-sshfp-from-public-key {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ] || [ ! -n "$2" ]; then
        cat << EOF
Function to generate SSHFP (SSH Fingerprint) DNS RR from a given base64
encoded ssh public key file.

Requirements:
- hostname
- openssl
- sha1sum
- which

Usage: $(echo $funcstack[-1]) keytype keydata [hostname]

keytype     One of the following options:
                ssh-rsa
                ssh-dsa
                ecdsa-*
                ssh-ed25519
                ssh-ed448
keydata     Base64 encoded key data.
hostname    hostname to generate the DNS RR for, usually not a fqdn. Default
            value is "$(hostname -s)".

Examples:
$(echo $funcstack[-1]) ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdid7enWOuT8g0Z69wDm2gDPGer/aCQKcPhVojoZdyI
$(echo $funcstack[-1]) ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdid7enWOuT8g0Z69wDm2gDPGer/aCQKcPhVojoZdyI hostname
EOF
        return 1
    fi

    local keytype="$1"
    local keydata="$2"
    local hostname="$3"

    if [ ! -n "$3" ]; then
        hostname="$(hostname -s)"
    fi

    # fallback to openssl if sha1sum or sha256sum is not present
    if which openssl >/dev/null 2>&1; then
        if ! which sha1sum >/dev/null 2>&1; then
            sha1sum() {
                openssl dgst -sha1 | grep -E -o "[0-9a-f]{40}"
            }
        fi
        if ! which sha256sum >/dev/null 2>&1; then
            sha256sum() {
                openssl dgst -sha256 | grep -E -o "[0-9a-f]{64}"
            }
        fi
    fi

    case "$keytype"; in
    ssh-rsa)
        echo "$hostname IN SSHFP 1 1 $(echo "$keydata" | base64 --decode | sha1sum  | cut -f 1 -d ' ')"
        echo "$hostname IN SSHFP 1 2 $(echo "$keydata" | base64 --decode | sha256sum  | cut -f 1 -d ' ')"
    ;;
    ssh-dsa)
        echo "$hostname IN SSHFP 2 1 $(echo "$keydata" | base64 --decode | sha1sum  | cut -f 1 -d ' ')"
        echo "$hostname IN SSHFP 2 2 $(echo "$keydata" | base64 --decode | sha256sum  | cut -f 1 -d ' ')"
    ;;
    ecdsa-*)
        echo "$hostname IN SSHFP 3 1 $(echo "$keydata" | base64 --decode | sha1sum  | cut -f 1 -d ' ')"
        echo "$hostname IN SSHFP 3 2 $(echo "$keydata" | base64 --decode | sha256sum  | cut -f 1 -d ' ')"
    ;;
    ssh-ed25519)
        echo "$hostname IN SSHFP 4 1 $(echo "$keydata" | base64 --decode | sha1sum  | cut -f 1 -d ' ')"
        echo "$hostname IN SSHFP 4 2 $(echo "$keydata" | base64 --decode | sha256sum  | cut -f 1 -d ' ')"
    ;;
    ssh-ed448)
        echo "$hostname IN SSHFP 6 1 $(echo "$keydata" | base64 --decode | sha1sum  | cut -f 1 -d ' ')"
        echo "$hostname IN SSHFP 6 2 $(echo "$keydata" | base64 --decode | sha256sum  | cut -f 1 -d ' ')"
    ;;
    esac
}
function get-sshfp-from-public-key-file {
    if [ ! -n "$1" ]; then
        cat << EOF
Function to generate SSHFP (SSH Fingerprint) DNS RR from a ssh public key file.

Requirements:
- hostname
- openssl
- sha1sum
- which

Usage: $(echo $funcstack[-1]) file [hostname]

file        path to a ssh public key file.
hostname    hostname to generate the DNS RR for, usually not a fqdn. Default
            value is "$(hostname -s)".

Examples:
$(echo $funcstack[-1]) /etc/ssh/ssh_host_ed25519_key.pub
$(echo $funcstack[-1]) /etc/ssh/ssh_host_ed25519_key.pub hostname
EOF
        return 1
    fi

    local file="$1"
    local hostname="$2"

    get-sshfp-from-public-key "$(cut -d ' ' -f1 "$file")" "$(cut -f2 -d ' ' "$file")" "$hostname"
}
function get-sshfp-from-public-key-directory {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Function to generate SSHFP (SSH Fingerprint) DNS RR from a directory
which contains one or more ssh public key files named "ssh_host_*_key.pub".

Requirements:
- hostname
- openssl
- sha1sum
- which

Usage: $(echo $funcstack[-1]) directory [hostname]

directory   path to a directory which contains ssh public key files.
hostname    hostname to generate the DNS RR for, usually not a fqdn. Default
            value is "$(hostname -s)".

Examples:
$(echo $funcstack[-1]) /etc/ssh
$(echo $funcstack[-1]) /etc/ssh hostname
EOF
        return 1
    fi

    local directory="$1"
    local hostname="$2"

    for file in $directory/ssh_host_*_key.pub; do
        get-sshfp-from-public-key "$(cut -d ' ' -f1 "$file")" "$(cut -f2 -d ' ' "$file")" "$hostname"
    done
}
function get-ssh-keys-from-remote {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Function to fetch ssh public keys from a remote system.

Requirements:
- ssh-keyscan

Usage: $(echo $funcstack[-1]) hostname [port]

hostname    hostname to generate the DNS RR for, usually not a fqdn. Default
            value is "$(hostname -s)".
port        the port number, default is "22".

Examples:
$(echo $funcstack[-1]) hostname.domain.tld
$(echo $funcstack[-1]) hostname.domain.tld 2222
EOF
        return 1
    fi

    local hostname="$1"
    local port="$2"

    if [ ! -n "$2" ]; then
        port="22"
    fi

    ssh-keyscan -p $port "$hostname"
}
function get-debian-package-description {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Get the description of a debian package.

Requirements:
- awk
- dpkg
- grep
- sed

Usage: $(echo $funcstack[-1]) package_name

Example: $(echo $funcstack[-1]) apt
EOF
        return 1
    fi

    dpkg -l "$1" | grep --color " $1 " | awk '{$1=$2=$3=$4="";print $0}' | sed 's/^ *//'
}
function get-debian-package-description-pipe {
    if [ -n "$1" ]; then
        cat << EOF
Get the description of a debian package, via piping.

Requirements:
- awk
- dpkg
- grep
- sed

Usage: $(echo $funcstack[-1])

Example: echo apt | $(echo $funcstack[-1])
EOF
        return 1
    fi

    local input
    read input
    get-debian-package-description "$input"
}
function get-debian-package-updates {
    if [ -n "$1" ]; then
        cat << EOF
List all avaliable debian package updates.

Requirements:
- apt
- perl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    apt --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'
}
function get-dataurl {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Function to generate a data URL from a file.

Requirements:
- openssl
- tr

Usage: $(echo $funcstack[-1]) file

file        path to a file

Example:
$(echo $funcstack[-1]) ./some.jpg
EOF
        return 1
    fi

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
function update-debian {
    if [ -n "$1" ]; then
        cat << EOF
Install all Debian package updates:
- apt update
- apt autoremove
- apt upgrade
- apt autoremove
- apt autoclean

Requirements:
- apt
- sudo

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    echo "do an \"apt update\"?"
    function ask_yn_y_callback {
        set -x
        sudo apt update
        set +x
    }
    function ask_yn_n_callback {
        echo ""
    }
    ask_yn
    set -x
    apt autoremove
    apt list --upgradable
    sudo apt upgrade
    sudo apt autoremove
    sudo apt autoclean
    set +x
}
alias update-yum='sudo yum update --refresh'
alias update-fedora='sudo dnf update --refresh'
alias gitg='git gui'
function reset-git {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Invoke "git reset --hard" for all parameter directories.

Requirements:
- git

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    for i in $*; do
        if [ ! -d "$i" ]; then
            echo "$(echo $funcstack[-1]): Not a directory: $i"
            continue
        fi
        if [ ! -d "$i/.git" ]; then
            echo "$(echo $funcstack[-1]): Not a git directory: $i"
            continue
        fi

        echo -e "$(echo $funcstack[-1]): \033[0;36mgit reset --hard $i\033[0;0m"
        pushd "$i" >/dev/null
            git reset --hard
        popd >/dev/null
    done
}
function update-dotfiles-non-interactive {
    if [ -n "$1" ]; then
        cat << EOF
Update dotfiles.

Requirements:
- cat
- chmod
- chown
- git
- ln
- mkdir
- mv
- python 3.8+
- tar
- touch
- unlink
- zstd

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    reset-git ~/dotfiles
    pushd ~/dotfiles >/dev/null
        git pull --all
        ./update.sh
    popd >/dev/null
    if [ -f "/tmp/$USER-zsh-dotfiles-async-update-exists.yep" ]; then
        rm "/tmp/$USER-zsh-dotfiles-async-update-exists.yep"
    fi
}
function update-dotfiles {
    if [ -n "$1" ]; then
        cat << EOF
Update dotfiles.

Requirements:
- cat
- chmod
- chown
- git
- ln
- mkdir
- mv
- python 3.8+
- tar
- touch
- unlink
- zstd

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    pushd ~/dotfiles >/dev/null
        git status
    popd >/dev/null
    echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/dotfiles && git status\""
    echo "Do you want proceed with the update?"
    function ask_yn_y_callback {
        update-dotfiles-non-interactive
    }
    function ask_yn_n_callback {
        echo -n ""
    }
    ask_yn
}
alias disable-dotfiles-update-prompt-temp='touch "/tmp/$USER-zsh-dotfiles-async-update-check.disabled"'
alias update-code-insiders-rpm='wget "https://go.microsoft.com/fwlink/?LinkID=760866" -O /tmp/code-insiders.rpm && sudo yum install -y /tmp/code-insiders.rpm && rm /tmp/code-insiders.rpm'
alias test-mail-sendmail='echo -n "To: "; read mail_to_addr; echo -e "From: ${USER}@$(hostname -f)\nTo: ${mail_to_addr}\nSubject: test subject\n\ntest body" | sendmail -v "${mail_to_addr}"'
alias test-mail-mutt='mutt -s "test" '
function send-mail {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ] || [ ! -n "$2" ]; then
        cat << EOF
Function to send a test e-mail using sendmail.

Requirements:
- sendmail

Usage: $(echo $funcstack[-1]) recipient subject

recipient   recipient e-mail address
subject     the subject of the message

Example:
echo "Test message body" | $(echo $funcstack[-1]) person@domain.tld "Test Subject"
EOF
        return 1
    fi

    local to="$1"

    local subject="$2"
    local body="$(< /dev/stdin)"

    cat << EOF | sendmail "$to"
From: ${USER}@$(hostname -f)
To: $to
Subject: $subject

$body

EOF
}
function apache-configtest {
    if [ -n "$1" ]; then
        cat << EOF
Test apache configuration.

Requirements:
- apache2ctl
- sudo

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    sudo apache2ctl -t
}
function apache-reload {
    if [ -n "$1" ]; then
        cat << EOF
Test apache configuration and invoke configuration reload.

Requirements:
- apache2ctl
- sudo
- systemctl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    apache-configtest && { sudo systemctl reload apache2 || sudo systemctl status apache2 }
}
function apache-restart {
    if [ -n "$1" ]; then
        cat << EOF
Test apache configuration and invoke a service restart.

Requirements:
- apache2ctl
- sudo
- systemctl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    apache-configtest && { sudo systemctl restart apache2 || sudo systemctl status apache2 }
}
function nginx-status {
    if [ -n "$1" ]; then
        cat << EOF
Show current nginx service status.

Requirements:
- sudo
- systemctl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    sudo systemctl status nginx
}
function nginx-configtest {
    if [ -n "$1" ]; then
        cat << EOF
Test nginx configuration.

Requirements:
- nginx
- sudo

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    sudo nginx -t
}
function nginx-reload {
    if [ -n "$1" ]; then
        cat << EOF
Test nginx configuration and invoke configuration reload.

Requirements:
- nginx
- sudo
- systemctl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    nginx-configtest && { sudo systemctl reload nginx || sudo systemctl status nginx }
}
function nginx-restart {
    if [ -n "$1" ]; then
        cat << EOF
Test nginx configuration and invoke a service restart.

Requirements:
- nginx
- sudo
- systemctl

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    nginx-configtest && { sudo systemctl restart nginx || sudo systemctl status nginx }
}
function view-logfile {
    if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
        cat << EOF
Function to view a log file, with log syntax highlighting.

Requirements:
- cat
- ccze
- less
- sudo

Usage: $(echo $funcstack[-1]) file

file        path to a file

Example:
$(echo $funcstack[-1]) /var/log/messages.log
EOF
        return 1
    fi

    file="$1"
    sudo cat "${file}" | ccze -A | less -R
}
alias get-processes='ps --cols=9999 aux'
alias get-processes-systemd='systemd-cgls'
alias get-memory='free -h -m'
alias get-disk-space='df -h'
alias get-disks='lsblk -f'
alias get-mounts='mount | column -t'
alias start-stopwatch='echo "press Ctrl+D to stop"; time cat'
alias install-node-fnm='curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash'
alias add-user='useradd'
alias remove-user='deluser'
alias docker-inspect-image='dive' # https://github.com/wagoodman/dive
alias get-hostname='hostname -s'
alias get-hostname-fqdn='hostname -f'
alias get-hostname-domain='hostname -d'
alias view-kernel-log='dmesg -H'
alias view-history='history | sort --reverse | less'
alias remove-history='echo >$HOME/.history; history -p'
alias get-systemd-units='systemctl list-units'
alias get-systemd-units-service='systemctl list-units --type service'
alias get-systemd-units-failed='systemctl list-units --state failed'
alias get-systemd-units-timer='systemctl list-timers'
alias reload-systemd-units='systemctl daemon-reload'
alias get-kernel-psi='for i in /proc/pressure/*; do echo $(basename $i); cat $i; echo; done'
function get-time-chrony-status {
    if [ -n "$1" ]; then
        cat << EOF
Get the current state of connected ntp upstream sources.

Requirements:
- chronyc

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    local fn_name=$(echo $funcstack[-1])
    echo "+$fn_name> systemctl status chronyd.service"
    systemctl status chronyd.service
    echo
    echo "+$fn_name> chronyc -n activity # Check how many NTP sources are online/offline"
    chronyc -n activity
    echo
    echo "+$fn_name> chronyc -n tracking # Display system time information"
    chronyc -n tracking
    echo
    echo "+$fn_name> chronyc -n ntpdata # Display information about last valid measurement"
    chronyc -n ntpdata
    echo
    echo "+$fn_name> chronyc -n selectdata # Display information about source selection"
    chronyc -n selectdata
    echo
    echo "+$fn_name> chronyc -n sources # Display information about current sources"
    chronyc -n sources
    echo
    echo "+$fn_name> chronyc -n sourcestats # Display statistics about collected measurements"
    chronyc -n sourcestats
}

function get-aliases {
    if [ -n "$1" ]; then
        cat << EOF
Get list of all zsh aliases defined by dotfiles.

Requirements:
- grep
- sort

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    grep -E '^alias ' ~/.zshrc | sort
}
function get-functions {
    if [ -n "$1" ]; then
        cat << EOF
Get list of all zsh functions defined by dotfiles.

Requirements:
- awk
- grep
- sort

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    grep -E '^function ' ~/.zshrc | awk '{ print $2 }' | sort
}
function insert-datetime {
    if [ -n "$1" ]; then
        cat << EOF
Function to insert a timestamp at the beginning of each line passed into stdin.

Requirements:
- awk

Usage: $(echo $funcstack[-1])

file        path to a file

Example:
echo fooo 2>&1 1>/dev/null | $(echo $funcstack[-1]) | tee /tmp/test.log

Result:
[2021-03-30 19:03:02 CEST]: fooo
EOF
        return 1
    fi

    awk '{ print strftime("[%F %X %Z]:"), $0; fflush(); }'
}
function remove-docker-image-untagged {
    if [ -n "$1" ]; then
        cat << EOF
Function to remove all docker images which dont have a tag.

Requirements:
- docker
- grep
- awk

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    local image
    for image in $(docker image ls | grep '<none>' | awk '{ print $3 }'); do
        docker image rm $image
    done
}
alias virtualenv='python3 -m venv'


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
    if [ -n "$1" ]; then
        cat << EOF
Function to remove docker, if it's installed, and install podman on a fedora
system.

Requirements:
- dnf
- sudo
- wget

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

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
    if [ -n "$1" ]; then
        cat << EOF
Function to remove podman on a fedora system.

Requirements:
- dnf
- rm
- sudo

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    sudo dnf remove podman
    sudo dnf update container-selinux
    rm -v ~/.zsh/completion/_podman 2>/dev/null
    unalias docker 2>/dev/null
    exec zsh
}

export PATH=".cargo/bin:./node_modules/.bin:$HOME/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/dotfiles/home/dotfiles_bin:/usr/lib/node_modules/.bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
unalias vim 2>/dev/null
alias vim='nvim'
export EDITOR='nvim'
export MERGE='vimdiff'
export WORDCHARS=''

# if it's an ssh session export GPG_TTY
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

setopt hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt extendedglob
setopt extended_history       # Write the history file in the ":start:elapsed;command" format.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_ignore_space      # Don't record an entry starting with a space.
setopt hist_verify            # Don't execute immediately upon history expansion.
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt long_list_jobs
setopt interactive_comments
unsetopt share_history

fpath=( "$HOME/bin/.zfunctions" $fpath )

ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_FIXTERM=false
COMPLETION_WAITING_DOTS=true
DISABLE_MAGIC_FUNCTIONS=true

if [[ $ENABLE_ZSH_SPACESHIP_PROMPT == "true" ]]; then
    SPACESHIP_PROMPT_ADD_NEWLINE=false
    SPACESHIP_PROMPT_SEPARATE_LINE=true
    SPACESHIP_TIME_SHOW=true
    SPACESHIP_USER_SHOW=always
    SPACESHIP_HOST_SHOW=always
    SPACESHIP_HOST_SHOW_FULL=true
    SPACESHIP_BATTERY_THRESHOLD=25
    SPACESHIP_EXIT_CODE_SHOW=true
    # SPACESHIP_EXIT_CODE_SUFFIX=" (╯°□°）╯︵ ┻━┻ "

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
    SPACESHIP_PYTHON_SHOW=false
    SPACESHIP_DOTNET_SHOW=false
    SPACESHIP_EMBER_SHOW=false
    SPACESHIP_PACKAGE_SHOW=false
    SPACESHIP_GIT_SHOW=false
    SPACESHIP_ASYNC_SYMBOL=""
fi

if [[ $ENABLE_ZSH_AUTOSUGGEST == "true" ]]; then
    ZSH_AUTOSUGGEST_ENABLED="false"
    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_ENABLED="true"
    fi
    if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_ENABLED="true"
    fi
    if [[ $ZSH_AUTOSUGGEST_ENABLED == "false" ]]; then
        echo "Warning: you requested to enable the ZSH Autosuggestions plugin, but it could not be found at the following expected location: /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    export ZSH_AUTOSUGGEST_USE_ASYNC=true
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
# [ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _global_ssh_hosts=()
#[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
#[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_config[@]"
#   "$_global_ssh_hosts[@]"
#   "$_ssh_hosts[@]"
#   "$_etc_hosts[@]"
#   "$HOST"
#   localhost
)
zstyle ':completion:*:hosts' hosts $hosts

function enable-fnm {
    if [ -n "$1" ]; then
        cat << EOF
Function to enable fnm.

fast node manager (https://github.com/Schniz/fnm)

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    if [[ -f "$HOME/.fnm/fnm" ]]
    then
        export PATH="$HOME/.fnm:$PATH"
        eval `fnm env`
    fi
}

function use-fnm {
    if [ -n "$1" ]; then
        cat << EOF
Run "fnm use" and if it fails run "fnm install && fnm use".

fast node manager (https://github.com/Schniz/fnm)

Usage: $(echo $funcstack[-1])
EOF
        return 1
    fi

    fnm use 2>/dev/null || { fnm install && fnm use }
}

function my-chpwd {
    if [ -n "$1" ]; then
        cat << EOF
This function is invoked every time you switch to a new directory.

The following things do run here (in that order):
- if file "./.nvmrc" exists run "use-fnm"

Usage: none
EOF
        return 1
    fi

    if [[ -f ".nvmrc" ]] && [[ -f "$HOME/.fnm/fnm" ]]; then
        echo "./.nvmrc is present and fnm is installed. Loading node version..."
        enable-fnm
        use-fnm
    fi

    if [[ "$ENABLE_ZSH_ENV_FILE_SOURCE" = "true" ]] && [[ -f ".env" ]]; then
        echo -e "ENABLE_ZSH_ENV_FILE_SOURCE is set to \"true\". running \"source .env\""
        source .env
        echo -e "\"source .env\" complete"
    fi
}
chpwd_functions=(${chpwd_functions[@]} "my-chpwd")

source "$HOME/.zshrc_include"

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

bindkey '^H' backward-kill-word # Ctrl+Backspacce

bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
if [ ! -d "$HOME/.cache/zsh" ]; then mkdir -p "$HOME/.cache/zsh"; fi
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
# ... unless we really want to.
zstyle '*' single-ignored show

if [[ $COMPLETION_WAITING_DOTS = true ]]; then
  expand-or-complete-with-dots() {
    print -Pn "%F{red}...%f"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  # Set the function as the default tab completion widget
  bindkey -M emacs "^I" expand-or-complete-with-dots
  bindkey -M viins "^I" expand-or-complete-with-dots
  bindkey -M vicmd "^I" expand-or-complete-with-dots
fi

# https://stackoverflow.com/a/67161186
autoload -Uz compinit bashcompinit promptinit
compinit
bashcompinit
promptinit

if [[ $ENABLE_ZSH_SPACESHIP_PROMPT == "true" ]]; then
    prompt spaceship
    if typeset -f spaceship_vi_mode_disable >/dev/null; then
        spaceship_vi_mode_disable
    else
        bindkey -e
    fi
fi

if [[ $ENABLE_ZSH_SYNTAX_HIGHLIGHTING == "true" ]]; then
    set-zsh-highlighting-full
    export ZSH_HIGHLIGHT_MAXLENGTH=512
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan" # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
    ZSH_SYNTAX_HIGHLIGHTING_ENABLED="false"
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_SYNTAX_HIGHLIGHTING_ENABLED="true"
    fi
    if [[ $ZSH_SYNTAX_HIGHLIGHTING_ENABLED == "false" ]] && [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_SYNTAX_HIGHLIGHTING_ENABLED="true"
    fi
    if [[ $ZSH_SYNTAX_HIGHLIGHTING_ENABLED == "false" ]] && [ -f /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh ]; then
        # usually observed on gentoo
        source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
        ZSH_SYNTAX_HIGHLIGHTING_ENABLED="true"
    fi
    if [[ $ZSH_SYNTAX_HIGHLIGHTING_ENABLED == "false" ]]; then
        echo "Warning: you requested to enable the ZSH Syntax Highlighting plugin via ENABLE_ZSH_SYNTAX_HIGHLIGHTING, but it could not be found at one of the following expected locations:"
        echo " - /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        echo " - /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        echo " - /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh"
    fi
fi

if [[ $operatingSystem == "Linux" ]]; then
    if [[ $EUID -eq 0 ]]; then
        renice -n $n $$ >/dev/null 2>&1
    fi
fi
unset n

# check for new git commits on remote and if so, create a file in /tmp as an indicator
if [[ "$ENABLE_ZSH_ASYNC_UPDATE_CHECK" = "true" ]]; then
    test-dotfiles-updates() {
        if [ -f "/tmp/$USER-zsh-dotfiles-async-update-check.lock" ]; then
            # another process execting this function is already present
            return
        fi
        if [ -f "/tmp/$USER-zsh-dotfiles-async-update-exists.yep" ]; then
            # we already know that an update exists
            return
        fi
        if [ -f "/tmp/$USER-zsh-dotfiles-async-update-check.disabled" ]; then
            # the user requested to temporarily not check for updates
            return
        fi
        touch "/tmp/$USER-zsh-dotfiles-async-update-check.lock"

        cd "$HOME/dotfiles"
        command git fetch --all >/dev/null 2>&1
        local remote_name=$(command git remote)
        local current_branch=$(command git branch --show-current)
        local behind_ref_count=$(command git rev-list --count "HEAD..$remote_name/$current_branch")
        if (( $behind_ref_count )); then
            touch "/tmp/$USER-zsh-dotfiles-async-update-exists.yep"
        fi
        rm "/tmp/$USER-zsh-dotfiles-async-update-check.lock"
     }

     # run function as background job and in a subshell to discard it's job creation message
     (test-dotfiles-updates &)
fi

# check if an indicator for dotfiles updates exists and if so, prompt the user
if [ -f "/tmp/$USER-zsh-dotfiles-async-update-exists.yep" ]; then
    if [ ! -f "/tmp/$USER-zsh-dotfiles-async-update-check.disabled" ]; then
        echo "🎉 There are dotfiles updates availabe 🎉"
        echo "You can temporarily disable this prompt by running: ${Green}disable-dotfiles-update-prompt-temp${Color_Reset}"
        echo "You can permanently disable this prompt by setting \"${Bold_White}ENABLE_ZSH_ENV_FILE_SOURCE${Color_Reset}\" to \"${Green}false${Color_Reset}\" in ${Yellow}\"$HOME/.zshrc.env\"${Color_Reset}"
        echo
        cd "$HOME/dotfiles"
        local remote_name=$(command git remote)
        local current_branch=$(command git branch --show-current)
        local behind_ref_count=$(command git rev-list --count "HEAD..$remote_name/$current_branch")
        echo "This is the git commit log:"
        command git log --oneline --graph --decorate --all "HEAD..$remote_name/$current_branch"
        popd >/dev/null
        echo
        update-dotfiles && rm "/tmp/$USER-zsh-dotfiles-async-update-exists.yep" && echo "exec zsh" && exec zsh
    fi
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if [ -f "$HOME/.git-credentials" ]; then
    echo "Remove unencrypted on-disk git credential cache"
    rm -v "$HOME/.git-credentials"
fi
if [ -f "$XDG_CONFIG_HOME/git/credentials" ]; then
    echo "Remove unencrypted on-disk git credential cache"
    rm -v "$XDG_CONFIG_HOME/git/credentials"
fi

echo "here is a shell alias you might not known about (get-random-alias):\n    $(get-random-alias)"

[ -z "$ZPROF" ] || zprof

