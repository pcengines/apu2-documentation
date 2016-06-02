#!/bin/bash
cd /coreboot
# ./build/cbfstool ./build/coreboot.rom remove -n genroms/pxe.rom
./build/cbfstool ./build/coreboot.rom add -f /ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
./build/cbfstool ./build/coreboot.rom remove -n img/setup
./build/cbfstool ./build/coreboot.rom add-payload -f payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
./build/cbfstool ./build/coreboot.rom remove -n img/memtest
./build/cbfstool ./build/coreboot.rom add-payload -f /memtest86plus/memtest -n img/memtest - payload
