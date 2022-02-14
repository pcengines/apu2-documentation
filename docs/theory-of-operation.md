# apu features - theory of operation

## Boot menu

It lets selecting boot device (first options) and enter another menus to
extended coreboot/seaBIOS features. To enter boot menu press `F10` key during
boot process.

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

It lets using some coreboot/seaBIOS features. To enter payload menu choose
`Payload [setup]` option in boot menu.

#### Example view of payload menu
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

It lets writing and reading serial number to security registers of the SPI flash
chip. To enter hidden menu type `shift + z` in payload menu.

## PC Engines apu firmware features

- **Reading/Writing Serial number to SPI flash**

	This feature lets user write and/or read serial number which is contained in
	hidden security register. To use it first, go to security registers menu.

  >NOTE: When writing new serial number, only 9 first characters are taken, even
  if user gives more.

  Watch [Video](https://asciinema.org/a/241568) showing how Reading/Writing
  Serial number to SPI flash feature works.


- **Setting bootorder priority**

  In boot menu user can freely change bootorder.

  Watch [Video](https://asciinema.org/a/240509) showing how to change bootorder
  in Boot menu.


- **Enable/Disable Network/PXE boot and press `n` for iPXE boot string**

  This feature lets user `Enable/Disable` booting from PXE. If it is `Enabled`
  then during boot process user can access PXE boot string with `n` button. Also
  appropriate boot device should be available in boot menu (e.g. `iPXE`).

  Watch [Video](https://asciinema.org/a/241583) showing how to enable/disable
  PXE boot and how to open PXE boot string.


- **Enable/Disable USB boot**

	This feature let user `Enable/Disable` booting from USB device.

  Watch [Video](https://asciinema.org/a/239796) showing how to enable/disable
  USB boot.


- **Disable serial console and enable with S1 button**

  To `Disable` serial console type `t` in payload menu. If it is disabled no
  data will be displayed in serial output. After changing state to `Disabled`
  restoring console can be done only via S1 button.

  Watch [video](https://asciinema.org/a/240951) showing how to disable serial
  console with payload menu option and then enable it with S1 button.


- **Redirect console output to COM2**

  Console output is available via COM1 in default. This feature let user
  redirect console output to COM2.
  >NOTE: Changing this option from `Disabled` to `Enabled` (or the opposite way)
  will cause losing current output in terminal. The advice is to open new
  connection in another terminal window on another COM.

  Watch [video](https://asciinema.org/a/240926) showing how to redirect console
  output to COM2.
  >NOTE: In above example serial connection is redirect to telnet. First, it is
  opened on 13541 port (COM1). After enabling redirect console to COM2, output
  is no longer available. New telnet connection is opened on 13542 port (COM2)
  and console output is available there.


- **Enable/Disable CPU boost**

  This feature lets user `Enable/Disable` CPU performance boost. To verify if
  it works, memory test can be done (in boot menu choose `payload[memtest]`).

  >NOTE: Notice how memory transfer speed changes depending on CPU boost
  enable/disable.

  Watch [video](https://asciinema.org/a/241571) showing how to enable/disable
  CPU performance boost and verify it.


- **Enable/Disable UARTC/UARTD**

	This feature lets user enable/disable superIO UARTx on GPIO header.

	Watch [Video](https://asciinema.org/a/241576) showing how to enable/disable
	UARTC/UARTD.


- **Enable/Disable mPCIe2 clk**

  If mPCIe2 clk is enabled then GPP3 PCIe clock (which is attached to apu2
  mPCIe2 slot) is always on. It is used when extension card is attached to
  mPCIe2 slot. If no extension card is attached it is advised to set to
  `Disable`.

  Watch [Video](https://asciinema.org/a/239813) showing how to enable/disable
  mPCIe2 clk.


- **Enable/Disable EHCI0 controller**

	This feature lets user enable/disable EHCI0 controller.

	Watch [Video](https://asciinema.org/a/244786) showing how to enable/disable
	EHCI0 controller.


- **Restore default sortbootorder settings**

  If user wants to bring back default settings in sortbootorder, it can be
  restored by typing `r` in payload menu. It will reset enable/disable features
  and boot order to defaults.

  Watch [video](https://asciinema.org/a/240935) showing how to restore settings
  to its default values.


- **Press `F10` button to enter boot menu and boot menu 6s timeout**

	During boot performance, press `F10` button to enter boot menu.

  >NOTE: After power on user has 6 seconds to enter boot menu. If no button is
  pressed then automatically boot is performed.

  Watch [Video](https://asciinema.org/a/240500) showing how to enter boot menu
  via `F10` button and boot menu 6s timeout feature.


- **Screen refresh during memory test performance**

  To perform memory test choose `Payload [memtest]` option in boot menu.

  During memory test user can refresh screen if the output in terminal is not
  available. It happens when serial connection is opened during test
  performance. Screen refresh can be done by typing `l` or `L`.

  Watch [Video](https://asciinema.org/a/241564) showing how screen refresh
  during memory test works.

- **TPM SHA1 and SHA256 banks enable/disable**

  PC Engines apu2 supports TPM module. This feature lets user choose which PCR
  banks are active.

  Watch [video](https://asciinema.org/a/244774) showing how to enable/disable
  SHAx banks in TPM menu.

- **Setting watchdog timeout**

  To `Enable` watchdog, type `i` in payload menu. You will be prompted to
  specify the timeout after which the platform should reset.

  By default the timeout is set to 0 seconds (disabled state). To enable
  watchdog, enter setup menu and toggle watchdog option.

  Since v4.14.0.4 version, sortbootorder payload won't allow to set the watchdog
  timeout below 60s.

  > WARNING: do not set short timeouts! It may lead to a reset loop and brick
  Your platform. Please take into consideration that platform boot time and OS
  boot time also counts to the overall timeout time, so set at least few minutes
  timeout to still be able to enter setup menu to disable the watchdog!

  > The operating system has to support the watchdog, otherwise the platform
  will constantly reboot. For Linux OSes the driver is sp5100_tco, however it
  conflicts with i2c_piix4 leaving the watchdog driver unloaded completely.
  One has to properly blacklist the i2c_piix4 driver in order to get the
  watchdog working.

  Watch [video](https://asciinema.org/a/464131) showing how to enable/disable
  watchdog.
