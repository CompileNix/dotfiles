#!/bin/bash
# vim: sw=8 et

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
    echo "y" | $HOME/.homesick/repos/homeshick/bin/homeshick clone https://git.compilenix.org/CompileNix/dotfiles.git
    ln -sv .homesick/repos/dotfiles/antigen .antigen
    if [[ $EUID -eq 0 ]]; then
        chsh -s /bin/zsh
    else
        echo "you are not root, so you are not allowed to change your own shell to zsh"
        echo "retry with sudo..."
        sudo chsh -s /bin/zsh "$USERNAME"
    fi
    popd
    exec zsh
else
    echo "one or more of the following hard dependencies are not installed: git, zsh, python"
fi
