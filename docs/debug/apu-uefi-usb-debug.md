APU4 USB problems
=================

Recently an issue with xHCi has been discovered. When 2x USB 3.x sticks are
plugged in front USB connector on apu4, one port does not recognize the stick.
We have been reported that on some boards the top port is defective or the
bottom one (board dependent).

We have confirmed that some board are affected, but also some boards do not show
such behaviour. Also different versions of firmwares (v4.6.4 and v4.6.7) give
different results (sometimes affected boards starts working properly and good
board starts to behave bad). Changing debug level on the same version also
affects detectability of USB sticks (SeaBIOS and/or coreboot debug as well).

## Table of contents

- [Table of contents](#table-of-contents)
- [Experiment conditions](#experiment-conditions)
- [SeaBIOS](#seabios)
- [Tianocore UEFI payload](#tianocore-uefi-payload)

## Experiment conditions:

- coreboot version: v4.6.7
- SeaBIOS 1.11.0.3
- tianocore payload built from 3mdeb/edk2 repo
- apu4a and apu4b boards
- 2x Kingston USB 3.0 stick with identical content (PC Engines tinycore linux)

```
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x0951 Kingston Technology
  idProduct          0x1666
  bcdDevice            1.10
  iManufacturer           1 Kingston
  iProduct                2 DataTraveler 3.0
  iSerial                 3 0015F284C2ADB04189554426
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           44
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              126mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000006
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   2
      Lowest fully-functional device speed is High Speed (480Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
Device Status:     0x0000
  (Bus Powered)
```

## SeaBIOS

Looking at verbose log from SeaBIOS payload only thing we can observe two
attention worthy differences between good and bad board:

1. XHCI port reset yields timeout for each well detected USB stick

- good board:

```
/cff49000\ Start thread
|cff49000| xhci_hub_reset port #3: 0x000202e1, powered, pls 7, speed 0 [ - ]
...
|cff49000| WARNING - Timeout at wait_bit:302!
|cff49000| phys_free cff4de30 (detail=0xcff4de00)
\cff49000/ End thread

...
/cff48000\ Start thread
...
|cff48000| xhci_hub_reset port #4: 0x000002e1, powered, pls 7, speed 0 [ - ]
...
|cff48000| WARNING - Timeout at wait_bit:302!
|cff48000| phys_free cff4ffe0 (detail=0xcff4ff50)
\cff48000/ End thread
```

- bad board:

```
/cff48000\ Start thread
|cff48000| xhci_hub_reset port #3: 0x000202e1, powered, pls 7, speed 0 [ - ]
...
|cff48000| WARNING - Timeout at wait_bit:302!
|cff48000| phys_free cff520a0 (detail=0xcff4ffd0)
\cff48000/ End thread
```

2. Event processing after slot enable command gives different number of active
ports:

- good board:

```
|cff4c000| xhci_process_events port #3: 0x002202a0, powered, pls 5, speed 0 [ - ]
|cff4c000| xhci_process_events port #4: 0x000202e1, powered, pls 7, speed 0 [ - ]
|cff4c000| xhci_process_events port #3: 0x000002a0, powered, pls 5, speed 0 [ - ]
|cff4c000| xhci_process_events port #1: 0x00021203, powered, enabled, pls 0, speed 4 [Super]
```

- bad board:

```
|cff4c000| xhci_process_events port #3: 0x002202a0, powered, pls 5, speed 0 [ - ]
|cff4c000| xhci_process_events port #3: 0x000002a0, powered, pls 5, speed 0 [ - ]
|cff4c000| xhci_process_events port #1: 0x00021203, powered, enabled, pls 0, speed 4 [Super]
```

It looks like hub reset and slot enable are not performed correctly or some
electric issue causes it to fail. This problem is reproducible regardles of boot
method (coldboot, warmboot, reboot reset, etc.). Only changing coreboot version
and/or debug level changes the situation.

## Tianocore UEFI payload

Previous investigation lead us to a hypothesis that the problem lies in timings.
To prove that we decided to try UEFI payload built from edk2 with coreboot pkg.
Unfortunately result is the same. however board that did not work behaves good
now and vice versa (like a random thing).

Comparing logs from good and bad board, the main differences are:

1. During driver loading, some weird binary output leaks to serial console:

- good board:

```
PROGRESS CODE: V03040002 I0
InstallProtocolInterface: 03583FF6-CB36-4940-947E-B9B39F4AFAF7 CFC2F0A8
PROGRESS CODE: V03040003 I0
Loading driver D3987D4B-971A-435F-8CAF-4967EB627241
InstallProtocolInterface: 5B1B31A1-9562-11D2-8E3F-00A0C969723B CFC58228
Loading driver at 0x000CFC3D000 EntryPoint=0x000CFC3D6F3 SerialDxe.efi
InstallProtocolInterface: BC62157E-3E33-4FEC-9920-2D3B36D750DF CFC58810
ProtectUefiImageCommon - 0xCFC58228
  - 0x00000000CFC3D000 - 0x0000000000002300
PROGRESS CODE: Vp&LM\98\9802 I0   		<--- note here
InstallProtocolInterface: BB25CF6F-F1D4-11D2-9A0C-0090273FC1FD CFC3EF40
InstallProtocolInterface: 09576E91-6D3F-11D2-8E39-00A0C969723B CFC3EFA0
PROGRESS CODE: V03040003 I0
Loading driver 6D33944A-EC75-4855-A54D-809C75241F6C
InstallProtocolInterface: 5B1B31A1-9562-11D2-8E3F-00A0C969723B CFC45028
Loading driver at 0x000CFC02000 EntryPoint=0x000CFC0EA97 BdsDxe.efi
InstallProtocolInterface: BC62157E-3E33-4FEC-9920-2D3B36D750DF CFC45D10
ProtectUefiImageCommon - 0xCFC45028
  - 0x00000000CFC02000 - 0x0000000000014FC0
PROGRESS CODE: V03040002 I0
InstallProtocolInterface: 665E3FF6-46CC-11D4-9A38-0090273FC14D CFC1588C
PROGRESS CODE: V03040003 I0
```

- bad board

```
PROGRESS CODE: V03040002 I0
InstallProtocolInterface: 03583FF6-CB36-4940-947E-B9B39F4AFAF7 CFC2F0A8
PROGRESS CODE: V03040003 I0
Loading driver D3987D4B-971A-435F-8CAF-4967EB627241
InstallProtocolInterface: 5B1B31A1-9562-11D2-8E3F-00A0C969723B CFC58228
Loading driver at 0x000CFC3D000 EntryPoint=0x000CFC3D6F3 SerialDxe.efi
InstallProtocolInterface: BC62157E-3E33-4FEC-9920-2D3B36D750DF CFC58810
ProtectUefiImageCommon - 0xCFC58228
  - 0x00000000CFC3D000 - 0x0000000000002300
PROGRESS CODE: V03040002 I0				<--- note here
InstallProtocolInterface: BB25CF6F-F1D4-11D2-9A0C-0090273FC1FD CFC3EF40
InstallProtocolInterface: 09576E91-6D3F-11D2-8E39-00A0C969723B CFC3EFA0
PROGRESS CODE: V03040003 I0
Loading driver 6D33944A-EC75-4855-A54D-809C75241F6C
InstallProtocolInterface: 5B1B31A1-9562-11D2-8E3F-00A0C969723B CFC45028
Loading driver at 0x000CFC02000 EntryPoint=0x000CFC0EA97 BdsDxe.efi
InstallProtocolInterface: BC62157E-3E33-4FEC-9920-2D3B36D750DF CFC45D10
ProtectUefiImageCommon - 0xCFC45028
  - 0x00000000CFC02000 - 0x0000000000014FC0
PROGRESS CODE: V03040002 I0
InstallProtocolInterface: 665E3FF6-46CC-11D4-9A38-0090273FC14D CFC1588C
PROGRESS CODE: V03040003 I0
```

2. During USB init, port enumeration and reset is not performed on the defected port:


- good board (ports reset and enumerated 0, 1, 2, 3):

```
XhcResetHC!
XhcInitSched:DCBAA=0xCF898000
XhcInitSched: Created CMD ring [CF898140~CF899140) EVENT ring [CF899140~CF89B140)
XhcDriverBindingStart: XHCI started for controller @ CF94F710
XhcGetCapability: 4 ports, 64 bit 1
UsbRootHubInit: root hub CF897C90 - max speed 3, 4 ports
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 2 state - 01, change - 01 on CF897C90   <-- note here
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 2
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcSetRootHubPortFeature: status Success
UsbEnumerateNewDev: hub port 2 is reset				<-- note here
UsbEnumerateNewDev: No device present at port 2
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 3 state - 01, change - 01 on CF897C90
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 3
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcSetRootHubPortFeature: status Success
UsbEnumerateNewDev: hub port 3 is reset
UsbEnumerateNewDev: No device present at port 3
UsbBusStart: usb bus started on CF94F710, root hub CF897C90
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 0 state - 803, change - 01 on CF897C90
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 0
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
Enable Slot Successfully, The Slot ID = 0x1
    Address 1 assigned successfully
UsbEnumerateNewDev: hub port 0 is reset				<-- note here
UsbEnumerateNewDev: device is of 3 speed
UsbEnumerateNewDev: device uses translator (0, 0)
UsbEnumerateNewDev: device is now ADDRESSED at 1
UsbEnumerateNewDev: max packet size for EP 0 is 512
Evaluate context
UsbBuildDescTable: device has 1 configures
UsbGetOneConfig: total length is 44
UsbParseConfigDesc: config 1 has 1 interfaces
UsbParseInterfaceDesc: interface 0(setting 0) has 2 endpoints
Endpoint[81]: Created BULK ring [CF89C9C0~CF89D9C0)
Endpoint[2]: Created BULK ring [CF89D9C0~CF89E9C0)
Configure Endpoint
UsbEnumerateNewDev: device 1 is now in CONFIGED state
UsbSelectConfig: config 1 selected for device 1
UsbSelectSetting: setting 0 selected for interface 0
UsbConnectDriver: TPL before connect is 8, CF892A90
UsbConnectDriver: TPL after connect is 8
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 1 state - 803, change - 01 on CF897C90
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 1
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
Enable Slot Successfully, The Slot ID = 0x2
    Address 2 assigned successfully
UsbEnumerateNewDev: hub port 1 is reset
UsbEnumerateNewDev: device is of 3 speed
UsbEnumerateNewDev: device uses translator (0, 0)
UsbEnumerateNewDev: device is now ADDRESSED at 2
UsbEnumerateNewDev: max packet size for EP 0 is 512
Evaluate context
UsbBuildDescTable: device has 1 configures
UsbGetOneConfig: total length is 44
UsbParseConfigDesc: config 1 has 1 interfaces
UsbParseInterfaceDesc: interface 0(setting 0) has 2 endpoints
Endpoint[81]: Created BULK ring [CF8A0200~CF8A1200)
Endpoint[2]: Created BULK ring [CF8A1200~CF8A2200)
Configure Endpoint
UsbEnumerateNewDev: device 2 is now in CONFIGED state
UsbSelectConfig: config 1 selected for device 2
UsbSelectSetting: setting 0 selected for interface 0
UsbConnectDriver: TPL before connect is 8, CF87FC10
UsbConnectDriver: TPL after connect is 8

```

- bad board (ports enumerated 1, 3):

```
XhcResetHC!
XhcInitSched:DCBAA=0xCF898000
XhcInitSched: Created CMD ring [CF898140~CF899140) EVENT ring [CF899140~CF89B140)
XhcDriverBindingStart: XHCI started for controller @ CF94F710
XhcGetCapability: 4 ports, 64 bit 1
UsbRootHubInit: root hub CF897C90 - max speed 3, 4 ports
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 3 state - 01, change - 01 on CF897C90
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 3
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcSetRootHubPortFeature: status Success
UsbEnumerateNewDev: hub port 3 is reset
UsbEnumerateNewDev: No device present at port 3
UsbBusStart: usb bus started on CF94F710, root hub CF897C90
XhcClearRootHubPortFeature: status Success
UsbEnumeratePort: port 1 state - 803, change - 01 on CF897C90
UsbEnumeratePort: Device Connect/Disconnect Normally
UsbEnumeratePort: new device connected at port 1
XhcUsbPortReset!
XhcSetRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
XhcClearRootHubPortFeature: status Success
Enable Slot Successfully, The Slot ID = 0x1
    Address 1 assigned successfully
UsbEnumerateNewDev: hub port 1 is reset
UsbEnumerateNewDev: device is of 3 speed
UsbEnumerateNewDev: device uses translator (0, 0)
UsbEnumerateNewDev: device is now ADDRESSED at 1
UsbEnumerateNewDev: max packet size for EP 0 is 512
Evaluate context
UsbBuildDescTable: device has 1 configures
UsbGetOneConfig: total length is 44
UsbParseConfigDesc: config 1 has 1 interfaces
UsbParseInterfaceDesc: interface 0(setting 0) has 2 endpoints
Endpoint[81]: Created BULK ring [CF89C9C0~CF89D9C0)
Endpoint[2]: Created BULK ring [CF89D9C0~CF89E9C0)
Configure Endpoint
UsbEnumerateNewDev: device 1 is now in CONFIGED state
UsbSelectConfig: config 1 selected for device 1
UsbSelectSetting: setting 0 selected for interface 0
UsbConnectDriver: TPL before connect is 8, CF892890
UsbConnectDriver: TPL after connect is 8
```

Defected board log shows that even if XHCI capability says 4 ports, they are not
reset and enumerated as if there was no device attached. After platform boots
UEFI shell is launched printing the device mapping:

- good board:

```
Device mapping table
  fs0     :Removable HardDisk - Alias hd14a0b blk0
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  fs1     :Removable HardDisk - Alias hd14b0b blk1
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x1,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  blk0    :Removable HardDisk - Alias hd14a0b fs0
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  blk1    :Removable HardDisk - Alias hd14b0b fs1
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x1,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  blk2    :Removable BlockDevice - Alias (null)
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)
  blk3    :Removable BlockDevice - Alias (null)
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x1,0x0)
```

We can observe here two different USB devices: `USB(0x1,0x0)` and `USB(0x0,0x0)`

- bad board:

```
Device mapping table
  fs0     :Removable HardDisk - Alias hd14a0b blk0
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  blk0    :Removable HardDisk - Alias hd14a0b fs0
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)/HD(1,MBR,0x21FFED75,0x800,0x111800)
  blk1    :Removable BlockDevice - Alias (null)
           PciRoot(0x0)/Pci(0x10,0x0)/USB(0x0,0x0)
```

Only 1 USB device is detected: `USB(0x0,0x0)`