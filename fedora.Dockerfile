FROM fedora:34
ENV TZ="UTC"
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && dnf install -y acl bind-utils coreutils curl findutils git htop iftop iotop iptables mlocate ncdu neovim NetworkManager-tui python python3 python3-pip redhat-lsb-core rsync sqlite tmux util-linux-user vim vim-airline wget which zsh zsh-autosuggestions zsh-syntax-highlighting zstd && pip3 install --user rich pyyaml
WORKDIR /root
CMD [ "/bin/bash" ]

