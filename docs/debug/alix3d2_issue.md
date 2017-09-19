Issue description of PC Engines ALIX2D3 board
=============================================

Problem description
-------------------

There is no possibility to get feedback from PC Engines ALIX.2D3. Boot logs
are not send by serial connection and OS installed on CF card doesn't boot.

Checked configurations
----------------------

* Comparison with another ALIX.2D3 platform (correctly working board):

There was no visible differences in appearance beetwen compared boards.
They seems to have got the same peripherals.

Tried to boot both platforms with the same CF card with Voyage Linux installed.
Working platform booted to OS, booting logs were sent by serial console and 
device was visible on DHCP clients list of network to which device was 
connected.
Not working platform didn't send any feedback by serial console. Device didn't 
appear on DHCP clients list of network to which device was connected.

Both platforms don't boot OS from USB.

* LPC ROM image with tinyBIOS v.099m usage:

Working ALIX.2D3 platform booted correctly to the OS with LPC ROM image 
connected to the LPC socket. Sent booting logs by serial connection and
appeared on DHCP client list.

Not working ALIX.2D3 board didn't send any feedback by serial console.
Device didn't appear on DHCP clients list of network to which device was
connected.

* Shorting of `S1` switch pads:

There is no switch on tested ALIX board. In case of a situation when the serial
port is disabled pads of `S1` where shorted to enter to the boot configuration 
menu as is written in [manual on page 11](http://www.pcengines.ch/pdf/alix2.pdf).
This operation did not produce results. Output didn't show in serial console.

* Different power supply voltages:

Tested power supply voltages: 12 V, 18 V.
There was no difference in operation of boards (working ALIX3D2 worked 
correctly, not good board didn't start to work).

Conclusion
----------

Taking into account the information given above it seems to be hardware issue.
