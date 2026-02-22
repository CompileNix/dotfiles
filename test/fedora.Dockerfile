FROM fedora:43
ENV TZ="UTC"
WORKDIR /root
COPY ./docker.bash_history .bash_history
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN dnf update --refresh -y
RUN dnf install -y \
  coreutils \
  curl \
  git \
  python3 \
  python3-pyyaml \
  redhat-lsb \
  which \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zstd NetworkManager-tui \
  acl \
  bind9-next-utils \
  dua-cli \
  findutils \
  htop \
  iftop \
  iotop \
  iptables \
  jq \
  logrotate \
  lsd \
  ncdu \
  neovim \
  plocate \
  python3-rich \
  rsync \
  sqlite \
  sudo \
  tmux \
  util-linux-user \
  wget
CMD [ "/bin/bash" ]

