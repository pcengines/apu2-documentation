# Performing cold reset remotely

It is not possible to perform 100% cold boot without physically disconnecting
power supply, some registers cannot be reset otherwise.
[BKDG](https://www.amd.com/system/files/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf)
differentiates between cold boot, cold reset and warm reset, but even within
one type of reset some bits marked with "Cold reset: 0" are cleared and others
are not.

### Discovered ways to perform reset

| Reset type       | D18F0x6C   | PMxC0      |
|------------------|------------|------------|
| Cold boot        | 0x000ff800 | 0x00000800 |
| Reboot           | 0x000ffe00 | 0x40080400 |
| Reset            | 0x000ff800 | 0x40010400 |
| Power button     | 0x000ff800 | 0x40200402 |
| FullRst          | 0x000ff800 | 0x40200400 |
| ACPI reset       | 0x000ff800 | 0x40000400 |
| PCI reset        | 0x000ffe00 | 0x40020400 |

These are initial values, they are changed during boot sequence. Bits changing
in D18F0x6C are checked by AGESA to differentiate cold boot from warm boot.
Some of bits in PMxC0 (0x1003ff) are checked by FCH initialization code, they
result in additional reset when set.

###### Reboot

Done with `reboot` in shell or after changing options in sortbootorder. It
performs warm reset.

###### Reset button

Done by temporary shorting reset pin to the ground. Performs cold reset from
AGESA's point of view.

###### Power button

By shorting power button pin to the ground for more than 4 seconds platform
enters S5 state. After second, short press the platform starts up. It is
considered to be cold reset, but during FCH initialization platform will perform
another reset (after which PMxC0 is set as in reboot, D18F0x6C as in cold boot).
This was one of causes for doubled sign of life.

###### FullRst through IO port CF9

Bit 3 of IO port CF9 is:

> **FullRst**. Read-write. Reset: 0. 0=Assert reset signals only. 1=Place system
> in S5 state for 3 to 5 seconds.

Bits 1 (SysRst) and 2 (RstCmd) need to be set as well. CF9 can be accessed
through its shadow in ACPI space (PMxC5, at address 0xFED803C5 when MMIO is
enabled). Performs cold reset and gives time for most peripheral devices to get
into stable state.

###### ACPI emulated reset button

Done by setting bit 6 (ResetAllAcpi) of PMxC4 (Reset Command). It is described
as emulating a reset button event, but it does not set UsrReset in PMxC0, while
physical button does.

###### PCI reset

Also triggered through PMxC4. Reset is done after setting bit 0 (Reset), but
only if bit 7 (ResetEn) was set. They need to be set with two separate writes.
Performs "soft PCI reset", which is a warm reset.

### Forcing cold reset from started OS

After flashing new firmware it is highly recommended (sometimes even necessary)
to perform a cold boot. It is not always an option for remote devices, so tests
were made to find another way of forcing cold boot path in firmware. Note that
this cannot guarantee that when any device on board entered an unexpected state
it can be brought back to defined state without full power cycle.

As these steps are most likely to be run on production software stack options
like using custom kernel/driver or applying kernel parameters at boot time were
not considered. Tests were made with Debian 9 and pfSense 2.4.2.

FullRst was chosen as most promising one: it can be done both by IO as well as
memory mapped ACPI register. It also puts platform in state closest to cold boot
from all tested options by staying in S5 for some time.

###### Debian

By default it is impossible to access physical memory space without changes to
the kernel, however access to IO ports is unrestricted for root user. Thus, to
perform FullRst type as root:

```
echo -ne "\xe" | dd of=/dev/port bs=1 count=1 seek=$((0xcf9))
```

`\xe` is a bitmap for FullRst, RstCmd and SysRst. After this command platform
enters S5 immediately, so save your work, sync all filesystems etc. using e.g.
[SysRq](https://askubuntu.com/a/491153), of course do not perform last step
(reboot or shutdown), as it will be done by FullRst. We found that sometimes
5 seconds is not enough for syncing.

###### pfSense

Shell in pfSense does not support backslash in `echo` command arguments. It also
does not allow to use subshells to convert hex to decimal. IO ports cannot be
accessed, but MMIO can.

```
printf "\016" | dd of=/dev/mem bs=1 count=1 seek=4275569605
```

`\016` is the same as `\xe`, in octal. Seek value is 0xFED803C5 written in
decimal. There is no SysRq as in Linux, so manual sync and read-only remount is
required.
