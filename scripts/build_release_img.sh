#!/bin/bash

IPXE_PATH=/ipxe
APU2_PATH=/apu2-docs
CB_PATH=/coreboot
SBO_PATH=$CB_PATH/payloads/pcengines/sortbootorder
MEMTEST=/memtest86plus
CBFSTOOL=./build/cbfstool

build_ipxe () {
  if [ ! -d $IPXE_PATH ]; then
    echo "ERROR: $PXE_PATH doesn't exist"
  else
    cd $IPXE_PATH/src
    make clean
  fi

  make bin/8086157b.rom EMBED=$APU2_PATH/ipxe/menu.ipxe
}

build_coreboot () {
  cd $CB_PATH

  if [ ! -d $CB_PATH/util/crossgcc/xgcc ]; then
    make crossgcc-i386 CPUS=$(nproc)
  fi
  make CPUS=$(nproc)
}

build_memtest86plus () {
  if [ ! -d $MEMTEST ]; then
    echo "ERROR: $MEMTEST doesn't exist"
  else
    cd $MEMTEST
    make clean
  fi

  make
}

build_sortbootorder () {
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
}

create_image () {
  cd $CB_PATH
  $CBFSTOOL $CB_PATH/build/coreboot.rom remove -n genroms/pxe.rom
  $CBFSTOOL $CB_PATH/build/coreboot.rom remove -n img/setup
  $CBFSTOOL $CB_PATH/build/coreboot.rom add -f /ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
  $CBFSTOOL $CB_PATH/build/coreboot.rom add-payload -f $CB_PATH/payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
  $CBFSTOOL $CB_PATH/build/coreboot.rom remove -n img/memtest
  $CBFSTOOL $CB_PATH/build/coreboot.rom add-payload -f /memtest86plus/memtest -n img/memtest - payload
  $CBFSTOOL $CB_PATH/build/coreboot.rom print $CB_PATH/build/coreboot.rom
}

if [ "$1" == "flash" ] || [ "$1" == "flash-ml" ]; then
  APU2_LOGIN=$2
  if [ "$1" == "flash" ];then  
    ssh $APU2_LOGIN remountrw
  fi
  if [ ! -f $CB_PATH/build/coreboot.rom ]; then
      echo "ERROR: $CB_PATH/build/coreboot.rom doesn't exist. Please build coreboot first"
      exit
  fi
  scp $CB_PATH/build/coreboot.rom $APU2_LOGIN:/tmp
  ssh $APU2_LOGIN "flashrom -w /tmp/coreboot.rom -p internal && reboot"
elif [ "$1" == "build" ] || [ "$1" == "build-ml" ]; then
  cd $CB_PATH
  if [ "$1" == "build" ];then
    cp configs/pcengines.apu2.4.0.1.config .config
  fi

  if [ "$2" == "distclean" ]; then
    make distclean
    make menuconfig
  elif [ "$2" == "menuconfig" ]; then
    make menuconfig
  elif [ "$2" == "cfgclean" ]; then
    make clean
    rm -rf .config .config.old
    make menuconfig
  elif [ "$2" == "custom" ]; then
    make $3
  fi

  build_coreboot

  if [ "$1" == "build" ];then
    build_ipxe
    build_memtest86plus
    build_sortbootorder
    create_image
  fi
elif [ "$1" == "build-coreboot" ]; then
  build_coreboot
  create_image
elif [ "$1" == "custom-ml" ]; then
  cd $CB_PATH
  make $2
else
  echo "ERROR: unknown command $1"
fi

