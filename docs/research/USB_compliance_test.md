# USB compliance tests

This document contains research about USB tests compliance which allow to
analyze USB device detection process. Mostly it references to USB 3.0.

## Related documents

- [Universal Serial Bus 3.0 Specification](https://www.usb.org/document-library/usb-32-specification-released-september-22-2017-and-ecns)
- [USB 3.0 Electrical Compliance Test Specification](https://www.usb.org/sites/default/files/SuperSpeedPHYComplianceTest_Spec1_0a.pdf)
- [USB 3.1 Link Layer Test Specification](https://www.usb.org/sites/default/files/USB_3_1_Link_Layer_Test_Specification_2018_01_02.pdf)
- [USB 3.0 Electrical Test Fixture Topologies](https://www.usb.org/sites/default/files/documents/superspeedtesttopologies.pdf)
- [Universal Serial Bus 2.0 Specification](https://www.usb.org/document-library/usb-20-specification)
- [USB 2.0 Electrical Compliance Tests Specification](https://www.usb.org/document-library/usb-20-electrical-compliance-test-specification-version-107)
- [eXtensible Host Controller Interface for Universal Serial Bus](https://www.intel.com/content/dam/www/public/us/en/documents/technical-specifications/extensible-host-controler-interface-usb-xhci.pdf)


## List of abbreviations

- `HS` - High Speed USB (USB 2.0)
- `SS` - Super Speed USB (USB 3.0)
- `LFPS` - Low Frequency Periodic Signaling
- `LTSSM` - Link Training and Status State Machine


### USB Standards comparison

|                   |   Power   |  Speed  | PHY Layer                           
| ----------------- |:---------:|:-------:|:-----------------------------------:
|USB 1.1 Low Speed  | 5V @500mA | 1,5 Mbps| VCC, GND, D+, D-                    
|USB 1.1 Full Speed | 5V @500mA | 12 Mbps | VCC, GND, D+, D-                     
|USB 2.0 High Speed | 5V @500mA | 480 Mbps| VCC, GND, D+, D-                     
|USB 3.0 SuperSpeed | 5V @900mA |  5 Gbps | VCC, GND, D+, D-, Rx+, Rx-, Tx+, Tx-
|USB 3.1 SuperSpeed+| 5V @900mA | 10 Gbps | VCC, GND, D+, D-, Rx+, Rx-, Tx+, Tx-


## Device detection process debugging

#### USB 3.0 device enumeration process

USB enumeration process lets a host determine if USB device was plugged into USB
port and what kind of device is that. Enumeration process could be divided into
multiple stages proceeded after previous one if there were no errors:

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
with Specification requirements (tables with reference values are available in
Specification under mentioned above sections which corresponds to specific
stage).


#### Link Training and Status State Machine (LTSSM) in USB 3.0

Link Training and Status State Machine (LTSSM) is a state machine consists of 12
link states. It is described in *USB 3.0 Specification Section 7.5*. LTSSM
diagram is presented in figure 7.14. During USB device detection process LTSSM
changes stages according to diagram flow. To test if device detection process is
done correctly state machine analyze should be done.


## Compliance tests

### USB 3.0 testing

#### Electrical compliance tests

Electrical compliance tests verify that electrical signals sent between host and
device meet USB 3.0 requirements which are described in USB 3.0 Specification
Document. To correctly capture these data high-class oscilloscope is required
(with minimum 13 GHz bandwidth) with high-class cables and probes. Also Test
Fixtures are needed to separate signals from USB data lines and dedicated
software installed on oscilloscope.

Proposed tool kit:
- Teledyne LeCroy SDA 813Zi-A Oscilloscope
- QualiPHY Software
- SigTest software v.3.2.1
- TF-USB3 Test Fixture
- SMA cables
- PeRT3 Phoenix System (for Receiver tests)

>All tools are listed in [QPHY-USB3.2-TX-RX Manual](http://cdn.teledynelecroy.com/files/manuals/qphy-usb3.1-tx-operators-manual.pdf)
in section Introduction/Required Equipment. That document contains also guide
how to perform electrical tests with QualiPHY Software.

From [QPHY-USB3.2-TX-RX Manual](http://cdn.teledynelecroy.com/files/manuals/qphy-usb3.1-tx-operators-manual.pdf)
those tests should be carried out:
- in section *USB 3.1/3.2 Transmitter Testing*:
  - TD 1.1 Low Frequency Periodic Signaling Test
  - TD 1.6 Spread Spectrum Test
- in section *USB 3.1/3.2 Transmitter Testing*:
  - TD 1.2 Low Frequency Periodic Signaling Test
  - TD 1.8 and 1.9 Receiver Jitter Tolerance Tests


>Electrical compliance tests tool kit is rather expensive and those tests don't
guaranty that stick detection problem will be resolved. My advice is to first
carry out link layer tests because they can give more information and benefits
about problem.

Proposed tests are compatible with USB-IF official Electrical Compliance Tests
Program. All tests are listed in [Electrical Compliance Test Specification SuperSpeed Universal Serial Bus](https://www.usb.org/sites/default/files/SuperSpeedPHYComplianceTest_Spec1_0a.pdf).


#### Link layer compliance tests

Link layer compliance tests can be performed with USB Analyzers. USB Analyzers
capture USB traffic and with dedicated software it is possible to find and
resolve problems caused by errors in link layer during enumeration process, i.e.
data packets missing, states are not proceed in exact way, errors between
process stages etc.

Examples of USB 3.0 Analyzers with dedicated software:
- Beagle USB 5000 v2 SuperSpeed Protocol Analyzer | Data Center Software
- Ellisys Explorer 280 | Analyzer Software
- Teledyne LeCroy Advisor T3 | USB Protocol Suite
- Teledyne LeCroy Voyager M3 | USB Protocol Suite

>NOTE: From mentioned above analyzers only Beagle USB 5000's software is
supported on Linux. Another ones are supported only in Windows.

Should be considered to carry out tests:
- analyze LFPS at communication initialization
- analyze Training Sequences TSEQ, TS1, TS2 Ordered Sets
- analyze State Machine (check if states proceed according to Specification)
- checking if USB Port/Device ends in U0 mode
- checking packets between host and recognized device

>USB-IF has its own Link Layer Compliance Tests program. However, to carry out
those tests it is required to use their hardware and software tools. In my
opinion, good enough alternative is to use one of mentioned above devices,
because they have features which are sufficient to resolve stick detection
problems.

If mentioned above analyses aren't sufficient, tests from sections 7.5.1 to
7.5.5 from [USB 3.1 Link Layer Test Specification](https://www.usb.org/sites/default/files/USB_3_1_Link_Layer_Test_Specification_2018_01_02.pdf)
can be performed.


## Additional conclusions

#### USB 3.0 analyze

Mentioned above equipment is necessary to carry out electrical and link layer
tests. Due to its high price it's rather impossible to perform such tests now.
So far I couldn't find any alternate solutions which will meet the requirements
and will be low-price devices. It results from the fact, that to test USB 3.0
protocol, high frequency devices are needed and such devices are rather
expensive. Most of available instruments are suitable only for USB 2.0 testing.

#### USB 2.0 analyze

USB 2.0 Analyzer's principles of operation is exactly the same as USB 3.0
Analyzer and it is described above in that document.

Proposed USB 2.0 Analyzers with dedicated software:
- OpenVizsla | Wireshark
- Beagle USB 480 | Data Center Software

Both analyzers are perfectly good to capture and investigate USB data. However,
OpenVizsla is an open-source solution which can easily handle with USB analysis
within low price. In combination with Wireshark (or any other program which can
descramble USB data) it doesn't stand out from any other available solutions. On
the other hand, Beagle's software has feature which analyze state machine and
show current state in LTSSM.

>Those devices can't be extended to analyze USB 3.0/3.1 transmission.

#### RxDetect state

Detailed description of `RxDetect` machine state (with substates) is available
in Section 7.5.3 in USB 3.0 Specification.

Initially USB ports are in `SS.Disabled` state (SuperSpeed connection is cut
off). `RxDetect` state (in fact `RxDetect.Reset`) is reached after Power On
Reset or Directed Warm Reset.

Let's look how machine substate sequence looks like depending on scenarios:

- RxDetect.Reset

  If it was reached by power on reset it transit directly to `RxDetect.Active`.

  If it was reached by warm reset it transmits LFPS sequence (warm reset
  sequence) and goes to `RxDetect.Active`.

- RxDetect.Active

  In this state receiver termination (detecting termination at line) is
  performed. If it is detected (USB 3.0 device is at the end) then
  `Polling.LFPS` state is reached. If it is not detected then `RxDetect.Quiet`
  state is reached and after 12ms it gets back to `RxDetect.Active` state and
  try procedure again. It can move to `RxDetect.Quiet` state only 8 times in a
  row. Next time if no termination is detected it goes to `SS.Disabled`.

- RxDetect.Quiet

  Wait 12 ms timeout and go to `RxDetect.Active` state.

Maybe the problem with USB 3.0 stick detection is caused by not detecting Rx
termination for 8 times in a row. Host will not get back to detecting USB 3.x
device no more and will start procedure of detecting USB 2.0 device.
