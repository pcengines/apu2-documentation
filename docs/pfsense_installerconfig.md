Unattended installation PFSense
===============================

This document describes the process of preparing the automatic installer pFsense
on a USB stick. The whole procedure was tested on Ubuntu with the kernel
5.15.0-58-generic, the download and installation procedure of the kernel is also
described below.

Kernel installation
-------------------

1. Download the required packages by running the following command:

   ```bash
   sudo apt install linux-headers-5.15.0-58-generic linux-source-5.15.0
   ```

1. Go to the indicated location and unzip the file named
   `linux-source-5.15.0.tar.bz2` as shown below:

   ```bash
   cd /usr/src/linux-source-5.15.0/
   sudo tar xjf linux-source-5.15.0.tar.bz2
   ```

1. After successfully unpacking, copy the files required for kernel installation
   by running the following commands:

   ```bash
   sudo cp ../linux-headers-5.15.0-58-generic/Module.symvers linux-source-5.15.0/
   cd linux-source-5.15.0/
   sudo cp /boot/config-5.15.0-58-generic .config
   ```

1. Finally build and install the kernel by running the following command:

   ```bash
   sudo make olddefconfig
   ```

UFS module compilation
-----------------------

1. Edit the `.config` file by setting the value of `UFS_FS_WRITE` to `y`.
1. Prepare resources to compile the UFS module by running the following
   commands:

   ```bash
   sudo make prepare
   sudo make modules_prepare
   sudo make M=scripts/mod -j8
   sudo make M=fs/ufs modules -j8
   ```

1. Copy the previously prepared files by running the following commands:

   ```bash
   sudo cp /lib/modules/5.15.0-58-generic/kernel/fs/ufs/ufs.ko   /lib/modules/5.15.0-58-generic/kernel/fs/ufs/ufs_backup.ko 
   sudo cp fs/ufs/ufs.ko /lib/modules/5.15.0-58-generic/kernel/fs/ufs/ufs.ko
   ```

1. Load the UFS module by running the following commands:

   ```bash
   sudo depmod
   sudo modprobe ufs
   ```

1. Mount the `FreeBSD_install` partition to properly configure the installer by
   running the following command(`X` depending on how many drives are connected
   to your computer):

   ```bash
   sudo mount -t ufs -o ufstype=ufs2 /dev/sdX5 /mnt
   ```

rc.local
--------

After booting from the USB stick installer `rc.local` is executed. Changes have
to be applied to this file to eliminate interactive dialog options. After
mounting parition edit the `rc.local` file located in the `etc` folder by using
`nano` or `vim` editors.

1. Add environment variable defining terminal type:

    ```bash
    #!/bin/sh
    # $FreeBSD$
    export TERM=vt100
    ```

1. Comment out console type input:

    ```bash
    # Serial or other console
    echo
    echo "Welcome to pfSense!"
    echo
    echo "Please choose the appropriate terminal type for you system."
    echo "Common console types are:"
    echo "   ansi     Standard ANSI terminal"
    echo "   vt100    VT100 or compatible terminal"
    echo "   xterm    xterm terminal emulator (or compatible)"
    echo "   cons25w  cons25w terminal"
    echo
    echo -n "Console type [vt100]: "
    #read TERM
    #TERM=${TERM:-vt100}
    ```

1. Add reboot command after installerconfig finishes:

    ```bash
    if [ -f /etc/installerconfig ]; then
            bsdinstall script /etc/installerconfig
            reboot
    fi
    ```

installerconfig
---------------

The `installerconfig` script is called if exists. If it doesn't exist manual
installation is performed.

```bash
#!/bin/bash
# Unattended installation part
...
# After installation you can launch new system shell and change configuration
...
# When work is exit
exit
```

This file must be located in the `etc` directory. The `etc/installerconfig`
script will install pfSense and replace all configuration files that we want to
change before the first boot.

An example file is located
[here](https://github.com/pcengines/apu2-documentation/blob/master/scripts/installerconfig).

Problems
--------

During extracting distribution files phase installation sometimes hangs up. I
waited for 15 minutes and nothing happened. My solution was to reset the
platform.
