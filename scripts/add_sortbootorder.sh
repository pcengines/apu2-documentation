SBO_PATH=payloads/pcengines/sortbootorder
CBFSTOOL=./build/cbfstool

if [ ! -d $SBO_PATH ]; then
  git clone https://github.com/pcengines/sortbootorder $SBO_PATH
  cd $SBO_PATH
else
  cd $SBO_PATH
  make clean
fi

if [ -f ../../libpayload/.xcompile ]; then
  rm -f ../../libpayload/.xcompile
  rm -f ../../libpayload/.config
fi

cd ../../libpayload
make defconfig
make
make install
cd ../../$SBO_PATH
make
cd ../../../

if [ -f  $CBFSTOOL ]; then
  $CBFSTOOL ./build/coreboot.rom add-payload -f $SBO_PATH/sortbootorder.elf -n img/setup -t payload
  if [ $? != 0 ]; then
    exit
  fi
  $CBFSTOOL ./build/coreboot.rom print
else
  echo "ERROR: $CBFSTOOL doesn't exist please build coreboot first"
fi
