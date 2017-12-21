Pxelinux on apu platforms
-------------------

# iPXE serial console

Since we have rebased to SeaBIOS 1.11.0, which implements full serial console
support, we do not need sgabios and serial console in iPXE anymore. However some
pxe configurations seem to have problems with displaying and interacting the pxe
boot menu.

# iPXE scripting and pxelinux

When trying to boot by chain loading iPXE scripts (e.g. menu.ipxe) there are no
problems with display and switching between options. Unfortunately when trying
to boot Debian netinst via pxelinux provided with image, the bootmenu is not
printed correctly (weird signs appear). Furthermore, when trying to switch
between options, only the currently selected row is refreshed, which causes the
screen to shift and makes it completely unreadable.

# Pxelinux configuration

In order to get rid of issues mentioned above, special configuration is needed.
Since SeaBIOS 1.11.0 is redirecting screen output to console, it behaves like a
video console. This is the main reason of the problems. As a workaround video
console has to be disabled on pxelinux and serial port has to be enabled to act
as a console. These parameters allows to achieve such effect:

```
CONSOLE flag_val
If flag_val is 0, disable output to the normal video console. If flag_val is 1,
enable output to the video console (this is the default). Some BIOSes try to
forward this to the serial console which can make a total mess of things, so
this option lets you disable the video console on these systems.

SERIAL port [baudrate [flowcontrol]]
Enable a serial port to act as the console. "port" is a number
(0 = /dev/ttyS0 = COM1, etc.) or an I/O port address (e.g. 0x3F8). If "baudrate"
is omitted, the baud rate defaults to 9600 bps. The serial parameters are
hardcoded to 8 bits, no parity and 1 stop bit.
```

These parameters must be placed in `pxelinux.cfg`. Example of correct
`pxelinux.cfg`:

```
# D-I config version 2.0
# search path for the c32 support libraries (libcom32, libutil etc.)
serial 0 115200
console 0

path debian-installer/i386/boot-screens/
include debian-installer/i386/boot-screens/menu.cfg
default debian-installer/i386/boot-screens/vesamenu.c32
prompt 0
timeout 300
```

`serial` parameter has to be the first parameter in config file.
`console` parameter has be set then to 0 to disable video console.
