# dotfiles

my personal configuration files. feel free to steal whatever you like.

## requirements
- python 3.3+
- git
- zsh
- vim
- sudo
- [powerline-fonts](https://github.com/powerline/fonts/releases)

## install
__Keep always an old terminal open, in case of failures!__

```sh
curl https://raw.githubusercontent.com/compilenix/dotfiles/master/install.sh | bash
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
    sudo rm /usr/local/bin/tmux-mem-cpu-load
    pushd ~/.homesick/repos
    rm -rf dotfiles
    git clone --recursive https://github.com/compilenix/dotfiles.git
    popd >/dev/null
    pushd ~
    rm -rf .antigen
    rm -rf .vim/bundle/vundle
    ln -sfv .homesick/repos/dotfiles/antigen .antigen
    popd >/dev/null
    pushd ~/.vim/bundle
    ln -sfv ../../.homesick/repos/dotfiles/vim/vundle vundle
    popd >/dev/null
    antigen-cleanup
    git-reset ~/.homesick/repos/*
    git-reset ~/.vim/bundle/*
    homeshick pull
    homeshick link
    antigen update
    for i in ~/.vim/bundle/*
    do
        pushd "$i"
        git pull
        popd >/dev/null
    done
    vim +PluginInstall +qa
    rm ~/.tmux.conf_configured

    exec zsh
}
function ask_yn_n_callback {
    echo -n ""
}
ask_yn
```
