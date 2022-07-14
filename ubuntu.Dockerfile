FROM ubuntu:22.04
ENV TZ="UTC"
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -sf /etc/newt/palette.original /etc/alternatives/newt-palette && ln -sf /usr/share/zoneinfo/UTC /etc/localtime && apt update
RUN apt install -y acl bind9utils brotli coreutils curl git gzip htop iftop iotop logrotate lsb-release mlocate ncdu neovim net-tools python3 rsync sudo sqlite systemd-coredump tmux unzip vim vim-airline wget zip zsh zsh-autosuggestions zsh-syntax-highlighting zstd python3-yaml
WORKDIR /root
COPY ./docker.bash_history .bash_history
CMD [ "/bin/bash" ]

