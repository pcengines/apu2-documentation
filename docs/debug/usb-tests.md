USB tests
=========

Tested 3 sticks:

1. [Intenso](usb-sticks.md#intenso) x2
2. [Kingston Data Traveler](usb-sticks.md#kingston-data-traveler)

Tested coreboot v4.6.4 with SeaBIOS 1.11.0.3:

50x coldboots USB detection
50x warmboots USB detection
50x boot Voyage Linux 0.11 and reboot USB detection

| Stick no. | Coldboot | Warmboot | Reboot |
|-----------|----------|----------|--------|
|     1     |   PASS   |   PASS   |  PASS  |
|     2     |   PASS   |   PASS   |  PASS  |



Tested coreboot v4.0.14 with SeaBIOS 1.11.0.3:

50x coldboots USB detection
50x warmboots USB detection
50x boot Voyage Linux 0.11 and reboot USB detection

| Stick no. | Coldboot | Warmboot | Reboot |
|-----------|----------|----------|--------|
|     1     |   PASS   |   PASS   |  PASS  |
|     2     |   PASS   |   PASS   |  PASS  |


Other results of not-working sticks are presented in this
[document](https://github.com/pcengines/apu2-documentation/blob/master/docs/debug/usb-debugging.md)


# Next test iteration

Test date: 29.05.2018
Firmware version: v4.6.9
Platforms:

1. apu4a S/N: WN1142383_1708
2. apu4a S/N: WN1142380_1708

Sticks:

1. [Corsair Voyager Vega](usb-sticks.md#corsair-voyager-vega)
2. [ADATA DashDrive UV131](usb-sticks.md#adata-dashdrive-uv131)
3. [SanDisk Ultra Flair](usb-sticks.md#sandisk-ultra-flair)


Test conditions:

- coldboot x50
- warmboot x50
- boot Debian over PXE and reboot then check USB presence x50
- two identical USB 3.x sticks plugged simultaneously in both slots

Detection rate:

| Stick no./ platform. no | Coldboot | Warmboot | Reboot |
|-------------------------|----------|----------|--------|
|     1/1     |   100%   |   100%   |  unable to test (platform hangs after few reboots)  |
|     2/2     |    92%   |    96%   |  unable to test (platform hangs after few reboots)  |
|     3/1     |    0%    |     0%   |  unable to test (platform hangs after few reboots)  |

Other observations:

Sticks no. 1 and 2 work pretty good. They advertise as USB 3.x sticks almost
immediately after host controller reset and seem to not collide with
corresponding USB 2.0 ports.

Stick no. 3 when plugged causes the reset of the host controller to fail
(timeout). It is necessary to increase the timeout value for host controller
reset. Even if the timeout is increased, the sticks do not advertise as USB 3.x.
The are handled the same as USB 2.0 sticks.

Stick no. 2 was not detected with 100% accuracy, i.e. sometimes only one of two
sticks were detected in one boot iteration. Issue related to port "toxicity"
observed on apu4.

Results for stick no 3. after timeout adjustment:

| Stick no./ platform. no | Coldboot | Warmboot | Reboot |
|-------------------------|----------|----------|--------|
|     3/2     |   80%   |   100%   |  unable to test (platform hangs after few reboots)  |

Stick no. 3 was not detected with 100% accuracy, i.e. sometimes only one of two
sticks were detected in one boot iteration. Issue related to port "toxicity"
observed on apu4.