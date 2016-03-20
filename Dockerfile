FROM ubuntu:14.04
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>


# Install Nginx.
RUN apt-get update
RUN apt-get -y install build-essential iasl git python m4 flex bison gdb doxygen ncurses-dev cmake make g++
