# apu features - theory of operation

## Boot menu

It let selecting boot device (first options) and enter another menus to extended
coreboot/seaBIOS features. To enter boot menu Press `F10` key after reboot.

#### Example view of boot menu
```
SeaBIOS (version rel-1.12.1.1-0-g55d345f)

Press F10 key now for boot menu, N for PXE boot
Select boot device:

1. USB MSC Drive Kingston DataTraveler 3.0 PMAP
2. USB MSC Drive Kingston DataTraveler 3.0 PMAP
3. SD card SB16G 15193MiB
4. AHCI/0: SanDisk SSD i110 16GB ATA-9 Hard-Disk (14566 MiBytes)
5. iPXE
6. Payload [setup]
7. Payload [memtest]

t. TPM Configuration
```

## Payload menu

It let using some coreboot/seaBIOS features. To enter Payload menu choose
`Payload [setup]` option in Boot menu.

#### Example view of Payload menu
```
### PC Engines apu2 setup v4.6.13 ###
Boot order - type letter to move device to top.

  a USB 1 / USB 2 SS and HS
  b SDCARD
  c mSATA
  d SATA
  e mPCIe1 SATA1 and SATA2
  f iPXE


  r Restore boot order defaults
  n Network/PXE boot - Currently Enabled
  u USB boot - Currently Enabled
  t Serial console - Currently Enabled
  k Redirect console output to COM2 - Currently Disabled
  o UART C - Currently Enabled
  p UART D - Currently Enabled
  m Force mPCIe2 slot CLK (GPP3 PCIe) - Currently Disabled
  h EHCI0 controller - Currently Enabled
  l Core Performance Boost - Currently Enabled
  w Enable BIOS write protect - Currently Disabled
  x Exit setup without save
  s Save configuration and exit
```

## Hidden security registers menu

It let writing and reading serial number to security registers of the SPI flash
chip. To enter Hidden menu type `shift + z` in Payload menu.

#### Example view of Hidden security registers menu
```
--- Security registers menu ---

  r        - read serial from security register 1
  w serial - write serial to security register 1
  e        - erase security registers content
  s        - get security registers OTP status
  q        - exit menu
```

## Coreboot features

- **Reading/Writing Serial number to SPI flash**

	This feature let user write and/or read serial number which is contained in
	hidden security register. To use it first go to security registers menu.

  In security registers menu, to read Serial number from SPI flash press `r` and
  then `ENTER`. To write serial number press type `w <new-serial-number>`, where
  <new-serial-number> is 9 decimal serial number.

  >NOTE: When writing new serial number, only 9 first decimals are taken  

  Watch [Video](https://asciinema.org/a/240504) showing how to R/W Serial number
  to SPI flash.


## Sortbootorder features

- **Setting bootorder priority**

  In Boot menu user can freely change bootorder. To do it press `a,b,..,f` key
  to move selected device to the top of the list.

  Watch [Video](https://asciinema.org/a/240509) showing how to change bootorder
  in Boot menu.


- **Enable/Disable Network/PXE boot**

  This option let user `Enable/Disable` booting from PXE. If it is `Enabled`
  then appropriate boot device should be available in boot menu (e.g. `iPXE`).
  If it is `Disabled` then no PXE device should be listed in boot menu and
  feature `N for PXE boot` in boot menu is also no longer available.

  To `Enable/Disable` booting from Network/PXE press `n` in payload menu.

  Watch [Video](https://asciinema.org/a/240518) showing how to enable/disable
  PXE boot and what outcome to expect.


- **Enable/Disable USB boot**

	This feature let user `Enable/Disable` booting from USB device.   If USB boot
	is `Enabled` then after restarting apu, USB devices should be listed in `boot
	menu`.   If USB boot is `Disabled` then after restarting apu, no USB devices
	should be listed in `boot menu` (even if USB device is attached to USB slot).  

  Watch [Video](https://asciinema.org/a/239796) showing how to enable/disable
  USB boot.


- **Enable/Disable serial console**

	This feature let user enable/disable serial console. If it is disabled no data
	will be displayed in serial output. It means when using serial connection no
	output will be available no more.  

	To `Enable/Disable` serial console type `t` in Payload menu.


- **Enable/Disable UARTC/UARTD**
	This feature let user enable/disable UARTx.  

	To `Enable/Disable` UARTC type `o` in Payload menu.
	To `Enable/Disable` UARTD type `p` in Payload menu.

	Watch [Video](https://asciinema.org/a/239817) showing how to enable/disable
	UARTC/UARTD


- **Enable/Disable mPCIe2 clk**

  If mPCIe2 clk is enabled then GPP3 PCIe clock (which is attached to mPCIe2
  slot) is always on. It is used when extension card is attached to mPCIe2 slot.
  If no extension card is attached it is advised to set to `Disable`.

  To `Enable/Disable` this feature type `m` in Payload menu.

  Watch [Video](https://asciinema.org/a/239813) showing how to enable/disable
  mPCIe2 clk


- **Enable/Disable EHCI0 controller**

	This feature let user enables/disable EHCI0 controller.

	To `Enable/Disable` this feature type `h` in Payload menu.

	Watch [Video](https://asciinema.org/a/239816) showing how to enable/disable
	EHCI0 controller]


## seaBIOS features

- **Press `F10` button to enter boot menu and boot menu 6s timeout**

	To enter boot menu, press `F10` button.

  >NOTE: After power on user has 6 seconds to enter boot menu. If no button is
  pressed then automatically boot is performed.

  Watch [Video](https://asciinema.org/a/240500) showing how to enter boot menu
  via `F10` button and boot menu 6s timeout feature.


- **Press `n` for iPXE boot string**

  After power on, press `n` to enter iPXE boot menu.

  > NOTE: If this option isn't available check if Network/PXE boot is `Enabled`
  in payload menu. If not - enable it, save changes and restart device.

  Watch [Video](https://asciinema.org/a/240529) showing how to enter iPXE boot
  menu after power on.


## Memtest 86+ features

To perform Memory Test choose `Payload [memtest]` option in boot menu.

- **Screen refresh**

  During memory test user can refresh screen if the output in terminal is
  unreadable (e.g. due to text overlaps). To refresh screen during test type
  `c`, then choose option `(5). Refresh screen`.

  Watch [Video](https://asciinema.org/a/240533) showing how screen refresh
  feature works.
