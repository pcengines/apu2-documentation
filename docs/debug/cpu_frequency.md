[Github issue](https://github.com/pcengines/coreboot/issues/196)

Most of information is taken from [BKDG](https://www.amd.com/system/files/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf).

## P-states

AMD processors have 2 sets of P-state numeration: software and hardware. They
both start with P0 being highest-performance accessible, but hardware P0 isn't
the same as software P0. On the software side additional boost states (Pb0, Pb1)
are used. All boosted P-states are always higher performance than non-boosted
P-states. Hardware P0 is software Pb0. rest of states is mapped 1-to-1, with the
same names corresponding to different states, which can be confusing. Number of
boost states is written in `D18F4x15C[NumBoostStates]`, in case of apu it is 2.
** BIOS should not provide ACPI _PSS entries for boosted P-states.**

Boost states cannot be requested directly, some conditions that must be met:

* P0 (software) requested
* boost enabled (i.e. boost states exist and not disabled in `MSRC001_0015[CpbDis]`)
* actual demand on CPU
* no upper limit set (`D18F4x13C[SmuPstateLimit]`)
* additional hardware limits: temperature, TDP, power consumtion

CPU can temporarily go above the TDP for one core, given that enough of other
cores are halted or waiting on IO operation. This is configured in `D18F4x16C`.

Lower limits can be set in `D18F3x64[HtcPstateLimit]`, `D18F3x68[SwPstateLimit]`
and `D18F3xDC[HwPstateLimit]` - all of these use hardware numeration. Also in
BKDG among other limitations "APML" (Advanced Platform Management Link?) was
mentioned with a dead link to `D18F3xC4[PstateLimit]`.

There is a maximum of 8 states, but only 5 are used in apu:

| Software | Hardware | Frequency | Register
|----------|----------|-----------|--------------
| Pb0      | P0       | 1.4 GHz   | MSRC001_0064
| Pb1      | P1       | 1.2 GHz   | MSRC001_0065
| P0       | P2       | 1.0 GHz   | MSRC001_0066
| P1       | P3       | 800 MHz   | MSRC001_0067
| P2       | P4       | 600 MHz   | MSRC001_0068
| n/a      | n/a      |           | MSRC001_0069
| n/a      | n/a      |           | MSRC001_006A
| n/a      | n/a      |           | MSRC001_006B

Problem is that platform doesn't go back to 1.0 GHz, so it isn't probably
connected to boost.

Other MSR's directly connected to P-states:

* MSRC001_0061 - current P-state limit, P-state max value - read only.
* MSRC001_0062 - P-state control, write to this register requests a change.
Actual change might not happen if it exceeds any of set limits or if another
core on the same voltage/frequency domain uses different state.
* MSRC001_0063 - current P-state. Uses software numbering. May not be accurate
after warm reset, if it happened during state change (might be connected to
reboot issues).
* MSRC001_0071 - COFVID status. This register has fields describing real value
of P-state, current P-state limit (2 in this case, so no boost is allowed),
startup P-state, maximum frequency of CPU and NB, current frequency and voltage.
All P-states here use hardware numbering.

Values of the mentioned registers were read using BITS, `lspci -xxxx` (debian)
and `pciconf` (pfSense). `pciconf` doesn't allow to read registers above 0x100
(extended PCI configuration space) so `D18F4` was not cheched there. Also MSR's
were only read and written with BITS - changing them from OS would require a
kernel module and could mess/get messed by power management of OS. Results
seems to be consistent across different platforms, OSes and warm/cold boots.
