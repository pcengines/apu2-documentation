### TP-LInk stick test

1. Power on with WLAN stick attached:

*SeaBIOS logs:

```
/dff5b000\ Start thread
/dff5a000\ Start thread
|dff5e000| sdcard_set_frequency 50 400 4000
/dff59000\ Start thread
**|dff59000| xhci_hub_reset port #3: 0x000202e1, powered, pls 7, speed 0 [ - ]
|dff5d000| set_address 0xdff616a0
/dff58000\ Start thread
|dff5d000| config_usb: 0xdff57fd0
|dff5d000| device rev=0200 cls=09 sub=00 proto=01 size=64
/dff56000\ Start thread
/dff55000\ Start thread
/dff54000\ Start thread
/dff53000\ Start thread
**|dff59000| XHCI port #3: 0x00200e03, powered, enabled, pls 0, speed 3 [High]
**|dff59000| set_address 0xdffadfb0
**|dff59000| xhci_alloc_pipe: usbdev 0xdff61130, ring 0xdffad900, slotid 0, epid 1
|dff59000| xhci_cmd_enable_slot:
|dff59000| xhci_process_events port #3: 0x00200e03, powered, enabled, pls 0, speed 3 [High]
|dff59000| xhci_pross_events port #3: 0x00000e03, powered, enabled, pls 0, speed 3 [High]
|dff59000| xhci_alloc_pipe: enable slot: got slotid 1
|dff59000| xhci_cmd_address_device: slotid 1
dff59000| xhci_realloc_pipe: usbdev 0xdff61130, ring 0xdffad900, slotid 1, epid 1
|dff59000| config_usb: 0xdffada20
|dff59000| device rev=0200 cls=ff sub=ff proto=ff size=64
|dff59000| xhci_realloc_pipe: usbdev 0xdff61130, ring 0xdffad900, slotid 1, epid 1
\dff59000/ End thread
|dff5e000| sdcard_set_frequency 50 200000 0
|dff5e000| host_control contains 0x00000f04
|dff5e000| Found sdcard at 0xfeb25500: SD card SD8GB 7600MiB
|dff5e000| Registering bootable: SD card SD8GB 7600MiB (type:2 prio:5 data:f14e0)\dff5e000/ End thread
dff5b000/ End thread
\dff58000/ End thread
\dff5a000/ End thread
\dff5c000/ End thread
**|dff60000| XHCI no devices found
\dff60000/ End thread
dff53000/ End thread
\dff54000/ End thread
\dff55000/ End thread
\dff56000/ End thread
**|dff5d000| Initialized USB HUB (0 ports used)
\dff5d000/ End thread
\dff5f000/ End thread
```

*dmesg log after power on:

```
[    6.191070] usb 2-1: ath9k_htc: Firmware htc_9271.fw requested
[    6.191152] usb 2-1: firmware: failed to load htc_9271.fw (-2)
[    6.197100] usb 2-1: Direct firmware load failed with error -2
[    6.197110] usb 2-1: Falling back to user helper
[    6.197515] usbcore: registered new interface driver ath9k_htc
[    6.199886] kvm: Nested Virtualization enabled
[    6.199898] kvm: Nested Paging enabled
[    6.204528] usb 2-1: ath9k_htc: USB layer deinitialized
```

*dmesg log after reattach stick:

```
[  729.384964] usb 2-1: USB disconnect, device number 2
[  745.206019] usb 2-1: new high-speed USB device number 3 using xhci_hcd
[  745.353530] usb 2-1: New USB device found, idVendor0cf3, idProduct=9271
[  745.353546] usb 2-1: New USB device strings: Mfr=16, Product=32, SerialNumber=48
[  745.353558] usb 2-1: Product: USB2.0 WLAN
[  745.353568] usb 2-1: Manufacturer: ATHEROS
[  745.353578] usb 2-1: SerialNumber: 12345
[  745.355595] usb 2-1: ath9k_htc: Firmware htc_9271.fw requested
[  745.356341] usb 2-1: firmware: failed to load htc_9271.fw (-2)
[  745.362233] usb 2-1: Direct firmware load failed with error -2
[  745.362254] usb 2-1: Falling back to user helper
[  745.364167] usb 2-1: ath9k_htc: USB layer deinitialized
```

It seems that there is no driver. Solution:

```
 wget http://linuxwireless.org/download/htc_fw/1.3/htc_9271.fw
 mv htc_9271.fw /lib/firmware
```

*dmesg output after getting driver:

```
[ 1341.890122] usb 2-1: USB disconnect, device number 8
[ 1341.997705] usb 2-1: ath9k_htc: USB layer deinitialized
[ 1345.673776] usb 2-1: new high-speed USB device number 9 using xhci_hcd
[ 1345.821304] usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271
[ 1345.821320] usb 2-1: New USB device strings: Mfr=16, Product=32, SerialNumber=48
[ 1345.821332] usb 2-1: Product: USB2.0 WLAN
[ 1345.821342] usb 2-1: Manufacturer: ATHEROS
[ 1345.821352] usb 2-1: SerialNumber: 12345
[ 1345.823393] usb 2-1: ath9k_htc: Firmware htc_9271.fw requested
[ 1345.824238] usb 2-1: firmware: direct-loading firmware htc_9271.fw
[ 1346.286718] usb 2-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[ 1346.522733] ath9k_htc 2-1:1.0: ath9k_htc: HTC initialized with 33 credits
[ 1346.749872] ath9k_htc 2-1:1.0: ath9k_htc: FW Version: 1.3
[ 1346.749884] ath: EEPROM regdomain: 0x809c
[ 1346.749890] ath: EEPROM indicates we should expect a country code
[ 1346.749898] ath: doing EEPROM country->regdmn map search
[ 1346.749907] ath: country maps to regdmn code: 0x52
[ 1346.749913] ath: Country alpha2 being used: CN
[ 1346.749920] ath: Regpair used: 0x52
[ 1346.754781] ieee80211 phy3: Atheros AR9271 Rev:1
[ 1346.754850] cfg80211: Calling CRDA to update world regulatory domain
[ 1346.786394] systemd-udevd[818]: renamed network interface wlan0 to wlan1
```

2. Reboot with WLAN stick attached

```
/dff5b000\ Start thread
/dff5a000\ Start thread
|dff5e000| sdcard_set_frequency 50 400 4000
/dff59000\ Start thread
|dff59000| xhci_hub_reset port #3: 0x000202e1, powered, pls 7, speed 0 [ - ]
|dff5d000| set_address 0xdff616a0
/dff58000\ Start thread
|dff5e000| sdcard_set_frequency 50 200000 0
|dff5e000| host_control contains 0x00000f04
|dff5e000| Found sdcard at 0xfeb25500: SD card SD8GB 7600MiB
|dff5e000| Registering bootable: SD card SD8GB 7600MiB (type:2 prio:5 data:f14e0)
\dff5e000/ End thread
|dff5d000| config_usb: 0xdff57fd0
|dff5d000| device rev=0200 cls=09 sub=00 proto=01 size=64
/dff56000\ Start thread
/dff55000\ Start thread
/dff54000\ Start thread
/dff53000\ Start thread
**|dff59000| XHCI port #3: 0x00200e03, powered, enabled, pls 0, speed 3 [High]
**|dff59000| set_address 0xdffadfb0
|dff59000| xhci_alloc_pipe: usbdev 0xdff61130, ring 0xdffad900, slotid 0,epid 1
|dff59000| xhci_cmd_enable_slot:
|dff59000| xhci_process_events port #3: 0x00200e03, powered, enabled, pls 0, speed 3 [High]
|dff59000| xhci_process_events port #3: 0x00000e03, powered, enabled, pls 0, speed 3 [High]
|dff59000| xhci_alloc_pipe: enable slot: got slotid 1
|dff59000| xhci_cmd_address_device: slotid 1
dff5b000/ End thread
\dff58000/ End thread
\dff5a000/ End thread
\dff5c000/ End thread
dff53000/ End thread
\dff54000/ End thread
\dff55000/ End thread
\dff56000/ End thread
**|dff5d000| Initialized USB HUB (0 ports used)
\dff5d000/ End thread
\dff5f000/ End thread
****
dff59000| WARNING - Timeout at xhci_event_wait:701!
|dff59000| xhci_alloc_pipe: address device: failed (cc -1)
|dff59000| xhci_cmd_disable_slot: slotid 1
|dff59000| WARNING - Timeout at xhci_event_wait:701!
|dff59000| xhci_alloc_pipe: disable failed (cc -1)
\dff59000/ End thread
|dff60000| XHCI no devices found
dff60000| WARNING - Timeout at wait_bit:295!
****
\dff60000/ End thread
```
