BIOS write protect
==================

## Rationale

Enabling of the SPI flash locking on APU2/3 boards could prove to be useful,
in order to prevent BIOS updates and/or malicious binary injection to the
BIOS flash memory during system runtime and/or remotely.

## Documents used

### BKDG no.1

* [BKDG for family 16h model 30h processor](http://support.amd.com/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf)

### BKDG no.2
* [BKDG for family 16h models 00h-0Fh processors](http://support.amd.com/TechDocs/48751_16h_bkdg.pdf)

## Initial investigation

At first, [BKDG](#bkdg-no1) for processor family 16h model 30h, as stated in
`/proc/cpuinfo` of used Linux distribution, was used as a reference:

```sh
$ cat /proc/cpuinfo
...

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 22
model           : 48
model name      : AMD GX-412TC SOC
...
```

There is a possibility to block the writes (and reads) to flash using the
registers described in paragraph **3.26.9.2 SPIx1D Alt_SPI_CS**
(`SpiProtectEn0`, `SpiProtectLock`). Definition of address ranges,
that are to be blocked, is described in paragraph
**3.26.9.1 D14F3x[5C,58,54,50] ROM Protect 3, 2, 1, 0**

SPI WP# is on the J2 header (page 12 on the [board schematics](http://www.pcengines.ch/schema/apu2c.pdf)).
This signal is connected to the dedicated SPI WP# pin of the APU chip and can't
be controlled like a GPIO.

First test was done checking the behavior of the SPI WP# pin, when shorted to
ground. No change was noticed. Flashing was still possible using `flashrom`
application on Voyage Linux distribution.

## Flash writes blocking using register definitions in BKDG no.1

PCI config registers for device 14h function 3h (offset 50h) was set according
to [BKDG no.1](#bkdg-no1).

* `RomBase` was set to 0 (as for the start of the flash addressing),
* `WriteProtect` was set to 1,
* `ReadProtect` was set to 0,
* `RangeUnit` was set to 1 (64kB unit size),
* `Range` was set to `0x80` (8MB flash locked)

SPI device memory mapped register (`BAR` for this device is set using PCI config
register `0xA0` of the device 14h, function 3h), offset `0x1D` was set:

* `SpiProtectEn0` to 1,
* `SpiProtectLock` to 1.

`lspci` output:

```
$ lspci -s 14.3 -xxx
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
00: 22 10 0e 78 0f 00 20 02 11 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 22 10 0e 78
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 00 00 00 d5 ff 03 ff 07 ff 20 03 00 00 00 00
50: 80 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 0e f8 03 0e 00 0f 00 00 ff ff ff
70: 67 45 23 00 0c 00 00 00 90 00 00 00 05 0b 00 00
80: 08 00 03 a8 00 00 00 00 00 00 00 00 00 00 00 00
90: e8 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 02 00 c1 fe 2f 01 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 04 00 e9 3d 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 80 47 10 82 ff
d0: 86 ff ff 08 42 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
```

Using `flashrom` utility, flash was still somewhat writeable, but returned
errors during verification process.

```
$ flashrom -w coreboot.rom -p internal:boardmismatch=force
flashrom v0.9.9-r1954 on Linux 3.16.7-ckt9-voyage (x86_64)
flashrom is free software, get the source code at https://flashrom.org

Calibrating delay loop... delay loop is unreliable, trying to continue OK.
coreboot table found at 0xdffae000.
Found chipset "AMD FCH".
Enabling flash write... OK.
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
Reading old flash chip contents... done.
Erasing and writing flash chip... Reading current flash chip contents... FAILED at 0x00060000! Expected=0xff, Found=0x55, failed byte count from 0x00060000-0x00060fff: 0xfdf
ERASE FAILED!
done. Looking for another erase function.
Erase/write done.
Verifying flash... FAILED at 0x00060000! Expected=0x55, Found=0xff, failed byte count from 0x00000000-0x007fffff: 0x14500
Your flash chip is in an unknown state.
Get help on IRC at chat.freenode.net (channel #flashrom) or
mail flashrom@flashrom.org with the subject "FAILED: <your board name>"!
-------------------------------------------------------------------------------
DO NOT REBOOT OR POWEROFF!
```

Platform was _not booting_ anymore.


## Flash writes blocking using register definitions in BKDG no.2

In [BKDG no.2](#bkdg-no2) definition of the PCI config registers for device 14h
function 3h is different
(paragraph **3.25.9.1 D14F3x[5C,58,54,50] ROM Protect 3, 2, 1, 0**).

According to the document above, registers were set like this:

Offset `0x50`:

* `RomBase` was set to `0` (as for the start of the flash addressing),
* `RomOffset` was set to `1ff` (512kB),
* `ReadProtect` was set to `1`,
* `WriteProtect` was set to `1`.

Offset `0x54`:

* `RomBase` was set to `0x005ff800` (as for the AGESA fw offset in flash),
* `RomOffset` was set to `1ff` (512kB),
* `ReadProtect` was set to `1`,
* `WriteProtect` was set to `1`.

SPI device memory mapped register, offset `0x1D` was set as in the test before.

`lspci` output:

```
$ lspci -s 14.3 -xxx
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
00: 22 10 0e 78 0f 00 20 02 11 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 22 10 0e 78
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 00 00 00 d5 ff 03 ff 07 ff 20 03 00 00 00 00
50: ff 07 00 00 ff ff 5f 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 0e f8 03 0e 00 0f 00 00 ff ff ff
70: 67 45 23 00 0c 00 00 00 90 00 00 00 05 0a 00 00
80: 08 00 03 a8 00 00 00 00 00 00 00 00 00 00 00 00
90: e8 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 02 00 c1 fe 2f 01 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 04 00 e9 3d 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 80 47 10 82 ff
d0: 86 ff ff 08 42 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
```

Using `flashrom` utility flashing the vital areas is not possible.

```
$ flashrom -w coreboot.rom -p internal:boardmismatch=force
flashrom v0.9.9-r1954 on Linux 3.16.7-ckt9-voyage (x86_64)
flashrom is free software, get the source code at https://flashrom.org

Calibrating delay loop... OK.
coreboot table found at 0xdffae000.
Found chipset "AMD FCH".
Enabling flash write... OK.
Disabling read write protection of flash addresses from 0x00000000 to 0x0007ffff failed.
Disabling read write protection of flash addresses from 0x005ff800 to 0x0067f7ff failed.
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
Reading old flash chip contents... done.
Erasing and writing flash chip... Erase/write done.
Verifying flash... FAILED at 0x00000000! Expected=0x4c, Found=0xff, failed byte count from 0x00000000-0x007fffff: 0x167107
Your flash chip is in an unknown state.
Get help on IRC at chat.freenode.net (channel #flashrom) or
mail flashrom@flashrom.org with the subject "FAILED: <your board name>"!
-------------------------------------------------------------------------------
DO NOT REBOOT OR POWEROFF!
```

Despite the warning, board was still bootable and contained old firmware.

## Conclusions

[BKDG](#bkdg-no1) for processor family/model used in APU2/3 platform is not
correct. One has to use the [BKDG](#bkdg-no2) for older processor family/models.

Blocking the flash writes/reads on APU2/3 boards is certainly possible, but
according to research done, it's not possible to lock the full 8MB of flash
memory (only 2MB at most using all 4 blockable regions).
Unfortunately choosing the vital areas of flash to be blocked, is also
very difficult as coreboot creates layout in a dynamic way, so it could
vary between versions (e.g. legacy vs mainline).
