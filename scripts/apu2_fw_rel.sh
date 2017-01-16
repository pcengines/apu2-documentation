#!/bin/bash

echo $*

if [ "$1" == "build-ml" ] || [ "$1" == "flash-ml" ] || [ "$1" == "custom-ml" ]; then
  if [ ! -d ${PWD}/apu2/coreboot ];then
    git clone https://review.coreboot.org/coreboot.git ${PWD}/apu2/coreboot
    cd ${PWD}/apu2/coreboot
    git submodule update --init --checkout
    git remote add pcengines http://github.com/pcengines/coreboot.git
    git fetch pcengines
    git checkout -b coreboot-4.5.x pcengines/coreboot-4.5.x
    cd ../..
  fi
  docker run --rm -it \
  -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  \
  -v ${PWD}:/release \
  pcengines/apu2 /bin/bash -c "/release/apu2/apu2-documentation/scripts/build_release_img.sh $*"
else
  if [ ! -d ${PWD}/apu2/coreboot ];then
    git clone git@github.com:pcengines/coreboot.git ${PWD}/apu2/coreboot
  fi
  docker run --rm -it \
  -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  \
  -v ${PWD}:/release \
  pcengines/apu2 /bin/bash -c "/release/apu2/apu2-documentation/scripts/build_release_img.sh $*"
fi
