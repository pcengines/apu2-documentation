#!/bin/bash

IPXE_PATH=/ipxe
APU2_PATH=/apu2-docs
CB_PATH=/coreboot
SBO_PATH=$CB_PATH/payloads/pcengines/sortbootorder
MEMTEST=/memtest86plus
CBFSTOOL=./build/cbfstool

#
# iPXE
#
if [ ! -d $IPXE_PATH ]; then
  echo "ERROR: $PXE_PATH doesn't exist"
else
  cd $IPXE_PATH/src
  make clean
fi

make bin/8086157b.rom EMBED=$APU2_PATH/ipxe/menu.ipxe

#
# coreboot
#
cd $CB_PATH

if [ ! -d $CB_PATH/util/crossgcc/xgcc ]; then
  make crossgcc-i386 CPUS=$(nproc)
fi

cp configs/pcengines.apu2.4.0.1.config .config
make CPUS=$(nproc)

#
# memtest86plus
#

if [ ! -d $MEMTEST ]; then
  echo "ERROR: $MEMTEST doesn't exist"
else
  cd $MEMTEST
  make clean
fi

make

#
# sortbootorder
#

if [ ! -d $SBO_PATH ]; then
  echo "ERROR: $SBO_PATH doesn't exist"
else
  cd $SBO_PATH
  make clean
fi

cd $CB_PATH/payloads/libpayload
make defconfig
make
make install
cd $SBO_PATH
make

cd $CB_PATH

$CBFSTOOL $CB_PATH/build/coreboot.rom remove -n genroms/pxe.rom
$CBFSTOOL $CB_PATH/build/coreboot.rom remove -n img/setup
$CBFSTOOL $CB_PATH/build/coreboot.rom add -f /ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
$CBFSTOOL $CB_PATH/build/coreboot.rom add-payload -f $CB_PATH/payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
$CBFSTOOL $CB_PATH/build/coreboot.rom remove -n img/memtest
$CBFSTOOL $CB_PATH/build/coreboot.rom add-payload -f /memtest86plus/memtest -n img/memtest - payload

$CBFSTOOL $CB_PATH/build/coreboot.rom print $CB_PATH/build/coreboot.rom
