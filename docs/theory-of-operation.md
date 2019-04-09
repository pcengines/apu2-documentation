# apu features - theory of operation


## Boot menu 

It let selecting boot device (first options) and enter another menus to extended coreboot/seaBIOS features.  
To enter boot menu Press `F10` key after reboot.   

### Example view of boot menu
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

It let using some coreboot/seaBIOS features.  
To enter Payload menu type `6. Payload [setup]` option in Boot menu.  

### Example view of Payload menu
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

It let writting and reading serial number to security registers of the SPI flash chip.   
To enter Hidden menu type `shift + z (Z)` in Payload menu.  

### Example view of Hidden security registers menu
--- Security registers menu ---

  r        - read serial from security register 1
  w serial - write serial to security register 1
  e        - erase security registers content
  s        - get security registers OTP status
  q        - exit menu
  
  
  
## coreboot features

1. CBFS option mPCIe2 clk

	If mPCIe2 clk is enabled then GPP3 PCIe clock (which is attached to mPCIe2 slot) is always on. It is used when extension card is attached to mPCIe2 slot.  
	If no extension card is attached it is advised to set to `Disable`.  
	It is avaiable from Payload menu.   

	To `Enable/Disable` this feature type `m` in Payload menu.  

	Watch [Video showing how to enable/disable mPCIe2 clk](https://asciinema.org/a/239813)  


2. Enable/disable EHCI0 controller

	This feature let user enables/disable EHCI0 controller.  
	It is avaiable from Payload menu.   

	To `Enable/Disable` this feature type `h` in Payload menu.  

	Watch [Video showing how to enable/disable EHCI0 controller](https://asciinema.org/a/239816)  


3. Enable/Disable UARTC/UARTD

	This feature let user enable/disable UARTx.  
	It is avaiable from Payload menu.  

	To `Enable/Disable` UARTC type `o` in Payload menu.  
	To `Enable/Disable` UARTD type `p` in Payload menu.  

	Watch [Video showing how to enable/disable UARTC/UARTD](https://asciinema.org/a/239817)  


4. Enable/Disable serial console.

	This feature let user enable/disable serial console.  
	If it is disabled no data will be displayed in serial output. It means when using serial connection no output will be avaiable no more.  

	To `Enable/Disable` serial consol type `t` in Payload menu.  
	
	Watch [Video showing how to enable/disable serial console]( *Zrobic video z wylaczenia konsoli*)   

5. Getting device serial number from NIC

	This feature gives device serial number which is calculeted using its MAC-address.  
	
	
6. Reading/Writting Serial number from SPI flash

	This feature let user write and/or read serial number which is contained in hidden security register.  



## seaBIOS features

1. Enable/disable USB boot

	This feature let user `Enable/Disable` booting from USB device.  
	If USB boot is `Enabled` then after restarting apu, USB devices should be listed in `boot menu`.  
	If USB boot is `Disabled` then after restarting apu, no USB devices should be listed in `boot menu` (even if USB device is attached to USB slot).  

2. Press F10 button to enter boot menu. 

	To enter boot menu, press `f10` button.   
	If `f10` button isn't pushed within 6 seconds, then automaticlly booting from Hard Disk will be performed.  

3. Boot menu timeout 6s

4. N for iPXE boot string

5. Bootorder configuration file










   

