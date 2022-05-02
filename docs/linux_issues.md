Known issues with Linux
=======================

pcengines-apuv2 driver is broken (as of May 2, 2022)
----------------------------------------------------

`pcengines-apuv2` was added in Linux 5.1 already supporting both APU2 and APU3,
Linux 5.5 extended the driver to support APU4 as well.

There are two ways for registering APU-specific devices used by the kernel:
`pcengines-apuv2` driver and parsing of ACPI tables. The former way targets APUs
specifically and has to be updated for each new version of the board, while the
latter one is driven by generic ACPI tables and can work with an APU as long as
the firmware it's running provides suitable ACPI data.

`pcengines-apuv2` in turn depends on `leds-gpio` and `gpio_keys_polled`. As per
[this issue](https://github.com/pcengines/apu2-documentation/issues/204),
`gpio-keys-polled` has trouble querying description of a GPIO provided by
`pcengines-apuv2` driver:

```
kernel: gpio-keys-polled gpio-keys-polled: unable to claim gpio 0, err=-517
```

`leds-gpio` driver on the other hand works fine with inputs from ACPI data and
from `pcengines-apuv2`, because it's capable of querying GPIO data by index.

### Potential fix

There are 3 commits from the author of `pcengines-apuv2`
[here](https://github.com/metux/linux/commits/apu2/defconf-5.5.0/drivers), in
his fork of the kernel.

`input: keyboard: gpio-keys-polled: skip oftree code when CONFIG_OF disabled`
commit is not a functional change. The other two were submitted
[for review](https://lkml.kernel.org/lkml/1561648031-15887-2-git-send-email-info@metux.net/T/)
and `input: keyboard: gpio-keys-polled: use input name from pdata if available`
was committed, but it's not enough to fix the issue.

[The last commit](https://github.com/metux/linux/commit/0e0239ff4df38196ef4069a0400897b843312593)
is supposed to make `gpio_keys_polled` work the same as `leds-gpio`, but it
wasn't upstreamed because a more generic approach [was supposed to be
proposed](https://lkml.kernel.org/lkml/9819838f-9e35-c504-61da-f8c3f9b7ac8e@metux.net/).
Apparently, more generic approach didn't make it either living `pcengines-apuv2`
broken to this day.

### Workaround

Until situation with `gpio-keys-polled` or `pcengines-apuv2` improves, it's
recommended to blacklist `pcengines-apuv2` module as a workaround for this
issue and rely on parsing of ACPI data.
