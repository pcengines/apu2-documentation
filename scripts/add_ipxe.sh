IPXE_PATH=payloads/external/ipxe
CBFSTOOL=./build/cbfstool

if [ ! -d $IPXE_PATH ]; then
  git clone https://github.com/pcengines/ipxe $IPXE_PATH
  wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/general.h -O $IPXE_PATH/src/config/local/general.h
  wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/shell.ipxe -O $IPXE_PATH/src/shell.ipxe
  cd $IPXE_PATH/src
else
  cd $IPXE_PATH/src
  make clean
fi

make bin/8086157b.rom EMBED=./shell.ipxe
cd ../../../../

if [ -f  $CBFSTOOL ]; then
  $CBFSTOOL ./build/coreboot.rom add -f $IPXE_PATH/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
  if [ $? != 0 ]; then
    exit
  fi
  $CBFSTOOL ./build/coreboot.rom print
else
  echo "ERROR: $CBFSTOOL doesn't exist please build coreboot first"
fi
