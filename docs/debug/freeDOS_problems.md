Problems with FreeDOS on APU2 platform
======================================

1. FreeDOS doesn't have drivers for internal SD card reader. Boot ends like
    this:

```
JemmEx v5.78 [07/15/12]
System memory found at c100-edff, region might be in use
JemmEx loaded
Kernel: allocated 45 Diskbuffers = 23940 Bytes in HMA
Bad or missing Command Interpreter: C:\FDOS\BIN\COMMAND.COM C:\FDOS\BIN /E:1024 /P=C:\AUTOEXEC.BAT
Enter the full shell command line:
```

2. FreeDOS doesn't use the serial console. Instead its driving its output to
    standard PC VGA text console. `sgabios` needs to be used to provide the
    wrapping around text output. `ctty aux` command could be added to
    `autoexec.bat` though, to drive some output to the serial console directly,
    but more advanced programs (using curses-like graphical interfaces, e.g.
    `edit`) are not redirecting their output.

