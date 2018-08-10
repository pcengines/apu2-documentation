SeaBIOS 1.11.2 - USB detection bug
----------------------------------

## APU3/5
On this platforms USB sticks were detected by SeaBIOS (both USB2.0 and USB3.0) and 
booting was successful.

## APU4
SeaBIOS doesn't detect any USB device.
```
SeaBIOS (version rel-1.11.2-0-gf9626cc-dirty-20180810_104534-f05dcb890877XHCI init on dev 00:10.0: regs @ 0xf7f22000, 4 ports, 32 slots, 32 bys
XHCI    extcap 0x1 @ 0xf7f22500
XHCI    protocol USB  3.00, 2 ports (offset 1), def 0
XHCI    protocol USB  2.00, 2 ports (offset 3), def 10
XHCI    extcap 0xa @ 0xf7f22540
EHCI init on dev 00:12.0 (regs=0xf7f26020)
EHCI init on dev 00:13.0 (regs=0xf7f27020)
WARNING - Timeout at i8042_flush:71!
ATA controller 1 at 5010/5020/0 (irq 0 dev 88)
ATA controller 2 at 5018/5024/0 (irq 0 dev 88)
Searching bootorder for: /pci@i0cf8/*@14,7
ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes)
Searching bootorder for: /pci@i0cf8/*@11/drive@0/disk@0
Found 1 lpt ports
Found 2 serial ports
Searching bootorder for: /rom@img/memtest
)
Found sdcard at 0xf7f28000: SD card SB16G 15193MiB
WARNING - Timeout at wait_bit:302!
Initialized USB HUB (0 ports used)
Initialized USB HUB (0 ports used)
All threads complete.
Scan for option roms

Press ESC for boot menu.

Select boot device:

1. ata0-0: SATA SSD ATA-10 Hard-Disk (15272 MiBytes)
2. SD card SB16G 15193MiB
3. Payload [memtest]
```

After booting to Voyage OS installed on SATA I checked list of USB detected devices.
###### USB3.0 and USB2.0 sticks
```
Bus 002 Device 002: ID 0438:7900 Advanced Micro Devices, Inc.
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 0438:7900 Advanced Micro Devices, Inc.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 002: ID 0781:5591 SanDisk Corp.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

###### 2x USB3.0 sticks
```
Bus 004 Device 002: ID 0438:7900 Advanced Micro Devices, Inc.
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 002: ID 0438:7900 Advanced Micro Devices, Inc.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 0951:1665 Kingston Technology
Bus 001 Device 002: ID 0781:5591 SanDisk Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

Comparing output from both scenarios we can assume that OS is unable to detect USB3.0. 