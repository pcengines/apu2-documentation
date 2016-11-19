#!/bin/bash

docker run --rm -it \
-v ${PWD}/apu2/apu2-documentation/scripts:/scripts \
-v ${PWD}/apu2/coreboot:/coreboot \
-v ${PWD}/apu2/memtest86plus:/memtest86plus \
-v ${PWD}/apu2/ipxe:/ipxe \
-v ${PWD}/apu2/sortbootorder:/coreboot/payloads/pcengines/sortbootorder \
pcengines/apu2 /bin/bash -c "/scripts/build_release_img.sh"
