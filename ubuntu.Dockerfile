FROM ubuntu:20.04
ENV TZ="UTC"
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -sf /etc/newt/palette.original /etc/alternatives/newt-palette && ln -sf /usr/share/zoneinfo/UTC /etc/localtime && apt update && apt install -y acl bind9utils brotli coreutils curl git gzip htop iftop iotop lsb-release mlocate ncdu neovim net-tools python python3 python3-pip rsync sqlite tmux unzip vim vim-airline wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd && pip3 install --user rich pyyaml
WORKDIR /root
CMD [ "/bin/bash" ]

