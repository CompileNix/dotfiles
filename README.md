# Description

My personal configuration files. feel free to steal whatever you like.

See also my [server-dotfiles](https://git.compilenix.org/CompileNix/server-dotfiles) repo.

## Requirements
- python 3.7+
- git
- zsh
- vim
- sudo
- tee
- [powerline-fonts](https://github.com/powerline/fonts/releases)

### Debian / Ubuntu
```sh
sudo apt install python3 python3-pip python git zsh vim vim-airline tmux curl wget net-tools htop ncdu iftop iotop mutt lsb-release rsync brotli gzip zip unzip bind9utils
```

#### More Packages
```sh
sudo apt install build-essential cmake postfix
```

### Fedora
```sh
sudo dnf install python3 python git zsh vim vim-airline tmux curl wget ncdu redhat-lsb-core python3-pip htop iftop iotop mutt bind-utils rsync iptables
```
#### More Packages
```sh
sudo dnf install make gcc-c++ gcc cmake sqlite postfix
```

### CentOS 7
```sh
sudo yum install python3 python git zsh vim vim-airline tmux curl wget redhat-lsb-core make gcc-c++ gcc ncurses-devel python3-pip ncdu htop iftop iotop mutt bind-utils rsync iptables
# because centos ships an ancient version of ZSH we have to build a recent version by our self
# see https://sourceforge.net/projects/zsh/files/zsh/
cd /opt
wget https://sourceforge.net/projects/zsh/files/zsh/5.8/zsh-5.8.tar.xz/download
tar -xJf download
rm -f download
cd zsh-*
./configure
make -j$(nproc) && sudo make install
cd ..
rm -rf zsh-*
cd ~
echo "/usr/local/bin/zsh" >>/etc/shells
chsh -s /usr/local/bin/zsh
exec zsh
```

#### More Packages
```sh
sudo yum install cmake postfix
```

## Sway Requirements
- sway
- waybar
- wl-clipboard
- slurp (for screenshots)
- wf-recorder (cli screen recorder, obs doesn't work)
- mako (notifications)
- swaylock
- ImageMagick (for screen lock image processing)
- swayidle (turn off & on displays)
- dmenu
- rofi
- lxterminal
- gimp

## X11 .xinitrc Requirements
- i3
- xrdb
- xinput
- xset
- setxkbmap
- xsetroot
- numlockx
- autocutsel
    - https://github.com/sigmike/autocutsel
    - `sudo dnf install libX11-devel libXaw-devel`
- dbus-launch
- ImageMagick (for screen lock image processing)
- dmenu
- rofi
- lxterminal
- gimp

## Install
__Keep always an old terminal open, in case of failures!__

```sh
curl https://git.compilenix.org/CompileNix/dotfiles/-/raw/master/install.sh | bash
```

## Update
Copy and paste into terminal.

__Keep always an old terminal open, in case of failures!__

```sh
cd ~/.homesick/repos/dotfiles
git status
popd >/dev/null
echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/.homesick/repos/dotfiles && git status\"\nDo you want preced anyway?"
function ask_yn_y_callback {
    if [[ $EUID -eq 0 ]]; then
        rm /usr/local/bin/tmux-mem-cpu-load
    fi
    pushd ~
    rm -rf .vim/bundle
    pushd ~/.homesick/repos
    rm -rf dotfiles
    git clone --recursive https://git.compilenix.org/CompileNix/dotfiles.git
    popd >/dev/null
    pushd ~
    rm -rf .antigen
    ln -sfv .homesick/repos/dotfiles/antigen .antigen
    popd >/dev/null
    antigen-cleanup
    git-reset ~/.homesick/repos/*
    homeshick pull
    homeshick link
    antigen update
    rm ~/.tmux.conf_configured

    exec zsh
}
function ask_yn_n_callback {
    echo -n ""
}
ask_yn
```

## Sway Desktop Notifications (Wayland)
Install:
- mako
- [notify-send.py](https://github.com/phuhl/notify-send.py) via `pip install notify-send.py --user`
- amixer

## i3 Desktop Notifications (X11)
Install:
- [deadd-notification-center](https://github.com/phuhl/linux_notification_center)
- [notify-send.py](https://github.com/phuhl/notify-send.py) via `pip install notify-send.py --user`
- amixer
