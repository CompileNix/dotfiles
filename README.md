# Description

My personal configuration files. feel free to steal whatever you like.

# Install
__Keep always an existing terminal open, in case of failures!__

## Minimum Requirements
- git
- python 3.8+
- tar
- tee
- zsh
- zstd

## Recommended
- [powerline-fonts](https://github.com/powerline/fonts/releases)

## Debian / Ubuntu
```sh
# How to get rid of purple background color in newt apps? -> https://askubuntu.com/q/750237
ln -sf /etc/newt/palette.original /etc/alternatives/newt-palette

apt update && apt install acl bind9utils brotli coreutils curl git gzip htop iftop iotop logrotate lsb-release mlocate ncdu neovim net-tools python3 rsync sudo sqlite systemd-coredump tmux unzip vim vim-airline wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd python3-yaml

wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/main/install.sh && chmod +x install.sh && ./install.sh && rm -f install.sh
```

## Fedora
```sh
dnf install acl bind-utils coreutils curl findutils git htop iftop iotop iptables logrotate plocate ncdu neovim NetworkManager-tui python3 redhat-lsb-core rsync sudo sqlite tmux util-linux-user vim vim-airline wget which zsh zsh-autosuggestions zsh-syntax-highlighting zstd python3-pyyaml python3-rich

wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/main/install.sh && chmod +x install.sh && ./install.sh && rm -f install.sh
```

## MacOS
```sh
# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install software & tools
brew install acl2 brotli coreutils curl git gzip htop iftop ncdu neovim net-tools python3 rsync sqlite tmux unzip vim wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd

# Install python modules required to install dotfiles
pip3 install rich pyyaml neovim

wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/main/install.sh && chmod +x install.sh && ./install.sh && rm -f install.sh
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
wget https://git.compilenix.org/CompileNix/dotfiles/-/raw/main/install.sh; chmod +x install.sh; ./install.sh; rm -f install.sh
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
echo "commit id: $commit_id"
rm -rf .git tests .github docs
tar --create --file "../${commit_id}.tar.zstd" --preserve-permissions --zstd .
cp -v "../${commit_id}.tar.zstd" ~/dotfiles/zsh-plugins/spaceship-prompt/
popd >/dev/null
popd >/dev/null
rm -rf "$temp_dir"
```

# Test / Build / Dev
- Comment out "git clone" in install.sh
- Comment out "git reset --hard" in home/.zshrc
- Comment out "git pull" in home/.zshrc

```bash
docker build -t local/dotfiles:ubuntu -f ubuntu.Dockerfile .
docker run -it --rm -v $(pwd)/:/root/dotfiles:z local/dotfiles:ubuntu
# Run bash ./dotfiles/install.sh
# Run zsh

docker build -t local/dotfiles:fedora -f fedora.Dockerfile .
docker run -it --rm -v $(pwd)/:/root/dotfiles:z local/dotfiles:fedora
# Run bash ./dotfiles/install.sh
# Run zsh
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

# GNOME Alt+Tab behavior
The default is to have `Alt-Tab` switch you between applications in the current workspace. One can use `Alt-backtick` (or whatever key you have above Tab) to switch between windows in the current application.

I prefer a Windows-like setup, where `Alt-Tab` switches between windows in the current workspace, regardless of the application to which they belong.

```sh
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab', '<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward  "['<Alt><Shift>Tab', '<Super><Shift>Tab']"
```

## Changing windows across all workspaces
If you'd like to switch between windows in all workspaces, rather than in the current workspace, find the `org.gnome.shell.window-switcher current-workspace-only` GSettings key and change it. You can do this in `dconf-editor`, or on the command line with:
```sh
gsettings set org.gnome.shell.window-switcher current-workspace-only true
```

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

