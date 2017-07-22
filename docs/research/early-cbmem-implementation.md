### Early CBMEM support

By the 4.7 release (October) support for `cbmem` in romstage is required for
all platforms. Original message from mailing list can be found
[there](https://www.mail-archive.com/coreboot@coreboot.org/msg49234.html)

[Following mail](https://www.mail-archive.com/coreboot@coreboot.org/msg49644.html)
gives some insight on what needs to be done to satisfy the romstage `cbmem`
requirement.

Essential extract from above message:

```
> In preparation to remove the static CBMEM allocator, tag the chipsets
> that still do not implement get_top_of_ram() for romstage.

So you need to implement that function for your chipset, remove the
Kconfig selection, and if I remember correctly, everything else should
then start working nicely.
```

The next step is then to also add time-stamps to CBMEM, that can be read out
with `cbmem -t`.

It looks that implementation in northbridge is necessary. For `apu2` it will be
in `src/northbridge/amd/pi/00730F01`.

Few more useful links below:

* [Chipsets that are marked as missing EARLY_CBMEM implementation](https://review.coreboot.org/#/c/7850/)

* [One example of Intel chipset implementation](https://review.coreboot.org/#/c/19414/)

* [Another example of Intel chipset implementation](https://review.coreboot.org/#/c/13131/)
