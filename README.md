# dotfiles

my personal configuration files. feel free to steal whatever you like.

## requirements
- python 3.3+
- git
- zsh
- vim
- sudo
- powerline-fonts

## install
__Keep always an old terminal open, in case of failures!__

```sh
curl https://raw.githubusercontent.com/compilenix/dotfiles/master/install.sh | bash
```

## Update
Copy and paste into terminal.

__Keep always an old terminal open, in case of failures!__

```sh
function fix-antigen_and_homesick_vim {
    sudo rm /usr/local/bin/tmux-mem-cpu-load
    # Migrate from 1.x antigen to 2.x antigen
    if [[ -d ~/.homesick/repos/dotfiles/home/.antigen ]]
    then
        cd ~/.homesick/repos
        rm -rf dotfiles
        git clone --recursive https://github.com/compilenix/dotfiles.git
        popd >/dev/null
        cd ~
        rm -rf .antigen
        rm -rf .vim/bundle/vundle
        ln -sv .homesick/repos/dotfiles/antigen .antigen
        popd >/dev/null
        cd ~/.vim/bundle
        ln -sv .homesick/repos/dotfiles/vim/vundle vundle
        popd >/dev/null
    fi
    antigen-cleanup
    git-reset ~/.homesick/repos/*
    git-reset ~/.vim/bundle/*
    homeshick pull
    homeshick link
    antigen update
    for i in ~/.vim/bundle/*
    do
        cd "$i"
        git pull
        popd >/dev/null
    done
    vim +PluginInstall +qa
    exec zsh
}

update-zshrc
```
