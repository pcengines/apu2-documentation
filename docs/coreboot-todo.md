1. Root cause why recent AGESa doesn't work on APU2 - ask community, contact AMD
2. unify apu1 and apu2 gpio
3. agesa_ReadSpd_from_cbfs is already in PI def_callouts.c - to use that spd
   hex files should contain only one option not 4 - or index have to be read in
   a different way as in APU1
4. sortbootorder as secondary payload
5. apu2 builder for mainline coreboot
6. apu2 documentation update
