# dotfiles

my personal configuration files. feel free to steal whatever you like.

## requirements
- python 3.3+
- git
- zsh
- vim
- sudo
- tee
- [powerline-fonts](https://github.com/powerline/fonts/releases)

### Debain
```bash
sudo apt install python3 python git zsh vim vim-airline tmux curl wget python3-pip
```

#### More packages
```bash
sudo apt install htop iftop iotop mutt bind9utils build-essential cmake rsync postfix
```

### Fedora
```bash
sudo dnf install python3 python git zsh vim vim-airline tmux curl wget redhat-lsb-core python3-pip
```
#### More packages
```bash
sudo dnf install htop iftop iotop mutt bind-utils make gcc-c++ gcc cmake rsync postfix
```

### CentOS 7
```bash
sudo yum install python3 python git zsh vim vim-airline tmux curl wget redhat-lsb-core make gcc-c++ gcc ncurses-devel python3-pip
cd /opt
wget https://sourceforge.net/projects/zsh/files/zsh/5.4.2/zsh-5.4.2.tar.xz/download
tar -xJf zsh-*
rm zsh-*.tar.xz
cd zsh-*
./configure
make && sudo make install
cd ..
rm -rf zsh-*
cd ~
echo "/usr/local/bin/zsh" >>/etc/shells
chsh -s /usr/local/bin/zsh
exec zsh
```

#### More packages
```bash
sudo yum install htop iftop iotop mutt bind-utils cmake rsync postfix
```

## X11 .xinitrc requirements
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
- i3

## install
__Keep always an old terminal open, in case of failures!__

```bash
curl https://raw.githubusercontent.com/compilenix/dotfiles/master/install.sh | bash
```

## Update
Copy and paste into terminal.

__Keep always an old terminal open, in case of failures!__

```bash
cd ~/.homesick/repos/dotfiles
git status
popd >/dev/null
echo "This will reset all changes you may made to files which are symlinks at your home directory, to check this your own: \"# cd ~/.homesick/repos/dotfiles && git status\"\nDo you want preced anyway?"
function ask_yn_y_callback {
    sudo rm /usr/local/bin/tmux-mem-cpu-load
    pushd ~/.homesick/repos
    rm -rf dotfiles
    git clone --recursive https://github.com/compilenix/dotfiles.git
    popd >/dev/null
    pushd ~
    rm -rf .antigen
    rm -rf .vim/bundle
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
