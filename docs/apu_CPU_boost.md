APU Core Performance Boost
==========================

Since coreboot v4.9.0.2 PC Engines firmware for apu2/3/4/5 has the Core
Performance Boost (aka CPU boost) enabled by default. The feature automatically
detects huge loads on the processorr and temporarily raises the core frequency
to 1400MHz. More details how to check whether boost works available in the [blog post](https://blog.3mdeb.com/2019/2019-02-14-enabling-cpb-on-pcengines-apu2/)

## Checking frequency in the operating system

Operating systems have problems with reporting the boosted frequency and
certain tricks have to be performed to reveal the true frequency of the
processor. Benchmarks and few utilities give the increased results, but the common frequency reading methods not.

### BSD

Check the frequency status on the system with:

```
# sysctl dev.cpu.0
dev.cpu.0.cx_method: C1/hlt C2/io
dev.cpu.0.cx_usage_counters: 382 6500
dev.cpu.0.cx_usage: 5.55% 94.44% last 28331us
dev.cpu.0.cx_lowest: C2
dev.cpu.0.cx_supported: C1/1/0 C2/2/400
dev.cpu.0.freq_levels: 1000/924 800/760 600/571
dev.cpu.0.freq: 600
dev.cpu.0.%parent: acpi0
dev.cpu.0.%pnpinfo: _HID=none _UID=0
dev.cpu.0.%location: handle=\_PR_.P000
dev.cpu.0.%driver: cpu
dev.cpu.0.%desc: ACPI CPU
```

In order to notice the boosted frequency, one has to add:

```
hint.p4tcc.0.disabled=1
hint.acpi_throttle.0.disabled=1
hint.acpi_perf.0.disabled=1
```

to `boot/loader.conf` and reboot the platform.

After reboot, run some load generating task in the background like:

```
# dd if=/dev/zero of=/dev/null count=4G &
```

Then read the CPU status again:

```
# sysctl dev.cpu.0
dev.cpu.0.cx_method: C1/hlt C2/io
dev.cpu.0.cx_usage_counters: 291 3224
dev.cpu.0.cx_usage: 8.27% 91.72% last 11496us
dev.cpu.0.cx_lowest: C2
dev.cpu.0.cx_supported: C1/1/0 C2/2/400
dev.cpu.0.freq_levels: 1400/-1 1200/-1 1000/-1
dev.cpu.0.freq: 1400
dev.cpu.0.%parent: acpi0
dev.cpu.0.%pnpinfo: _HID=none _UID=0
dev.cpu.0.%location: handle=\_PR_.P000
dev.cpu.0.%driver: cpu
dev.cpu.0.%desc: ACPI CPU
```

Without running the task in background, frequency will be capped at 1400MHz:

```
# sysctl dev.cpu.0
dev.cpu.0.cx_method: C1/hlt C2/io
dev.cpu.0.cx_usage_counters: 289 2606
dev.cpu.0.cx_usage: 9.98% 90.01% last 18267us
dev.cpu.0.cx_lowest: C2
dev.cpu.0.cx_supported: C1/1/0 C2/2/400
dev.cpu.0.freq_levels: 1400/-1 1200/-1 1000/-1
dev.cpu.0.freq: 1000
dev.cpu.0.%parent: acpi0
dev.cpu.0.%pnpinfo: _HID=none _UID=0
dev.cpu.0.%location: handle=\_PR_.P000
dev.cpu.0.%driver: cpu
dev.cpu.0.%desc: ACPI CPU
```

## Linux

Currently there is no known method to show boosted frequency on Linux systems. Solution is work in progress.
