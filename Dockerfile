FROM ubuntu:14.04
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>


RUN apt-get update && apt-get install -y \
    build-essential \
    iasl \
    git \
    python \
    m4 \
    flex \
    bison \
    gdb \
    doxygen \
    ncurses-dev \
    cmake \
    make \
    g++ \
    gcc-multilib \
    wget \
    liblzma-dev \
    zlib1g-dev \
    && \
    apt-get clean && \
    useradd -m builder && \
    mkdir -p /home/builder/ && \
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder


USER builder
WORKDIR /home/builder/
