### Recompile debian kernel to support APU2 GPIO

`http://www.pcengines.ch/howto.htm#gpio`

Get appropriate debian kernel source, e.g. from `linux-source-*` package.

Copy source to host PC and compile with `gpio` module included:

```
CONFIG_GPIO_NCT5104D=m
CONFIG_GPIO_SYSFS=y
```

```
make menuconfig
sudo apt-get install debhelper
sudo apt-get install modutils
sudo apt-get install kernel-package
make-kpkg clean
fakeroot make-kpkg  -j8 --initrd --revision=1.2.custom kernel_image
```

Copy .deb into sd card, boot and install:

```
dpkg-i linux-image-3.16.36_1.3.custom_amd64.deb
```

```
vi /etc/modules
```

add:

```
gpio-nct5104d
```

```
cd /sys/class/gpio
echo 0 > export
cd gpio0
echo out > direction
echo 1 > value
```

### First test

1. Export `gpio17`:

    ```
    cd /sys/class/gpio
    echo 17 > export
    ```

2. Check it's value and direction:

    ```
    root@debian:/sys/class/gpio/gpio17# cat direction
    in
    root@debian:/sys/class/gpio/gpio17# cat value
    0
    ```

3. Change to `out` and `1`:

    ```
    root@debian:/sys/class/gpio/gpio17# echo out > direction
    root@debian:/sys/class/gpio/gpio17# cat direction
    out
    root@debian:/sys/class/gpio/gpio17# echo 1 > value
    root@debian:/sys/class/gpio/gpio17# cat value
    1
    ```

    At this point voltage on pin rises from 0V to 0.8V.

4. Reboot:

    ```
    reboot
    ```

    During coreboot-bios phase voltage rises to 1.2V.

    When OS boots into login propmt voltage drops back to 0.8V.

5. Check `gpio17` `direction` and `value`:

    ```
    cd /sys/class/gpio
    echo 17 > export
    cd gpio17

    root@debian:/sys/class/gpio/gpio17# cat direction
    in
    root@debian:/sys/class/gpio/gpio17# cat value
    1
    ```

    It claims to be an input in high state. But the voltage is still 0.8V so it is
    actually an output (?)

    > That's because gpios are configured by default as OD

6. Reboot again with those settings and check:

    ```
    root@debian:/sys/class/gpio/gpio17# cat direction
    in
    root@debian:/sys/class/gpio/gpio17# cat value
    1
    ```

7. Set output to low (0V and reboot)

    ```
    root@debian:/sys/class/gpio/gpio17# cat direction
    in
    root@debian:/sys/class/gpio/gpio17# cat value
    0
    ```

    After reboot voltage on this pin is 0V, even if boot into other OS.
    Voltage on the rest of the pins is ~0.9V.


    After coldboot voltage is back at ~0.9V.

### APU1 test

Voyage on USB stick, without gpio kernel module
Debian on SDcard, with gpio kernel module

#### Pins as GPIO

1. Log into Debian, set pin17 as output with value = 0. Voltage = 0V.
2. Reboot into Debian. Voltage = 0V for the entire time of reboot as well as in
   the OS.
3. Reboot into Voyage. Voltage = 0V for the entire time of reboot as well as in
   the OS.

#### Pins disabled

1. Log into Debian, set pin17 as output with value = 0. Voltage = 0V.
2. Reboot into Debian. Voltage rises to 1.2V for the entire time of reboot but
   drops to 0 when login prompt appears (when gpio module is loaded ? it
   initialises pins as GPIOs).
3. Reboot into Voyage. Voltage = 1.2V for the entire time of reboot as well as
   in the OS.


