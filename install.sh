#!/bin/bash

condition_for_install=1
if [[ \
    -f $(which git 2>/dev/null) && \
    -f $(which zsh 2>/dev/null) && \
    -f $(which python 2>/dev/null) \
    ]]; then

    condition_for_install=0
fi

if [[ ${condition_for_install} -eq 0 ]]; then
    cd $HOME
    mkdir -pv $HOME/bin
    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    echo "y" | $HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles
    mkdir -pv .vim/bundle
    ln -sv .homesick/repos/dotfiles/antigen .antigen
    cd .vim/bundle
    ln -sv ../../.homesick/repos/dotfiles/vim/vundle vundle
    popd
    chsh -s /bin/zsh
    vim +PluginInstall +qa
    popd
    exec zsh
else
    echo "one or more of the following hard dependencies are not installed: git, zsh, python"
fi

# vim: sw=4 et
