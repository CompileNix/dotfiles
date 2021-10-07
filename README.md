# Description

My personal configuration files. feel free to steal whatever you like.

# Requirements
- python 3.8+
- git
- zsh
- tee
- zstd
- [powerline-fonts](https://github.com/powerline/fonts/releases)

## Debian / Ubuntu
```sh
# How to get rid of purple background color in newt apps? -> https://askubuntu.com/q/750237
ln -sf /etc/newt/palette.original /etc/alternatives/newt-palette

apt update && apt install acl bind9utils brotli coreutils curl git gzip htop iftop iotop logrotate lsb-release mlocate ncdu neovim net-tools python python3 python3-pip rsync sqlite systemd-coredump tmux unzip vim vim-airline wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd
```

## Fedora
```sh
dnf install acl bind-utils coreutils curl findutils git htop iftop iotop iptables logrotate mlocate ncdu neovim NetworkManager-tui python python3 python3-pip redhat-lsb-core rsync sqlite tmux util-linux-user vim vim-airline wget which zsh zsh-autosuggestions zsh-syntax-highlighting zstd
```

## MacOS
```sh
# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install software & tools
brew install acl2 brotli coreutils curl git gzip htop iftop ncdu neovim net-tools python python3 rsync sqlite tmux unzip vim wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd

# Install python modules required to install dotfiles
pip3 install rich pyyaml neovim
```

# Install
__Keep always an old terminal open, in case of failures!__

```sh
wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/master/install.sh; chmod +x install.sh; ./install.sh; rm -f install.sh
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
- gnome-terminal
- mako
- gimp
- thunar (filemanager)

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
    - `dnf install libX11-devel libXaw-devel`
- dbus-launch
- ImageMagick (for screen lock image processing)
- dmenu
- rofi
- lxterminal
- gimp
- thunar (filemanager)

# Update
Use the zsh function `update-dotfiles`.

If you have a really old version, you may need to update it manually.

## Manual Update
Copy and paste into terminal, after that start a new (separat) terminal / session to verify everthing worked out fine.

__Keep always a additional terminal open, in case of any issues!__

```sh
rm -rf ~/dotfiles 2>/dev/null
wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/master/install.sh; chmod +x install.sh; ./install.sh; rm -f install.sh
exit
zsh
```

## Update Spaceship Prompt Plugin
```bash
cd ~/dotfiles
temp_dir="/tmp/$(uuidgen)"
mkdir -pv "$temp_dir"
cd "$temp_dir"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git --depth=1 git_repo
cd git_repo
commit_id=$(git rev-parse HEAD)
tar --create --file "../${commit_id}.tar.zstd" --preserve-permissions --zstd .
cp -v "${commit_id}.tar.zstd" ~/dotfiles/zsh-plugins/spaceship-prompt/
popd
popd
```

## Update tmux-mem-cpu-load Plugin
```bash
cd ~/dotfiles
temp_dir="/tmp/$(uuidgen)"
mkdir -pv "$temp_dir"
cd "$temp_dir"
git clone https://github.com/thewtex/tmux-mem-cpu-load.git --depth=1 git_repo
cd git_repo
commit_id=$(git rev-parse HEAD)
cmake .
make
cp -v "tmux-mem-cpu-load" "$HOME/dotfiles/zsh-plugins/tmux-mem-cpu-load/${commit_id}"
popd
popd
```

# Sway Desktop Notifications (Wayland)
Install:
- mako
- [notify-send.py](https://github.com/phuhl/notify-send.py) via `pip install notify-send.py --user`
- amixer

# i3 Desktop Notifications (X11)
Install:
- [deadd-notification-center](https://github.com/phuhl/linux_notification_center)
- [notify-send.py](https://github.com/phuhl/notify-send.py) via `pip install notify-send.py --user`
- amixer

# UI Settings
Using:
- `lxappearance`
- Default Font: Helvetica LT Pro 11

## Replace text cursor with regular mouse pointer
```sh
cd /usr/share/icons/Adwaita/cursors/
ln -sf left_ptr text
ln -sf left_ptr xterm
```

## GTK Themes
- [Azure](https://github.com/vinceliuice/Azure-theme)
- [Arc-Dark-OSX](https://github.com/Dr-Noob/Arc-Dark-OSX)

## Icon Themes
- Adwaita
- Breeze
  - breeze-gtk
  - breeze-cursor-theme
  - breeze-icon-theme

## Firefox Theme
- [Nord Polar Night](https://addons.mozilla.org/en-US/firefox/addon/nord-polar-night-theme/)
  - [TreeTabs Themes](home/.config/firefox-themes)

## Troubleshooting
### Create links to missing cursors
```sh
cd ~/.icons/theme/cursors/
ln -s right_ptr arrow
ln -s cross crosshair
ln -s right_ptr draft_large
ln -s right_ptr draft_small
ln -s cross plus
ln -s left_ptr top_left_arrow
ln -s cross tcross
ln -s hand hand1
ln -s hand hand2
ln -s left_side left_tee
ln -s left_ptr ul_angle
ln -s left_ptr ur_angle
```

# Windows
## Tools / Software
- [7-ZIP](https://www.7-zip.org/): archive file management
- [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer): more advanced Task Manager
- [TeraCopy](https://www.codesector.com/teracopy): better file copy & move
- [Visual Studio Code](https://code.visualstudio.com/download): text editor
- [NetLimiter](https://www.netlimiter.com/): alternative firewall (not based on Windows Firewall)

