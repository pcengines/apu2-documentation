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

## coreboot features

- **Reading/Writing Serial number to SPI flash**

	This feature let user write and/or read serial number which is contained in
	hidden security register. To use it first, go to security registers menu.

  In security registers menu, to read Serial number from SPI flash press `r` and
  then `ENTER`.
To write serial number type `w <new-serial-number>`, where
  `new-serial-number` is 9 character serial number. To erase serial number from
  SPI flash, type `e`.

  >NOTE: When writing new serial number, only 9 first characters are taken, even
  if user gives more.

  Watch [Video](https://asciinema.org/a/240504) showing how to R/W Serial number
  to SPI flash.


## sortbootorder features

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


- **Disable serial console and enable with S1 button**

  To `Disable` serial console type `t` in Payload menu. If it is disabled no
  data will be displayed in serial output.

  After changing state to `Disabled` restoring console can be done only via S1
  button.

  Watch [video](https://asciinema.org/a/240951) showing how to disable serial
  console with payload menu option and then enable it with S1 button.


- **Redirect console output to COM2**

  Console output is available via COM1 in default. This feature let user
  redirect console output to COM2.
  >NOTE: Changing this option from `Disabled` to `Enabled` (or the opposite way)
  will cause losing current output in terminal. The advice is to open new
  connection in another terminal window on another COM.

  To `Enable/Disable` redirect console output to COM2 type `k` in payload menu.

  Watch [video](https://asciinema.org/a/240926) showing how to redirect console
  output to COM2.
  >NOTE: In above example connection is first opened on 13541 port (COM1). After
  enabling redirect to COM2, console output is no longer available. New
  connection is opened on 13542 port (COM2) and console output is available
  there.


- **Enable/Disable CPU boost**

  This feature let user `Enable/Disable` CPU performance boost . To verify if it
  works, memory test can be done (in boot menu choose `payload[memtest]`).

  To `Enable/Disable` CPU boost type `l` in payload menu.

  Watch [video](https://asciinema.org/a/240928) showing how to enable/disable
  CPU performance boost.
  >NOTE: In the example, 2 memory test are performed - one with CPU boost
  disabled and one with CPU boost enabled. Notice, how long both tests are
  running and what progress is made during that time. Also look at speed of data
  transfer to cache memory.


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


- **Restore default sortbootorder settings**

  If user wants to bring back default settings in sortbootorder, it can be
  restored by typing `r` in payload menu. It will reset enable/disable features
  and boot order to defaults.

  Watch [video](https://asciinema.org/a/240935) showing how to restore settings
  to its default values.


## seaBIOS features

- **Press `F10` button to enter boot menu and boot menu 6s timeout**

	After device restart, press `F10` button to enter boot menu.

  >NOTE: After power on user has 6 seconds to enter boot menu. If no button is
  pressed then automatically boot is performed.

  Watch [Video](https://asciinema.org/a/240500) showing how to enter boot menu
  via `F10` button and boot menu 6s timeout feature.


- **Press `n` for iPXE boot string**

  After device restart, press `n` to enter iPXE boot menu.

  > NOTE: If this option isn't available check if *Network/PXE boot* is
  `Enabled` in payload menu. If not - enable it, save changes and restart
  device.

  Watch [Video](https://asciinema.org/a/240529) showing how to enter iPXE boot
  menu after power on.


## Memtest 86+ features

To perform Memory Test choose `Payload [memtest]` option in boot menu.

- **Screen refresh**

  During memory test user can refresh screen if the output in terminal is
  unreadable (e.g. due to text overlaps). Screen refresh can be done by:  
    - type `c`, then choose option `(5). Refresh screen`
    - type `l` or `L` during test

  Watch [Video](https://asciinema.org/a/240533) showing how screen refresh
  feature works.
