#!/bin/bash

IPXE_PATH=/ipxe
APU2_PATH=/apu2-docs
CB_PATH=/coreboot
CBFSTOOL=./build/cbfstool

if [ ! -d $IPXE_PATH ]; then
  echo "ERROR: $PXE_PATH doesn't exist"
else
  cd $IPXE_PATH/src
  make clean
fi

make bin/8086157b.rom EMBED=$APU2_PATH/ipxe/menu.ipxe

cd $CB_PATH
make crossgcc-i386 CPUS=8
cp configs/pcengines.apu2.4.0.1.config .config
make CPUS=8

if [ -f  $CBFSTOOL ]; then
  $CBFSTOOL ./build/coreboot.rom add -f $IPXE_PATH/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
  if [ $? != 0 ]; then
    exit
  fi
  $CBFSTOOL ./build/coreboot.rom print
else
  echo "ERROR: $CBFSTOOL doesn't exist please build coreboot first"
fi
