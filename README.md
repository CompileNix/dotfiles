dotfiles
========

my personal configuration dot-files

feel free to steal whatever you like

homesick / homeshick
--------------------

assumes:
 - python 3.3 is default
 - pip is installed

```sh
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles-flat235
zsh
vim +PluginInstall +qall
```

or just:
```sh
curl https://github.com/compilenix/dotfiles-flat235/raw/master/install.sh | sh
```

