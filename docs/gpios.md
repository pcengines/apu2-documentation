APU GPIO tutorial
=================

PC Engines apu2 platform series have many features that are being controlled by
GPIOs, in particular:

- mPCIe resets
- WLAN disable on mPCIe slots
- SIM swaps
- LEDs
- S1 switch

In order to make it possible to modify/read their state, a OS driver is
required. In Linux there is a `pinctrl_amd` module which is responsible for
GPIO controller handling. The driver required special ACPI device definition
for GPIO controller to work. Since 4.10.0.1 version, the ACPI support was added
and enabled GPIO interface via sysfc in Linux systems.

## LEDs

Linux has a special driver called `gpio-leds` which interacts with GPIO
controller pinctrl driver to utilize a fancy sysfs interface for LED handling.
All 3 front leds have been assigned to this driver and as a result are exposing
following interface:

```
$ ls /sys/class/leds/
apu2:green:led1  apu2:green:led2  apu2:green:led3
```

> The name of the platform in the leds filename changes according to platform.
> So apu3 will have like `apu3:green:ledX`

Each of these LEDs expose following interface:

```
$ ls /sys/class/leds/apu2\:green\:ledX
brightness  device  max_brightness  power  subsystem  trigger  uevent
```

The most interesting are `brightness` and `trigger`:

1. `brightness` - as the name says, it can control the LED brightness.

> GPIO controller only supports binary output (0 or 1) so the led can only be
> turned on or off

- turn the led on: `echo 1 > brightness`
- turn the led off: `echo 0 > brightness`
- get current led state: `cat brightness`

2. `trigger` - is a string which defines the system activity that will cause
   the LED to be on or off. There are various triggers like:
   `disk-activity, kbd-capslock, mmc0, heartbeat`. Each of them can light the
   led up on certain event like disk activity, SD activity, keyboard special
   key etc.

- to set a trigger: `echo kbd-capslock > trigger`
- to unset a trigger: `echo none > trigger`

> By default LED3 has been set as a `heartbeat`. `heartbeat` requires
> additional module to be loaded: `ledtrig-heartbeat`. In order to load the
> module by default add the `ledtrig-heartbeat` to
> `/etc/modules-load.d/modules.conf`.

## S1 switch button

The small button near the SD card slot is called a S1 button. With the ACPI it
has been configured to work with `gpio-keys` module which handles a interrupt
GPIO keys/keyboards. S1 switch has following attributes:

- active state low
- edge triggered
- pull-up by default
- interrupt line 7
- debounce time interval: 100ms

The driver is also set to use the S1 switch as `EV_KEY` event type and the key
code to emit `BTN_1` (257).

In order to determine whether the interrupt work for the S1 switch one can
check the initial interrupts statistics with `cat /proc/interrupts`:

```
            CPU0       CPU1       CPU2       CPU3
...
   7:          0          0          0          1  IR-IO-APIC    7-fasteoi   pinctrl_amd
...
  58:          0          0          0          0  amd_gpio   89  switch1
...
```

After pressing the button few times:

```
            CPU0       CPU1       CPU2       CPU3
...
   7:          0          0          0         17  IR-IO-APIC    7-fasteoi   pinctrl_amd
...
  58:          0          0          0         16  amd_gpio   89  switch1
...
```

The button can be further used in user own applications.

## Raw GPIO control

Other GPIO signals that do not have a dedicated river have to be controlled
manually. In order to control a GPIO, a simple sysfs interface is introduced.

```
$ ls /sys/class/gpio/
export  gpiochip320  unexport
```

As one can see there is a `gpiochip320` which corresponds to GPIO controller of
the SoC. The 320 number according to documentation corresponds to the first
GPIO number that can be controlled by this chip. The exact number of
controllable GPIOs for this chip can be retrieved with:

```
$ cat /sys/class/gpio/gpiochip320/ngpio
192
```

As one can see this driver supports 192 GPIOs that can be controlled by this
chip giving a range of 320-511 GPIO numbers. In order to control a GPIO one has
to export the GPIO to sysfs first:

```
$ echo 391 > /sys/class/gpio/export
```

> Note that only GPIOs from range 320-512 are supported. Writing other values
> will cause `-bash: echo: write error: Invalid argument`.

If the operation was successful a GPIO will appear:

```
$ ls /sys/class/gpio/
export  gpio391  gpiochip320  unexport
```

> In fact we have exported a GPIO71 of the SoC, the 320 offset must be
> subtracted.

Each GPIO can export following interface:

```
$ ls /sys/class/gpio/gpio391
active_low  device  direction  edge  power  subsystem  uevent  value
```

- `active_low` - indicates whether this pin is an active low signal
- `direction` - can be either `in` or `out`
- `edge` - for inputs, whether pin should be active on `rising, falling, both`,
  `none` edge
- `value` - state of the pin

1. In order to change the state of the GPIO:

```
# ensure pin is in output mode
$ echo out > direction
# check current state
$ cat value
1
# change the state
$ echo 0 > value
$ cat value
0
```

2. Change pin direction:

```
# set to input
$ echo in > direction
# set to output
$ echo out > direction
```

3. Set pin to active low:

```
$ echo 1 > active_low
```

### GPIO mappings

PC Engines apu series has many GPIOs and they differ between board versions. In
order to not disrupt platform operation, **only the following GPIOs should be
exported**:

1. APU2:

- `386` - mPCIe1 reset (active low, default state output high)
- `387` - mPCIe2 reset (active low, default state output high)
- `391` - mPCIe1 WLAN disable (active low, default state output high)
- `392` - mPCIe2 WLAN disable (active low, default state output high)

2. APU3/APU4:

- `386` - mPCIe3 reset (active low, default state output high)
- `387` - mPCIe2 reset (active low, default state output high)
- `391` - mPCIe3 WLAN disable (active low, default state output high)
- `392` - mPCIe2 WLAN disable (active low, default state output high)
- `410` - SIM swap (active low, default state output high)

3. APU5:

- `386` - mPCIe3 reset (active low, default state output high)
- `387` - mPCIe2 reset (active low, default state output high)
- `391` - mPCIe3 WLAN disable (active low, default state output high)
- `392` - mPCIe2 WLAN disable (active low, default state output high)
- `410` - SIM swap (active low, default state output high)

> Important: when exporting, pin changes its state to input and low state.
> We are working on a solution.
