FROM fedora:35
ENV TZ="UTC"
RUN dnf update --refresh -y
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && dnf install -y acl bind-utils coreutils curl findutils git htop iftop iotop iptables logrotate mlocate ncdu neovim NetworkManager-tui python3 redhat-lsb-core rsync sudo sqlite tmux util-linux-user vim vim-airline wget which zsh zsh-autosuggestions zsh-syntax-highlighting zstd python3-pyyaml python3-rich
WORKDIR /root
COPY ./docker.bash_history .bash_history
CMD [ "/bin/bash" ]

