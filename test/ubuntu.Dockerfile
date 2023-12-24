FROM ubuntu:22.04
ENV TZ="UTC"
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
COPY ./docker.bash_history .bash_history
RUN ln -sf /etc/newt/palette.original /etc/alternatives/newt-palette \
    && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && apt update \
    && apt upgrade --yes
RUN apt install -y \
  bash \
  coreutils \
  curl \
  git \
  lsb-release \
  python3 \
  python3-yaml \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zstd
CMD [ "/bin/bash" ]

