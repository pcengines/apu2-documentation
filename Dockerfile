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
    wget
