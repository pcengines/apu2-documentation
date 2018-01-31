# apu2 USB xHCi debugging

## SeaBIOS debug output

The first step was to analyze verbose output on SeaBIOS. The minimal necessary
debug level is 5 to get the xHCI verbosity.

The first thing which can be noticed is:

```
|cff49000| xhci_process_events port #2: 0x00021203, powered, enabled, pls 0, speed 4 [Super]
|cff49000| WARNING - Timeout at xhci_event_wait:743!
|cff49000| xhci_alloc_pipe: address device: failed (cc -1)
|cff49000| xhci_cmd_disable_slot: slotid 1
|cff49000| xhci_trb_queue: ring 0xcff9ed00 [nidx 3, len 0]
|cff49000| xhci_doorbell: slotid 0, epid 0
|cff49000| WARNING - Timeout at xhci_event_wait:743!
|cff49000| xhci_alloc_pipe: disable failed (cc -1)
```

According to xHCI specification, the proper initialization procedure is as
follows:

1. Reset the device on the hub
2. Perform enable slot
3. Send adress device command
4. Configure the device

As seen above in the log, adress command fails with timeout. After adjusting
the timeouts to get rid of these problems:

```
|cff47000| XHCI port #2: 0x00001203, powered, enabled, pls 0, speed 4 [Super]
|cff47000| set_address 0xcff9efb0
|cff47000| xhci_alloc_pipe: usbdev 0xcff4dc60, ring 0xcff9e200, slotid 0, epid 1
|cff47000| xhci_cmd_enable_slot:
|cff47000| xhci_trb_queue: ring 0xcff9ed00 [nidx 7, len 0]
|cff47000| xhci_doorbell: slotid 0, epid 0
|cff47000| xhci_process_events: ring 0xcff9ed00 [trb 0xcff9ed60, evt 0xcff9ee00, type 33, eidx 7, cc 1]
|cff47000| xhci_alloc_pipe: enable slot: got slotid 2
|cff47000| xhci_cmd_address_device: slotid 2
|cff47000| xhci_trb_queue: ring 0xcff9ed00 [nidx 8, len 0]
|cff47000| xhci_doorbell: slotid 0, epid 0
|cff47000| xhci_process_events: ring 0xcff9ed00 [trb 0xcff9ed70, evt 0xcff9ee00, type 33, eidx 8, cc 4]
|cff47000| xhci_alloc_pipe: address device: failed (cc 4)
|cff47000| xhci_cmd_disable_slot: slotid 2
|cff47000| xhci_trb_queue: ring 0xcff9ed00 [nidx 9, len 0]
|cff47000| xhci_doorbell: slotid 0, epid 0
|cff47000| xhci_process_events: ring 0xcff9ed00 [trb 0xcff9ed80, evt 0xcff9ee00, type 33, eidx 9, cc 1]
```

This time the address command returned status 4 which stands for Transaction
Error.

xHCI [specification](https://www.intel.com/content/dam/www/public/us/en/documents/technical-specifications/extensible-host-controler-interface-usb-xhci.pdf) says:

```
If the SET_ADDRESS request was unsuccessful, system software may issue a
Disable Slot Command for the slot or reset the device and attempt the Address
Device Command again. An unsuccessful Address Device Command shall leave
the Device Slot in the Default state.

A USB Transaction Error Completion Code for an Address Device Command may
be due to a Stall response from a device. Software should issue a Disable Slot
Command for the Device Slot then an Enable Slot Command to recover from this
error.
```

Tried both approaches without success. The result is the same, device
respond with Transaction Error (`cc 4`).

## USB protocol 3.0 vs 3.1

I have accidentally discovered that some sticks are properly detected regardless
of the warmboot or coldboot. I started wondering what is the difference between
them (price, quality?). So I had two different sticks:

```
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x0951 Kingston Technology
  idProduct          0x1666
  bcdDevice            0.01
  iManufacturer           1 Kingston
  iProduct                2 DataTraveler 3.0
  iSerial                 3 60A44C4252A8F17059930048
  bNumConfigurations      1
```

```
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x054c Sony Corp.
  idProduct          0x09c2
  bcdDevice            1.10
  iManufacturer           1 Sony
  iProduct                2 Storage Media
  iSerial                 3 5C0710618C3915CF56
  bNumConfigurations      1
```

The one that had problem with detection in SeaBIOS is Kingston which supports
USB 3.1 protocol. On the contrary the Sony stick was always detected and
supports USB 3.0 protocol.

Although USB 3.1 should be back-compatible with USB 3.0, I have dug a little bit
into the changes between 3.0 and 3.1 and found that:

```
USB 3.1 brings changes in every layer for both the host and device, including
hubs that are in-between. But one of the ideas in USB 3.1 is to not require
changes to the software, so a hardware-based, enhanced SuperSpeed device
notification mechanism was introduced so that devices can communicate with hosts
at a lower layer and report that they are operating at this higher rate. New
SuperSpeedPlus host controllers must utilize this extra bandwidth without
requiring changes to the existing host drivers.

The higher frequency involved with the 10 Gbps data rate means that there is a
good chance that system designers will need to include repeaters. If the host or
device loss is greater than 7dB at 5GHz, a repeater may be necessary on both the
host and the device to travel across the cable.

SuperSpeed posed a problem because a single bit error could cause the link to go
into recovery in two cases: with skip ordered sets or with start link commands.
This caused an error rate of up to 5.7^-15.

USB 3.1 introduces a new start-up speed negotiation protocol. The goal of this
protocol is to get the link up to the highest rate supported by both devices.
The way this works is that it uses the low frequency periodic signal (LFPS) that
was introduced in USB 3.0 and it changes it slightly to turn into a pulse width
modulation message, called the LFPS-Based PWM Messaging (LBPM).
```

That made me a hint, what if USB 3.1 memsticks respond in a slightly different
way causing SeaBIOS to fail to initialize them?

Another test I did was coldboot tests. I have noticed that USB 3.1 stick was
detected properly after coldbooting the platform in 1 minute interval. That
leads to a conclusion that some capacitance or even impedance is making the
device respone stall (as xHCI spec says). Comparing the temperture of stick
connectors I also noticed that 3.1 stick emits much more heat than 3.0 stick.
This can have significant impact on the electrical characteristics of the hub.

Another thing that is worth mentioning is that SeaBIOS recognizes only two types
of USB protocol on xHCI, 3.0 and 2.0:

```
XHCI init on dev 00:10.0: regs @ 0xf7f22000, 4 ports, 32 slots, 32 byte contexts
XHCI    extcap 0x1 @ 0xf7f22500
XHCI    protocol USB  3.00, 2 ports (offset 1), def 0
XHCI    protocol USB  2.00, 2 ports (offset 3), def 10
XHCI    extcap 0xa @ 0xf7f22540
```

Unfortunately these aspects need much more investigation with many more
different USB sticks 3.0 and 3.1.

Another problem is I have no idea why the Transaction Error code is received (no
possibility to look at the lwo level signals on the USB lines). What does xHCI
spec mean by stall? To answer that question, maybe much more specialized
hardware and tools would be required.

## Test results

I have run a RF test on the USB 3.0 stick and it survived 50 coldboots.
The interval between relay switching was 5 seconds on coldboots. It could not
pass the warmboot test, although it survived only 7 cycles (still better than
0 cycles in case of USB 3.1).

The same test on the USB3.1 stick did not pass the 50 warmboots. I achieved
a pass on coldboots when I was waiting between relay switches for 30 seconds.
That leads to conclusion that the platform needs to "cool down" before it will
attempt to initialize USB 3.1 stick (maybe some capacitance discharging or
wire impedance fall because of the temperature fall).

