#!/bin/bash

echo $*

if [ "$1" == "build-mainline" ]; then
  docker run --rm -it \
  -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  \
  -v ${PWD}/../apu2-documentation:/apu2-docs \
  -v ${PWD}/apu2/coreboot:/coreboot \
  -v ${PWD}/apu2/sortbootorder:/coreboot/payloads/pcengines/sortbootorder \
  pcengines/apu2 /bin/bash -c "/apu2-docs/scripts/build_release_img.sh $*"
else
  docker run --rm -it \
  -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  \
  -v ${PWD}/../apu2-documentation:/apu2-docs \
  -v ${PWD}/apu2/coreboot:/coreboot \
  -v ${PWD}/apu2/memtest86plus:/memtest86plus \
  -v ${PWD}/apu2/ipxe:/ipxe \
  -v ${PWD}/apu2/sortbootorder:/coreboot/payloads/pcengines/sortbootorder \
  pcengines/apu2 /bin/bash -c "/apu2-docs/scripts/build_release_img.sh $*"
fi
