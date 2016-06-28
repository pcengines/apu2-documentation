Flashing current voyage linux on SD card.
-----------------------------------------

The problem with installing voyage on SD card is that the script `voyage.update`
accepts only integers as partition numbers, while partition numbers for SD card
are `p1`, `p2` etc. (i.e `/dev/mmcblk0p1`). The workaround is to use SD card USB
adapter. Thanks to this, card is seen as `/dev/sdb`, partitions: `/dev/sdb1`
etc.

1. Prepare current voyage linux live USB.
2. Boot from live USB. If connected through serial port: highlight `voyage
   linux` in boot menu, press `TAB`, remove `quiet` and add instead:

    ```
    console=ttyS0,115200n8
    ```

3. After successful boot, connect to device using `ssh`.

    ```
    ssh root@<dev_ip_addr>
    ```

4. Navigate to root directory and run installing script:

    ```
    ./usr/local/sbin/voyage.update
    ```

    Follow those steps:

    * Create new Voyage Linux disk
    * Set Voyage Linux directory to `/`
    * Select target profile: 9 (APU2)
    * Select target disk: `/dev/sdb`
    * Partition for the Voyage system: 1
    * Leave mounting point as default (`/mnt/cf`). Create it if doesn't exist.
    * Select `grub` as Bootstrap Loader
    * Partition for Bootstrap Loader: 1
    * Terminal type: 1 - `serial terminal`
    * Speed: default - 115200
    * Select: `Partition flash media and create file system`
    * Proceed with `copy distrubution to target`
    * Check if `configuration details` are correct and continue (y)
    * Exit (8) after successful installation

5. Check if system is booting from SD card properly. It worked fine when using
   SanDisk Ultra 8GB. However, on Samsung Evo 16 GB boot process failed and it
   was required to install `grub` manually using `grub-install`.

6. It is advised to fill an empty card space with zeroes. It will cause the
   compression process run faster. Before shutting down platform execute
   following command. Note that this process may take up to one hour.

    ```
    dd if=/dev/zero of=tmp && rm tmp
    ```

7. Saving image for further reuse:

    ```
    sudo dd if=/dev/mmcblk0 of=current_voyage_linux_28062016.img bs=16M
    ```
