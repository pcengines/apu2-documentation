Order of PCI addresses
===============================

## Standard PCI addressing

Initial coreboot port for APU2 was made with badly implemented PCIe engines
definition passed to AGESA. It's done in the way that mPCIe cards get lower
address then Network interface controllers (NICs). It causes weird and unwanted
behavior like shifting addresses of NICs when a mPCIe device is added.
Unfortunately it can’t be changed without consequences, because of many
years of APU existence on the market. If it had been changed, many APU owners
would be surprised by e.g. change of interfaces names.

## sortbootorder

To address this issue, we added a runtime option in [sortbootorder](https://github.com/pcengines/sortbootorder/blob/master/README.md)
which reverses the order of PCIe engines assignment in a way that:

- NICs occupy the lowest PCIe device numbers which make their enumeration
persistent regardless of the WiFi module presence
- the WoL capable NIC is the first PCIe device in iPXE and in the operating
system
- the mPCIe slots occupy the highest PCIe device numbers in following order:
3x NIC, mPCIe1, mPCIe2. In such case faulty detected WiFi in mPCIe2 slot will
not affect interface renaming for mPCIe1 slot WiFi card.

By default, this option is disabled which means nothing changes (compared to the
state maintained for past 4 years) without intentional change of this setting.

## How to change

To reverse order of PCI addresses:

- enter the sortbootorder in the SeaBIOS menu while booting by choosing
`payload [setup]`
- enable the `Reverse order of PCI addresses` option by pressing `g` key
- save and exit sortbootorder by pressing `s`.
