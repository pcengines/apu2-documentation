Test item: mPCIe -> SATA converter `ASM1061`
hdd: Seagate Laptop SSHD 1000GB 8GB NAND flash

1. mPCIe1 without resistor

    > Note that CLKREQ has been already turned off for mPCIe1 when these test were
    > proceeded.

    * Cold boot: it takes 60-75 sec after power-on until boot menu appears. There
      is no HDD entry in boot menu.

      ```
      phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff58000 (detail=0xdff59b40)
      /dff58000\ Start thread
      |dff58000| AHCI/0: probing
      |dff58000| AHCI/0: link up
      |dff58000| AHCI/0: send cmd ...
      |dff58000| WARNING - Timeout at ahci_command:154!
      |dff58000| AHCI/0: send cmd ...
      |dff58000| WARNING - Timeout at ahci_command:154!
      |dff58000| phys_free dff59c00 (detail=0xdff59bd0)
      |dff58000| phys_free dff59a00 (detail=0xdff59ba0)
      |dff58000| phys_free dff59900 (detail=0xdff59b70)
      |dff58000| phys_free dff61050 (detail=0xdff61020)
      \dff58000/ End thread
      phys_free dff58000 (detail=0xdff59b40)
      ```

    * After OS boot: HDD is visible and usable under Debian

    * After reboot: boot menu appears as quickly as usual. HDD entry appears in
      boot menu:

      ```
      1. ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes)
      2. AHCI/0: ST1000LM014-SSHD-8GB ATA-9 Hard-Disk (931 GiBytes)
      3. Payload [memtest]
      4. Payload [setup]
      ```

2. mPCIe1 with resistor

    * Cold boot: it takes 60-75 sec after power-on until boot menu appears. There
      is no HDD entry in boot menu.

      ```
      phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff58000 (detail=0xdff59b40)
      /dff58000\ Start thread
      |dff58000| AHCI/0: probing
      |dff58000| AHCI/0: link up
      |dff58000| AHCI/0: send cmd ...
      |dff58000| WARNING - Timeout at ahci_command:154!
      |dff58000| AHCI/0: send cmd ...
      |dff58000| WARNING - Timeout at ahci_command:154!
      |dff58000| phys_free dff59c00 (detail=0xdff59bd0)
      |dff58000| phys_free dff59a00 (detail=0xdff59ba0)
      |dff58000| phys_free dff59900 (detail=0xdff59b70)
      |dff58000| phys_free dff61050 (detail=0xdff61020)
      \dff58000/ End thread
      phys_free dff58000 (detail=0xdff59b40)
      All threads complete.
      ```

    * After OS boot: HDD is visible and usable under Debian

    * After reboot: boot menu appears as quickly as usual. HDD entry appears in
      boot menu:

      ```
      1. ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes)
      2. AHCI/0: ST1000LM014-SSHD-8GB ATA-9 Hard-Disk (931 GiBytes)
      3. Payload [memtest]
      4. Payload [setup]
      ```

    mPCIe1 behaves the same for both mPCIe -> SATA converterts

3. mPCIe2 without resistor

    * HDD not detected neither in bootmenu nor in OS

4. mPCIe2 with resistor

    * HDD not detected in bootmenu


    * After cold boot there is boot menu entry, but cannot boot into OS from
      mSATA or USB. When loading into OS it reboots after:

    ```
    [   12.306297] Clocksource tsc unst
    ```

    * then infinite coreboot loops:

    ```
    phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff58000 (detail=0xdff59b40)
    /dff58000\ Start thread
    |dff58000| AHCI/0: probing
    |dff58000| AHCI/0: link up
    |dff58000| AHCI/0: send cmd ...
    |dff5d000| send_cmd : read error (status=51 err=04)
    |dff5c000| set_address 0xdff61480
    |dff5e000| ehci_alloc_async_pipe 0xdff61590 0
    |dff5e000| phys_alloc zone=0xdff6df10 size=92 align=80 ret=dff59880 (detail=0xdff59b10)
    |dff5e000| ehci_send_pipe qh=0xdff59880 dir=0 data=0x00000000 size=0
    phys_alloc zone=0xdff6df10 size=68 align=10 ret=dff59830 (detail=0xdff59800)
    phys_alloc zone=0xdff6df10 size=1024 align=400 ret=dff59400 (detail=0xdff593d0)
    phys_alloc zone=0xdff6df10 size=256 align=100 ret=dff59200 (detail=0xdff593a0)
    phys_alloc zone=0xdff6df10 size=256 align=100 ret=dff59100 (detail=0xdff59370)
    phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff59340)
    /dff57000\ Start thread
    |dff57000| AHCI/1: probing
    |dff58000| AHCI/0: ... intbits 0x40000001, status 0x51 ...
    |dff58000| AHCI/0: ... finished, status 0x51, ERROR 0x4
    |dff58000| AHCI/0: send cmd ...
    |dff5d000| phys_alloc zone=0xdff6df18 size=44 align=10 ret=f0800 (detail=0xdff59310)
    |dff5d000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff590b0 (detail=0xdff59080)
    |dff5d000| ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes)
    |dff5d000| Searching bootorder for: /pci@i0cf8/*@11/drive@0/disk@0
    |dff5d000| phys_alloc zone=0xdff6df10 size=24 align=10 ret=dff61000 (detail=0xdff59050)
    |dff5d000| Registering bootable: ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes) (type:2 prio:6 data:f0800)
    |dff5d000| ata_detect resetresult=0000
    |dff5d000| powerup iobase=5010 st=50
    |dff5d000| powerup iobase=5010 st=0
    |dff5d000| ata_detect ata0-1: sc=55 sn=aa dh=b0
    |dff5d000| send_cmd : DRQ not set (status 00)
    \dff5d000/ End thread
    phys_free dff5d000 (detail=0xdff612b0)
    |dff5c000| ehci_alloc_async_pipe 0xdff61480 0
    |dff5c000| phys_alloc zone=0xdff6df10 size=92 align=80 ret=dff5df80 (detail=0xdff612b0)
    |dff5c000| ehci_send_pipe qh=0xdff5df80 dir=0 data=0x00000000 size=0
    phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff56000 (detail=0xdff5df50)
    /dff56000\ Start thread
    |dff56000| Searching bootorder for: /pci@i0cf8/*@14,7
    \dff56000/ End thread
    phys_free dff56000 (detail=0xdff5df50)
    |dff57000| AHCI/1: link down
    |dff58000| AHCI/0: ... intbits 0xffffffff, status 0x58 ...
    |dff58000| AHCI/0: ... finished, status 0x58, OK
    |dff58000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5df30 (detail=0xdff5df00)
    |dff58000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@0/disk@0
    |dff58000| AHCI/0: supported modes: udma 6, multi-dma 2, pio 4
    |dff58000| AHCI/0: Set transfer mode to UDMA-6
    |dff58000| AHCI/0: send cmd ...


    coreboot-9cac328-dirty-4.0.1 Tue Oct  4 12:12:31 UTC 2016 starting...
    14-25-48Mhz Clock settings
    FCH_MISC_REG28 is 0x00400012
    FCH_MISC_REG40 is 0x000c4040
    BSP Family_Model: 00730f01
    cpu_init_detectedx = 00000000
    agesawrapper_amdinitreset() entry

    Fch_Oem_config in INIT RESET
    ```

5. After setting CLK3 (GFXCLK) to be always on (just like it was done for
   mPCIe1 and CLK3 before):

    * mPCIe2 without resistor behaves the same as mPCIe2 with resistor before this
      change (coreboot loop)

    * mPCIe2 with resistor behaves the same after change

    so: turning CLK to be always on (to ignore CLK_IRQ) causes mPCIe to treat
    card without resistor as the one with resistor

6. So there are two cases:

    * long coldboot (AHCI timeout in SeaBIOS) and no bootmenu entry for mPCIe1
      (but after reboot it's OK)

    * coreboot loop for mPCIe2

7. Connect HDD to SATA (J7)

    * regular boot, bootmenu entry appears after cold or warmboot
    * it is handled by IDE (ata.c) not AHCI (ahci.c) - when connected through
      mPCIe converter it was handled by AHCI


Long boot log:


```
[2016-10-22 16:04:16] /dff57000\ Start thread
[2016-10-22 16:04:16] |dff57000| AHCI/1: probing
[2016-10-22 16:04:16] |dff57000| AHCI/1: link up
[2016-10-22 16:04:16] |dff57000| AHCI/1: send cmd ...
[2016-10-22 16:04:48] |dff57000| WARNING - Timeout at ahci_command:154!
[2016-10-22 16:04:48] |dff57000| AHCI/1: send cmd ...
[2016-10-22 16:05:20] |dff57000| WARNING - Timeout at ahci_command:154!
[2016-10-22 16:05:20] |dff57000| phys_free dff5a400 (detail=0xdff5a3d0)
[2016-10-22 16:05:20] |dff57000| phys_free dff5a200 (detail=0xdff5a3a0)
[2016-10-22 16:05:20] |dff57000| phys_free dff5a100 (detail=0xdff5a370)
[2016-10-22 16:05:20] |dff57000| phys_free dff5ac50 (detail=0xdff5ac20)
[2016-10-22 16:05:20] \dff57000/ End thread
[2016-10-22 16:05:20] phys_free dff57000 (detail=0xdff5a340)
```

boot loop, reboots there:

```
[2016-10-22 15:57:55] /dff57000\ Start thread
[2016-10-22 15:57:55] |dff57000| AHCI/1: probing
[2016-10-22 15:57:55] |dff57000| AHCI/1: link up
[2016-10-22 15:57:55] |dff57000| AHCI/1: send cmd ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
[2016-10-22 15:57:56] |dff57000| AHCI/1: send cmd ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... finished, status 0x58, OK
[2016-10-22 15:57:56] |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae60 (detail=0xdff5ae30)
[2016-10-22 15:57:56] |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
[2016-10-22 15:57:56] |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
[2016-10-22 15:57:56] |dff57000| AHCI/1: Set transfer mode to UDMA-6
[2016-10-22 15:57:56] |dff57000| AHCI/1: send cmd ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
[2016-10-22 15:57:56] |dff57000| AHCI/1: ... finished, status 0x58, OK

// REBOOTS HERE

[2016-10-22 15:58:03] coreboot-44ac0ed-dirty-4.0.1 sat oct 22 13:52:29 utc 2016 starting...
[2016-10-22 15:58:03] 14-25-48mhz clock settings
[2016-10-22 15:58:03] fch_misc_reg28 is 0x00400012
[2016-10-22 15:58:03] fch_misc_reg40 is 0x000c4040
[2016-10-22 15:58:03] bsp family_model: 00730f01
[2016-10-22 15:58:03] cpu_init_detectedx = 00000000
[2016-10-22 15:58:03] agesawrapper_amdinitreset() entry
```
