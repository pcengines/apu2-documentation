APU2 vs APU3
------------

Brief walkthrough [APU2](http://www.pcengines.ch/schema/apu2c.pdf) and [APU3](https://www.pcengines.ch/schema/apu3a.pdf) schematics show below difference:

- power/reset/watchdog header changed
- LPC header changed to debug
- RXD3/TXD3 wired to PCIe x1 expansion
- SIM switch added
- use of mPCI slots explicitly specified
- fan control removed
- SIMSWAP pin added
- APU straps changed
- I'm not sure about mSATA changes, but it looks something is different
- internal us2.0 header added
- some PCIe connections removed (page 5)
