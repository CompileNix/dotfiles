dotfiles
========

my personal configuration dot-files

feel free to steal whatever you like

homesick / homeshick
--------------------

configs for:
 - zsh
 - vim
 - tmux
 - git (1.7.10+)
 - htop
 - Xresources (xterm)
 - irssi

assumes installed software:
 - python 3.3+
 - git
 - zsh
 - vim
 - sudo (optional)
 - htop (optional)

```sh
curl https://github.com/compilenix/dotfiles/raw/master/install.sh | bash
```

```sh
mkdir -pv $HOME/bin
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
echo "y" | $HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles

chsh -s /bin/zsh
vim +PluginInstall +qa
exec zsh
```

