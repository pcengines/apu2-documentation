# USB compliance tests

This document contains research about USB tests compliance which allow to
analyze USB device detection process. Mostly it references to USB 3.0.

## Related documents

- [Universal Serial Bus 3.0 Specification, Revision 1.0](https://www.usb.org/document-library/usb-32-specification-released-september-22-2017-and-ecns)
- [Electrical Compliance Test Specification SuperSpeed Universal Serial Bus](https://www.usb.org/sites/default/files/SuperSpeedPHYComplianceTest_Spec1_0a.pdf)
- [Universal Serial Bus 3.1 Link Layer Test Specification](https://www.usb.org/sites/default/files/USB_3_1_Link_Layer_Test_Specification_2018_01_02.pdf)
- [USB 3.0 Electrical Test Fixture Topologies](https://www.usb.org/sites/default/files/documents/superspeedtesttopologies.pdf)


## List of abbreviations

- `LS` - Low Speed USB (USB 1.0)
- `FS` - Full Speed USB (USB 1.1)
- `HS` - High Speed USB (USB 2.0)
- `SS` - Super Speed USB (USB 3.0)
- `LFPS` - Low Frequency Periodic Signaling
- `DUT` - Device Under Test


### Important differences between USB 3.0 and USB 2.0

|               | Power         | Speed   | PHY Layer                           
| ------------- |:-------------:|:-------:|:-----------------------------------:
| USB 2.0       | 5V @500mA     | 480 Mbps| VCC, GND, D+, D-                         
| USB 3.0       | 5V @900mA     |  5Gbps  | VCC, GND, D+, D-, Rx+, Rx-, Tx+, Tx-


### USB device enumeration process

USB enumeration process lets a host determine if USB device was plugged into USB
port and what kind of device is that. Enumeration process consists of 3 stages:

1. Device detection
2. Device identification
3. Device driver load


### Device detection process

During that process host detects connected device and establish speed of
communication (LS, FS, HS or SS).

>NOTE: If host's port can operate as USB 3.0, first *SS device detection
process* is performed. Only if it's failed host go to *FS/HS device detection
process*


#### SS device detection process

Tx+/Tx- and Rx+/Rx- lines are connected between host and device. Now, host can
initialize device detection process.

1. Receiver detect (Rx.Detect)

  The Rx detection operates on the principle of the RC time constant of the
  circuit. This time constant changes based on the presence of the receiver
  termination. Host starts changing common mode voltage on Tx+ and Tx-. If time
  constant differs from 'open' line time constant it means that there is device
  connected to Tx host's lines. Host can proceed to the next stage.

  >NOTE: This stage with all details (including voltage levels, impedances,
  resistances etc.) is described in section *6.11 Receiver Detection* in USB 3.0
  Specification.   


2. LFPS handshake (Polling.LFPS)

  Host starts sending LFPS on its Tx lines and waits for device's response. At
  the same time (but independently on host) the device is starting its own
  Rx.Detect procedure. If termination is detected by device, it starts its own
  Polling.LFPS signaling. If host detects LFPS signal from device in
  appropriately short time (timing is defined in table 6-21 in USB 3.0
  Specification) host and device move to next stage - link training sequence.

  >NOTE: The timeout response for Polling.LFPS is 360ms. Device must response in
  that time.

  >NOTE: Detailed description with all reference values and figures is in
  section *6.9 Low Frequency Periodic Signaling (LFPS)* in USB 3.0
  Specification.


3. Link training sequence



#### FS/HS device detection process

USB host port with no devices connected uses 15kohm pull-down resistors to
connect both D+ and D- to GND. When a stick is plugged into a port, the
resistance on data lines is changed with pull-up resistors:

- LS device use 1k5ohm resistor between VCC and D-
- FS device use 1k5ohm resistor between VCC and D+
- HS device initially appears as FS to host


## Compliance tests

### Compliance tests tools

- [USB3CV](https://www.usb.org/document-library/usb3cvx64-tool-ver-21110)

  This tool is used to test a USB products control messaging, descriptors and
  basic protocol when connected to an xHCI controller. This tool takes control
  over the USB host controller and renders all products connected to it unusable

- [SigTest Tool](https://www.intel.com/content/www/us/en/design/technology/high-speed-io/tools.html?grouping=rdc%20Content%20Types&sort=title:asc)

  SigTest is tool for SuperSpeed USB transmitter voltage, LFPS, and Signal
  Quality electrical compliance testing as well as for calibrating SuperSpeed
  receiver test solutions

- [USB 3.1 USB Electrical Test Fixture Kit](https://www.usb.org/estore)


#### Electrical compliance tests

These tests verify that electrical signals between host and device meet USB 3.0
criteria which are described in USB 3.0 Specification Document. All details
about tests are described in [Electrical Compliance Test Specification SuperSpeed Universal Serial Bus](https://www.usb.org/sites/default/files/SuperSpeedPHYComplianceTest_Spec1_0a.pdf).


- LFPS Tx Test

  This test verifies that the low frequency periodic signal transmitter meets
  the timing requirements when measured at the compliance test port.

- LFPS Rx Tests

  This test verifies that the DUT low frequency periodic signal receiver
  recognizes LFPS signaling with voltage swings and duty cycles that are at the
  limits of what the specification allows.

- Transmitted Eye Test

- Transmitted SSC Profile Test

- Receiver Jitter Tolerance Test

#### Link layer compliance tests

- Link Initialization Sequence
