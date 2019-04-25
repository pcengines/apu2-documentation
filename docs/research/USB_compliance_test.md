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



## Device detection process debugging

### USB device enumeration process

USB enumeration process lets a host determine if USB device was plugged into USB
port and what kind of device is that. Enumeration process could be divided into
multiple stages proceeded after previous one has no error:

  1. RxDetect mode (*USB 3.0 Specification Section 6.11*)
  2. Polling LFPS (*USB 3.0 Specification Section 6.9.2*)
  3. TSEQ Ordered Sets (*USB 3.0 Specification Section 6.4.1.1.3 and Table 6-3*)
  4. TS1 Ordered Sets (*USB 3.0 Specification Section 6.4.1.1.3 and Table 6-4*)
  5. TS2 Ordered Sets (*USB 3.0 Specification Section 6.4.1.1.3 and Table 6-5*)
  6. Logical idle (sending idle data)
  7. Exit Initialization to U0 state

  >NOTE: Link Initialization and Training (stages 3,4,5) could be different
  depending on USB 3.0 (Gen 1) or USB 3.1 (Gen 2) devices. More details are
  available in USB 3.0 Specification Section 6.4.

After last stage device should be recognized by host and communication between
them is opened. To test device detection in system it should be checked if all
above stages are performed correctly. Hence electrical compliance tests and link
layer tests should be performed to compare data, timing and electrical values
with Specification requirements.


### Link Training and Status State Machine (LTSSM)

Link Training and Status State Machine (LTSSM) is a state machine consists of 12
link states. It is described in *USB 3.0 Specification Section 7.5*. LTSSM
diagram is presented in figure 7.14. During USB device detection process LTSSM
changes stages according to diagram flow. To test if device detection process is
done correctly state machine analyze should be done.


## Compliance tests


### Compliance tests tools

>NOTE: Official USB-IF testing software is supported under Windows only.

USB Protocol Analyzer:

- [Ellisys USB Explorer 280](https://www.ellisys.com/products/usbex280/index.php)
- [Teledyne LeCroy Voyager M3x](https://teledynelecroy.com/protocolanalyzer/usb/voyager-m3x)
- [Beagle USB 5000 v2 SuperSpeed Protocol Analyzer](https://www.totalphase.com/products/beagle-usb5000-v2-ultimate/)

USB Protocol Analyzer Software:

- [Totalphase Data Center Software](https://www.totalphase.com/products/data-center/)
- [Virtual USB Analyzer](http://vusb-analyzer.sourceforge.net/)


### Electrical compliance tests

These tests verify that electrical signals send between host and device meet USB 3.0
criteria which are described in USB 3.0 Specification Document. All details
about tests are described in [Electrical Compliance Test Specification SuperSpeed Universal Serial Bus](https://www.usb.org/sites/default/files/SuperSpeedPHYComplianceTest_Spec1_0a.pdf).

Should be considered to carry out those tests:

- TD.1.1 Low Frequency Periodic Signaling TX Test

- TD.1.2 Low Frequency Periodic Signaling RX Test

- TD.1.3 Transmitted Eye Test


### Link layer compliance tests

These tests verify that data sends between host and device meets requirements
described in USB 3.0 Specification. Especially, if detection process is done
correctly i.e. no data packets missing, states are proceed in exact way, no
errors between stages etc. All tests with details are described in [USB 3.1 Link Layer Test Specification](https://www.usb.org/sites/default/files/USB_3_1_Link_Layer_Test_Specification_2018_01_02.pdf)

Should be considered to carry out those tests:

- Link Initialization Sequence

### State machine compliance tests
