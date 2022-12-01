FROM fedora:37
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
  redhat-lsb-core \
  which \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zstd
CMD [ "/bin/bash" ]

