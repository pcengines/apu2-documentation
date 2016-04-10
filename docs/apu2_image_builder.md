Release Notes
-------------

* _v0.1_
    * minimal set of libraries required to build and flash `coreboot.rom`
    * crossgcc - build based on [apu2b-20160304](https://github.com/pcengines/coreboot/tree/6f1e98ae92a9f8e98c32a0e96728d880d335aec7) release
    * flashrom - v0.9.9-r1954 compiled from source
    * `.xcompile*` - scripts for setting up toolchain

Image builder from scratch procedure
------------------------------------

APU2 image builder base on [Voyage Linux 0.10.0](http://voyage.kos.li/download/voyage/amd64/voyage-0.10.0_amd64.tar.xz).

Roughly procedure to build that image looks like that.

1. Create USB stick using [apu-tinycore-usb-installer.exe](http://pcengines.ch/file/apu-tinycore-usb-installer.exe)
2. Put Voyage Linux 0.10.0
3. Follow procedure from [here](http://pcengines.ch/howto.htm#VoyageLinux) to install Voyage Linux
4. Boot Voyage Linux
5. Clone coreboot repository, branch `apu2b-20160304`
6. Compile toolchain `make crossgcc-i386`
7. Save compilation result `util/crossgcc/xgcc` on external storage
8. Compile flashrom and save build results
9. Create new/clean Voyage Linux image (can be clone from point 4)
10. Copy toolchain saved in point 7
11. Copy flashrom saved in point 8
12. Create `.xcompile` file that point to `xgcc` and place it in image, for example:

    ```
    #using default coreboot cross
    # platform agnostic and host tools
    IASL:=/xgcc/bin/iasl
    HOSTCC:=gcc

    # x86 TARCH_SEARCH=  /xgcc/bin/i386-elf- i386-elf- i386-linux-gnu- i386- /xgcc/bin/x86_64-elf- x86_64-elf- x86_64-linux-gnu- x86_64-
    # elf32-i386 toolchain (/xgcc/bin/i386-elf-gcc)
    ARCH_SUPPORTED+=x86_32
    SUBARCH_SUPPORTED+=x86_32
    CC_x86_32:=/xgcc/bin/i386-elf-gcc
    CFLAGS_x86_32:= -Wno-unused-but-set-variable  -fuse-ld=bfd -fno-stack-protector -Wl,--build-id=none -Wa,--divide  -march=i686
    CPP_x86_32:=/xgcc/bin/i386-elf-cpp
    AS_x86_32:=/xgcc/bin/i386-elf-as 
    LD_x86_32:=/xgcc/bin/i386-elf-ld.bfd 
    NM_x86_32:=/xgcc/bin/i386-elf-nm
    OBJCOPY_x86_32:=/xgcc/bin/i386-elf-objcopy
    OBJDUMP_x86_32:=/xgcc/bin/i386-elf-objdump
    READELF_x86_32:=/xgcc/bin/i386-elf-readelf
    STRIP_x86_32:=/xgcc/bin/i386-elf-strip
    AR_x86_32:=/xgcc/bin/i386-elf-ar

    # arm TARCH_SEARCH=  /xgcc/bin/armv7a-eabi- armv7a-eabi- armv7a-linux-gnu- armv7a- /xgcc/bin/armv7-a-eabi- armv7-a-eabi- armv7-a-linux-gnu- armv7-a-
    # arm64 TARCH_SEARCH=  /xgcc/bin/aarch64-elf- aarch64-elf- aarch64-linux-gnu- aarch64-
    # riscv TARCH_SEARCH=  /xgcc/bin/riscv-elf- riscv-elf- riscv-linux-gnu- riscv-
    ```
13. Create `.xcompile-libpayload` file that point to `xgcc` and place it in image, for example:

    ```
    # elf32-i386 toolchain (gcc)
    CC_i386:=/xgcc/bin/i386-elf-gcc -m32 -Wl,-b,elf32-i386 -Wl,-melf_i386 -Wno-unused-but-set-variable  -fuse-ld=bfd -Wa,--divide -fno-stack-protector -Wl,--build-id=none
    AS_i386:=/xgcc/bin/i386-elf-as --32
    LD_i386:=/xgcc/bin/i386-elf-ld -b elf32-i386 -melf_i386
    NM_i386:=/xgcc/bin/i386-elf-nm
    OBJCOPY_i386:=/xgcc/bin/i386-elf-objcopy
    OBJDUMP_i386:=/xgcc/bin/i386-elf-objdump
    READELF_i386:=/xgcc/bin/i386-elf-readelf
    STRIP_i386:=/xgcc/bin/i386-elf-strip
    AR_i386:=/xgcc/bin/i386-elf-ar
    
    IASL:=/xgcc/bin/iasl
    
    # native toolchain
    HOSTCC:=/xgcc/bin/i386-elf-gcc
    ```

14. Boot newly created Voyage Linux
15. Install minimal set of packages

   ```
   apt-get update
   apt-get install gcc wget unzip make ca-certificates python libc-dev git liblzma-dev
   ```

16. Power down and save image for further reuse
