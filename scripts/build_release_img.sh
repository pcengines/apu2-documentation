#!/bin/bash

RELEASE_DIR=${RELEASE_DIR:-/release}
ROOT_DIR=$RELEASE_DIR/apu2
APU2_PATH=$ROOT_DIR/apu2-documentation
MEMTEST=$ROOT_DIR/memtest86plus
CB_PATH=$ROOT_DIR/coreboot
CBFSTOOL=./build/cbfstool

build_coreboot () {
  if [ ! -d $CB_PATH ]; then
    echo "ERROR: $CB_PATH doesn't exist"
    return
  fi

  cd $CB_PATH

  if [ ! -d $CB_PATH/util/crossgcc/xgcc ]; then
    make crossgcc-i386 CPUS=$(nproc)
  fi
  make CPUS=$(nproc)
}

build_memtest86plus () {
  if [ ! -d $MEMTEST ]; then
    echo "ERROR: $MEMTEST doesn't exist"
    return
  else
    cd $MEMTEST
    make clean
  fi

  make
}

create_image () {
  cd $CB_PATH
  $CBFSTOOL $CB_PATH/build/coreboot.rom remove -n img/memtest
  $CBFSTOOL $CB_PATH/build/coreboot.rom add-payload -f $ROOT_DIR/memtest86plus/memtest -n img/memtest - payload
  $CBFSTOOL $CB_PATH/build/coreboot.rom print $CB_PATH/build/coreboot.rom
}

pack_release () {
  cd $CB_PATH
  VERSION=`git describe --tags`
  TARGET=`cat .config | grep CONFIG_MAINBOARD_PART_NUMBER | sed -e 's/.*="//' -e 's/.$//'`
  OUT_FILE_NAME="${TARGET}_${VERSION}.rom"

  cp build/coreboot.rom "${RELEASE_DIR}/${OUT_FILE_NAME}" && \
  cd $RELEASE_DIR && \
  md5sum "${OUT_FILE_NAME}" > "${OUT_FILE_NAME}.md5" && \
  tar czf "${OUT_FILE_NAME}.tar.gz" "${OUT_FILE_NAME}" "${OUT_FILE_NAME}.md5"
}


if [ "$1" == "flash" ] || [ "$1" == "flash-force" ]; then
  APU2_LOGIN=$2
  if [ ! -f $CB_PATH/build/coreboot.rom ]; then
      echo "ERROR: $CB_PATH/build/coreboot.rom doesn't exist. Please build coreboot first"
      exit
  fi
  scp $CB_PATH/build/coreboot.rom $APU2_LOGIN:/tmp

  if [ "$1" == "flash-force" ]; then
    ssh $APU2_LOGIN "flashrom -w /tmp/coreboot.rom -p internal:boardmismatch=force && reboot"
  else
    ssh $APU2_LOGIN "flashrom -w /tmp/coreboot.rom -p internal && reboot"
  fi

elif [ "$1" == "build" ] || [ "$1" == "build-ml" ]; then
  cd $CB_PATH

  if [ "$2" == "distclean" ]; then
    make distclean
    exit
  elif [ "$2" == "menuconfig" ]; then
    make menuconfig
    exit
  elif [ "$2" == "cfgclean" ]; then
    make clean
    rm -rf .config .config.old
    exit
  elif [ "$2" == "custom" ]; then
    make $3
    exit
  fi

  if [ ! -f .config ]; then
      make menuconfig
  fi

  build_coreboot

  if [ "$1" == "build" ];then
    build_memtest86plus
    create_image
  fi
  pack_release
elif [ "$1" == "build-coreboot" ]; then
  build_coreboot
  create_image
else
  echo "ERROR: unknown command $1"
fi

