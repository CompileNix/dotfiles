#!/bin/bash
# vim: sw=4 et

spaceship_prompt_version=7fd996383de095c9a43d8129628ae10c5cfa8de5
tmux_mem_cpu_load_version=b6afa5c5e96620743f9466a8a41e1db6238de39d

echo "pull dotfiles from remote"
git pull --all || exit $?

if [ -f "$HOME/dotfiles/config.yml" ]; then
    echo "Migrate dotfiles config file from \"$HOME/dotfiles/config.yml\" to \"$HOME/.config/dotfiles/compilenix/config.yml\""
    mkdir -pv "$HOME/.config/dotfiles/compilenix"
    mv -v "$HOME/dotfiles/config.yml" "$HOME/.config/dotfiles/compilenix/config.yml"
fi

echo "remove old stuff"
if [ -d "$HOME/antigen" ]; then
    rm -r "$HOME/antigen"
    echo "    removed directory '$HOME/.homesick'"
fi
if [ -d "$HOME/.antigen" ]; then
    rm -r "$HOME/.antigen"
    echo "    removed directory '$HOME/.antigen'"
fi
if [ -d "$HOME/bin_dotfiles" ]; then
    rm -r "$HOME/bin_dotfiles"
    echo "    removed directory '$HOME/bin_dotfiles'"
fi
if [ -d "$HOME/.vim/bundle/vundle" ]; then
    rm -r "$HOME/.vim/bundle/vundle"
    echo "    removed directory '$HOME/.vim/bundle/vundle'"
fi
if [ -f "$HOME/.tmux.conf_configured" ]; then
    rm -v "$HOME/.tmux.conf_configured"
fi

echo "Remove Symlinks from from files of most recent version"
if [ -f "$HOME/.Xresources" ]; then
    if [[ "$(readlink -- $HOME/.Xresources)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.Xresources"
    fi
fi
if [ -f "$HOME/.config/clipit/clipitrc" ]; then
    if [[ "$(readlink -- $HOME/.config/clipit/clipitrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/clipit/clipitrc"
    fi
fi
if [ -f "$HOME/.config/compton.conf" ]; then
    if [[ "$(readlink -- $HOME/.config/compton.conf)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/compton.conf"
    fi
fi
if [ -d "$HOME/.config/firefox-themes" ]; then
    if [[ "$(readlink -- $HOME/.config/firefox-themes)" =~ ".homesick/repos/" ]]; then
        rm -rv "$HOME/.config/firefox-themes"
        echo "    removed directory '$HOME/.config/firefox-themes'"
    fi
fi
if [ -f "$HOME/.config/git/gitk" ]; then
    if [[ "$(readlink -- $HOME/.config/git/gitk)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/git/gitk"
    fi
fi
if [ -f "$HOME/.config/htop/htoprc" ]; then
    if [[ "$(readlink -- $HOME/.config/htop/htoprc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/htop/htoprc"
    fi
fi
if [ -f "$HOME/.config/i3/config.example" ]; then
    if [[ "$(readlink -- $HOME/.config/i3/config.example)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/i3/config.example"
    fi
fi
if [ -f "$HOME/.config/mc/ini" ]; then
    if [[ "$(readlink -- $HOME/.config/mc/ini)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/mc/ini"
    fi
fi
if [ -f "$HOME/.config/mc/panels.ini" ]; then
    if [[ "$(readlink -- $HOME/.config/mc/panels.ini)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/mc/panels.ini"
    fi
fi
if [ -f "$HOME/.config/mimeapps.list" ]; then
    if [[ "$(readlink -- $HOME/.config/mimeapps.list)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/mimeapps.list"
    fi
fi
if [ -f "$HOME/.config/nvim/init.vim" ]; then
    if [[ "$(readlink -- $HOME/.config/nvim/init.vim)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/nvim/init.vim"
    fi
fi
if [ -f "$HOME/.config/pavucontrol.ini" ]; then
    if [[ "$(readlink -- $HOME/.config/pavucontrol.ini)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/pavucontrol.ini"
    fi
fi
if [ -f "$HOME/.config/sway/config" ]; then
    if [[ "$(readlink -- $HOME/.config/sway/config)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/sway/config"
    fi
fi
if [ -f "$HOME/.config/sway/config.d/10-intputs.config.example" ]; then
    if [[ "$(readlink -- $HOME/.config/sway/config.d/10-intputs.config.example)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/sway/config.d/10-intputs.config.example"
    fi
fi
if [ -f "$HOME/.config/sway/config.d/10-outputs.config.example" ]; then
    if [[ "$(readlink -- $HOME/.config/sway/config.d/10-outputs.config.example)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/sway/config.d/10-outputs.config.example"
    fi
fi
if [ -f "$HOME/.config/sway/config.d/90-autostart.config" ]; then
    if [[ "$(readlink -- $HOME/.config/sway/config.d/90-autostart.config)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/sway/config.d/90-autostart.config"
    fi
fi
if [ -f "$HOME/.config/sway/config.d/91-autostart.config.example" ]; then
    if [[ "$(readlink -- $HOME/.config/sway/config.d/91-autostart.config.example)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/sway/config.d/91-autostart.config.example"
    fi
fi
if [ -f "$HOME/.config/volumeicon/volumeicon" ]; then
    if [[ "$(readlink -- $HOME/.config/volumeicon/volumeicon)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/volumeicon/volumeicon"
    fi
fi
if [ -f "$HOME/.config/waybar/config" ]; then
    if [[ "$(readlink -- $HOME/.config/waybar/config)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.config/waybar/config"
    fi
fi
if [ -f "$HOME/.curlrc" ]; then
    if [[ "$(readlink -- $HOME/.curlrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.curlrc"
    fi
fi
if [ -f "$HOME/.gitconfig" ]; then
    if [[ "$(readlink -- $HOME/.gitconfig)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.gitconfig"
    fi
fi
if [ -f "$HOME/.gitignore_global" ]; then
    if [[ "$(readlink -- $HOME/.gitignore_global)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.gitignore_global"
    fi
fi
if [ -f "$HOME/.gnupg/gpg.conf" ]; then
    if [[ "$(readlink -- $HOME/.gnupg/gpg.conf)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.gnupg/gpg.conf"
    fi
fi
if [ -f "$HOME/.icons/theme/cursors/text" ]; then
    if [[ "$(readlink -- $HOME/.icons/theme/cursors/text)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.icons/theme/cursors/text"
    fi
fi
if [ -f "$HOME/.icons/theme/cursors/xterm" ]; then
    if [[ "$(readlink -- $HOME/.icons/theme/cursors/xterm)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.icons/theme/cursors/xterm"
    fi
fi
if [ -f "$HOME/.screenrc" ]; then
    if [[ "$(readlink -- $HOME/.screenrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.screenrc"
    fi
fi
if [ -f "$HOME/.tmux.conf_v1" ]; then
    if [[ "$(readlink -- $HOME/.tmux.conf_v1)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.tmux.conf_v1"
    fi
fi
if [ -f "$HOME/.tmux.conf_v2" ]; then
    if [[ "$(readlink -- $HOME/.tmux.conf_v2)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.tmux.conf_v2"
    fi
fi
if [ -f "$HOME/.vim/colors/mustang.vim" ]; then
    if [[ "$(readlink -- $HOME/.vim/colors/mustang.vim)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.vim/colors/mustang.vim"
    fi
fi
if [ -f "$HOME/.vimrc" ]; then
    if [[ "$(readlink -- $HOME/.vimrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.vimrc"
    fi
fi
if [ -f "$HOME/.wgetrc" ]; then
    if [[ "$(readlink -- $HOME/.wgetrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.wgetrc"
    fi
fi
if [ -f "$HOME/.xinitrc" ]; then
    if [[ "$(readlink -- $HOME/.xinitrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.xinitrc"
    fi
fi
if [ -f "$HOME/.xinitrc_reset" ]; then
    if [[ "$(readlink -- $HOME/.xinitrc_reset)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.xinitrc_reset"
    fi
fi
if [ -f "$HOME/.zshrc" ]; then
    if [[ "$(readlink -- $HOME/.zshrc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/.zshrc"
    fi
fi
if [ -f "$HOME/bin_dotfiles/Wait-PidExit" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/Wait-PidExit)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/Wait-PidExit"
    fi
fi
if [ -f "$HOME/bin_dotfiles/build-xfreerdp.sh" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/build-xfreerdp.sh)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/build-xfreerdp.sh"
    fi
fi
if [ -f "$HOME/bin_dotfiles/calc" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/calc)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/calc"
    fi
fi
if [ -f "$HOME/bin_dotfiles/get-http-headers" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/get-http-headers)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/get-http-headers"
    fi
fi
if [ -f "$HOME/bin_dotfiles/gpg" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/gpg)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/gpg"
    fi
fi
if [ -f "$HOME/bin_dotfiles/grimshot" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/grimshot)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/grimshot"
    fi
fi
if [ -f "$HOME/bin_dotfiles/iv" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/iv)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/iv"
    fi
fi
if [ -f "$HOME/bin_dotfiles/lock.sh" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/lock.sh)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/lock.sh"
    fi
fi
if [ -f "$HOME/bin_dotfiles/sway" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/sway)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/sway"
    fi
fi
if [ -f "$HOME/bin_dotfiles/sway-lock.sh" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/sway-lock.sh)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/sway-lock.sh"
    fi
fi
if [ -f "$HOME/bin_dotfiles/volume.sh" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/volume.sh)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/volume.sh"
    fi
fi
if [ -f "$HOME/bin_dotfiles/wl-xwayland-get-active-output.sh" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/wl-xwayland-get-active-output.sh)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/wl-xwayland-get-active-output.sh"
    fi
fi
if [ -f "$HOME/bin_dotfiles/xinitrc_reset" ]; then
    if [[ "$(readlink -- $HOME/bin_dotfiles/xinitrc_reset)" =~ ".homesick/repos/" ]]; then
        rm -v "$HOME/bin_dotfiles/xinitrc_reset"
    fi
fi
# Remove old dotfiles and homeshick
if [ -d "$HOME/.homesick" ]; then
    rm -rf "$HOME/.homesick"
    echo "removed directory '$HOME/.homesick'"
fi
# Remove old fonts
if [ -d "$HOME/.fonts/DroidSans" ]; then
    if [[ "$(readlink -- $HOME/.fonts/DroidSans/DroidSans.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/DroidSans/DroidSans.ttf" ]; then
            rm -rf "$HOME/.fonts/DroidSans"
            echo "removed directory '$HOME/.fonts/DroidSans'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/FiraCode" ]; then
    if [[ "$(readlink -- $HOME/.fonts/FiraCode/FiraCode-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/FiraCode/FiraCode-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/FiraCode"
            echo "removed directory '$HOME/.fonts/FiraCode'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/Mononoki" ]; then
    if [[ "$(readlink -- $HOME/.fonts/Mononoki/mononoki-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/Mononoki/mononoki-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/Mononoki"
            echo "removed directory '$HOME/.fonts/Mononoki'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/OpenSans" ]; then
    if [[ "$(readlink -- $HOME/.fonts/OpenSans/OpenSans-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/OpenSans/OpenSans-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/OpenSans"
            echo "removed directory '$HOME/.fonts/OpenSans'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/Roboto" ]; then
    if [[ "$(readlink -- $HOME/.fonts/Roboto/Roboto-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/Roboto/Roboto-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/Roboto"
            echo "removed directory '$HOME/.fonts/Roboto'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/SourceCodePro" ]; then
    if [[ "$(readlink -- $HOME/.fonts/SourceCodePro/SourceCodePro-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/SourceCodePro/SourceCodePro-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/SourceCodePro"
            echo "removed directory '$HOME/.fonts/SourceCodePro'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/Ubuntu" ]; then
    if [[ "$(readlink -- $HOME/.fonts/Ubuntu/Ubuntu-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/Ubuntu/Ubuntu-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/Ubuntu"
            echo "removed directory '$HOME/.fonts/Ubuntu'"
        fi
    fi
fi
if [ -d "$HOME/.fonts/Vollkorn" ]; then
    if [[ "$(readlink -- $HOME/.fonts/Vollkorn/Vollkorn-Regular.ttf)" =~ ".homesick/repos/" ]]; then
        if [ ! -f "$HOME/.fonts/Vollkorn/Vollkorn-Regular.ttf" ]; then
            rm -rf "$HOME/.fonts/Vollkorn"
            echo "removed directory '$HOME/.fonts/Vollkorn'"
        fi
    fi
fi


echo "remove ZSH cache"
rm -fv "$HOME/.zcompdump" 2>/dev/null
rm -fv "$HOME/.zshrc.zwc" 2>/dev/null

echo "link new files"
python3 ./install.py

echo "install ZSH Spaceship prompt"
rm -rf "$HOME/bin/spaceship-prompt" 2>/dev/null
mkdir -p "$HOME/bin/spaceship-prompt"
tar --extract --preserve-permissions --file "$HOME/dotfiles/zsh-plugins/spaceship-prompt/${spaceship_prompt_version}.tar.zstd" -C "$HOME/bin/spaceship-prompt/" || {
    zstd -f -d "$HOME/dotfiles/zsh-plugins/spaceship-prompt/${spaceship_prompt_version}.tar.zstd" -o "/tmp/${spaceship_prompt_version}.tar"
    tar --extract --preserve-permissions --file "/tmp/${spaceship_prompt_version}.tar" -C "$HOME/bin/spaceship-prompt/"
}
mkdir -p "$HOME/bin/.zfunctions"
if [ ! -f "$HOME/bin/.zfunctions/prompt_spaceship_setup" ]; then
    ln -sf "$HOME/bin/spaceship-prompt/spaceship.zsh" "$HOME/bin/.zfunctions/prompt_spaceship_setup"
fi

echo "install tmux config"
unalias tmux 2>/dev/null
if [ -f $(which tmux 2>/dev/null) ]; then
    unlink "$HOME/.tmux.conf" 2>/dev/null
    ln -s "$HOME/dotfiles/home/.tmux.conf_v2" "$HOME/.tmux.conf"
    if [[ $(tmux -V) == *"1."* ]]; then
        unlink "$HOME/.tmux.conf" 2>/dev/null
        ln -s "$HOME/dotfiles/home/.tmux.conf_v1" "$HOME/.tmux.conf"
    fi
fi

echo "install tmux-mem-cpu-load"
cp -f "$HOME/dotfiles/zsh-plugins/tmux-mem-cpu-load/$tmux_mem_cpu_load_version" "$HOME/bin/tmux-mem-cpu-load"

# wget: Use UTF-8 as the default system encoding if it's supported
if [[ -f $(which wget 2>/dev/null) && -f $(which grep 2>/dev/null) ]]; then
    if wget --help | grep -q "local-encoding"; then
        if [ -f ~/.wgetrc ]; then
            echo "update wget config"
            sed -i 's/\#local_encoding/local_encoding/g' $HOME/.wgetrc
        fi
    fi
fi

if [ ! -f "$HOME/.tmux.conf_include" ]; then
    echo "create ~/.tmux.conf_include"
    touch "$HOME/.tmux.conf_include"
fi

if [ ! -f "$HOME/.zshrc.env" ]; then
echo "create default ~/.zshrc.env"
cat << EOF | tee $HOME/.zshrc.env >/dev/null
ENABLE_ZSH_AUTOSUGGEST=true
ENABLE_ZSH_SPACESHIP_PROMPT=true
ENABLE_ZSH_SYNTAX_HIGHLIGHTING=true

EOF
fi

if [ ! -f "$HOME/.gitconfig_include" ]; then
echo "create default ~/.gitconfig_include"
cat << EOF | tee $HOME/.gitconfig_include >/dev/null
# vim: sw=4 et

#[user]
#    name = CompileNix
#    email = compilenix@gmail.com
#    signingkey = C94DD853DD6493CCC47C8C853C713073CAC92AE0

# https://help.github.com/articles/signing-commits-using-gpg/
[commit]
    gpgsign = true

[credential]
    helper = store

EOF
fi

if [ ! -f "$HOME/.vimrc_include" ]; then
echo "create default ~/.vimrc_include"
cat << EOF | tee $HOME/.vimrc_include >/dev/null
" vim: sw=4 et

"colorscheme mustang

"set textwidth=79

" columns to highlight
"set cc=80

" text wrapping
"set wrap

" number of spaces to use for (auto)indent step
"set shiftwidth=4

" use spaces when <Tab> is inserted
"set expandtab

" number of spaces that <Tab> in file uses
"set tabstop=4

" prevent removing one whole intentation-step and removes only one char
"inoremap <backspace> <esc>xi

" prevent automatic window resize
"set noequalalways

EOF
fi

if [ ! -f "$HOME/.zshrc_include" ]; then
echo "create default ~/.zshrc_include"
cat << EOF | tee $HOME/.zshrc_include >/dev/null
# vim: sw=4 et

#alias vim='nvim'
#export EDITOR=nvim
export LANG="en_US.UTF-8"
export LC_MEASUREMENT="de_DE.UTF-8"
export LC_MONETARY="de_DE.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_PAPER="de_DE.UTF-8"
export LC_TIME="en_US.UTF-8"
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="$HOME/.history"

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export FT2_SUBPIXEL_HINTING=1

if [ -z "\$SSH_AUTH_SOCK" ] ; then
    eval \`ssh-agent -s\` >/dev/null
fi

EOF
fi

if [ ! -f "$HOME/.ssh/config" ]; then
echo "create default ~/.ssh/config"
mkdir -p $HOME/.ssh
cat << EOF | tee $HOME/.ssh/config >/dev/null
# vim: sw=4 et

ForwardAgent yes
VerifyHostKeyDNS yes
HashKnownHosts no
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,ssh-rsa
PubkeyAcceptedKeyTypes ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,ssh-rsa
ServerAliveInterval 60
Compression yes
ControlMaster auto
ControlPath ~/.ssh/ssh-%r@%h:%p.socket
ControlPersist 30d
UseRoaming no
ExitOnForwardFailure no
StrictHostKeyChecking accept-new # requires modern openssh
#ForwardX11 yes
#ForwardX11Trusted yes

EOF
chmod 0600 $HOME/.ssh/config
fi

if [ ! -f "$HOME/.gnupg/gpg-agent.env" ]; then
    echo "create ~/.gnupg/gpg-agent.env"
    mkdir -pv "$HOME/.gnupg"
    chmod 0700 "$HOME/.gnupg"
    touch "$HOME/.gnupg/gpg-agent.env"
fi

