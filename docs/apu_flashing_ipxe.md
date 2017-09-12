PC Engines APUx flashing with iPXE usage
========================================

Intro
-----
* Name of used APUx serial console visible in PC: `ttyUSB0`
* IP of used PXE server: `192.168.0.108`

Requirements
------------

* Ethernet connection to the network
* iPXE server has to be online and in the same network
* PXE boot has to be enabled in SeaBIOS options
* OS with installed `flashrom`
* Serial connection between APUx and PC

Flashing procedure
------------------

1. Open APUx serial console. You can use `minicom` to do that.
Parameters of connection:
* Baudrate: 115200
* Data bits: 8
* Parity: None
* Stop bits: 1

```
sudo minicom -b 115200 -o -D /dev/<name of APUx serial console visible in PC>
```

E.g.
```
sudo minicom -b 115200 -o -D /dev/ttyUSB0
```

2. Turn on APUx.

3. When following communicate appears:
```
Press F10 key now for boot menu, N for PXE boot
```
press `N` to enter to the PXE boot menu.

```
   ---------------- iPXE boot menu ----------------
   ipxe shell
   autoboot
```

4. Select `ipxe shell`. You have to hurry because default option is `autoboot` and
it will be selected after few seconds.

5. After successful running the ipxe shell the following prompt will appear
```
iPXE> 
```
Now you have to type commands showed below:
```
dhcp net1
set filename pxelinux.0
set next-server 192.168.0.108
chain tftp://${next-server}/${filename} 
```

> The `X` number in `netX` interface can be different depending on the connector 
to which Ethernet is connected. If selected interface is connected to network
information similar to the showed below should appear:
```
Configuring (net1 00:0d:b9:47:bb:e1).................. ok
```
> MAC address should be displayed. If there is no MAC address that means that
there is no connection to the network for that interface.

> IP placed next to `next-server` should be correct IP of used PXE server.

6. After few seconds PXE server boot menu  should appear:

```
				 lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
				 x         PXE server boot menu          x
				 tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqu
				 x Install                               x
				 x Debian-netboot                        x
				 x Voyage-netinst                        x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 x                                       x
				 mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj

				        Press [Tab] to edit options
```

Select `Debian-netboot` because it's the only OS with installed `flashrom`
available in PXE server boot menu when instruction is being written. After that
OS booting should start. 

Number of OSes can be increased in the future.

> When `Legacy Console Redirection` is turned on displayed characters are 
doubled. It's beacause iPXE is outputting data to the serial console and
to the screen, which is emulated on serial console.

7. When a prompt similar to the shown below appears:
```
pcengines login: 

```
Type `root` as login. Then next prompt should appear:
```
Password: 
```
Type `root` as password to finish logging process.

> Steps shown above can be automated using Robot Framework and [this test](https://github.com/pcengines/apu-test-suite/pull/2/files).

8. Now you can start flashing process. To flash firmware with `flashrom` usage
type:
```
flashrom -w <directory to ROM> -p internal
```
E.g.:
```
flashrom -w /tmp/coreboot.rom -p internal
```

After correct firmware flashing the following message should appear:
```
Reading old flash chip contents... done.
Erasing and writing flash chip... Erase/write done.
Verifying flash... VERIFIED.
```
9. Now you can reboot the platform.

> Sometimes after APUx flashing platform doesn't turn on after warm boot. In 
that situation cold boot is required.

Sending ROM image to APUx device with `scp` usage
-------------------------------------------------

To send ROM image to device you can use `scp`.
```
cd <directory with ROM image>
scp <ROM image> root@<IP of APUx to flash>:<directory to store ROM image on APUx>
```
E.g.:
```
cd /home/me/coreboot/build
scp coreboot.rom root@192.168.0.123:/tmp
```
Then to flash APUx type in the serial console:
```
cd 
flashrom -w /tmp/coreboot.rom -p internal
```

Enabling PXE boot in SeaBIOS
----------------------------

1. Turn on APUx.

2. When the following prompt shows:
```
Press F10 key now for boot menu
```
Press `F10`. 

3. Then menu similar to the showed below should appear:
```
Select boot device:

1. Payload [setup]
2. Payload [memtest]
```
Select `1. Payload [setup]` by pressing `1`.

4. Next menu will be showed:

```
### PC Engines apu2 setup v4.5.7 ###
Boot order - type letter to move device to top.

  a USB 1 / USB 2 SS and HS 
  b SDCARD 
  c mSATA 
  d SATA 
  e mPCIe1 SATA1 and SATA2 
  f iPXE (disabled)


  r Restore boot order defaults
  n Network/PXE boot - Currently Disabled
  u USB boot - Currently Enabled
  l Legacy console redirection - Currently Disabled
  w Enable BIOS write protect - Currently Disabled
  x Exit setup without save
  s Save configuration and exit
```
Select `n Network/PXE boot - Currently Disabled` by pressing `n`. This position
should change to `n Network/PXE boot - Currently Enabled`. 

5. Now you can reboot platform by choosing `s Save configuration and exit`, so 
press `s` to do that.

