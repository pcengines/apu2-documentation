### BAD vs GOOD card in debian

1. No card inserted - coldboot

    ```
    root@debian:~# cat /proc/interrupts | grep mmc
      16:         13         13         13         13   IO-APIC-fasteoi   mmc0
    ```

    ```
    root@debian:~# cat /sys/kernel/debug/mmc0/ios
    clock:          0 Hz
    vdd:            0 (invalid)
    bus mode:       1 (open drain)
    chip select:    0 (don't care)
    power mode:     0 (off)
    bus width:      0 (1 bits)
    timing spec:    0 (legacy)
    signal voltage: 0 (3.30 V)
    ```

    ```
    root@debian:~# cat /sys/kernel/debug/mmc0/clock
    0
    ```

2. BAD card inserted - coldboot

    ```
    root@debian:~# cat /proc/interrupts | grep mmc
      16:         13         13         13         13   IO-APIC-fasteoi   mmc0
    ```

    after card removal:


    ```
    root@debian:~# cat /proc/interrupts | grep mmc
      16:         13         14         13         13   IO-APIC-fasteoi   mmc0
    ```


    ```
    root@debian:~# cat /sys/kernel/debug/mmc0/ios
    clock:          0 Hz
    vdd:            0 (invalid)
    bus mode:       1 (open drain)
    chip select:    0 (don't care)
    power mode:     0 (off)
    bus width:      0 (1 bits)
    timing spec:    0 (legacy)
    signal voltage: 0 (3.30 V)
    ```

    ```
    root@debian:~# cat /sys/kernel/debug/mmc0/clock
    0
    ```

3. BAD card inserted - coldboot

    ```
    root@debian:~# cat /proc/interrupts | grep mmc
      16:        187        197        197        204   IO-APIC-fasteoi   mmc0
    ```

    ```
    root@debian:~# cat /sys/kernel/debug/mmc0/ios
    clock:          50000000 Hz
    actual clock:   50000000 Hz
    vdd:            21 (3.3 ~ 3.4 V)
    bus mode:       2 (push-pull)
    chip select:    0 (don't care)
    power mode:     2 (on)
    bus width:      2 (4 bits)
    timing spec:    2 (sd high-speed)
    signal voltage: 0 (3.30 V)
    ```

    ```
    cat /sys/kernel/debug/mmc0/clock
    50000000
    ```
