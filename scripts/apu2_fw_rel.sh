#!/bin/bash

echo $*

ssh-add && \
docker run --rm -it \
  -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  \
  -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
  -v ${PWD}:/release \
  pcengines/apu2 /bin/bash -c "/release/apu2/apu2-documentation/scripts/build_release_img.sh $*"
