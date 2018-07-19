Unattanded installation PFSense
===============================

rc.local
--------

After booting from USB stick installer rc.local is executed. Changes have to be
applied to this file to eliminate interactive dialog options.

1. Add environment variable defining terminal type:
```bash
#!/bin/sh
# $FreeBSD$
export TERM=vt100
```

2. Comment out console type input:
```bash
# Serial or other console
        echo
        echo "Welcome to pfSense!"
        echo
        echo "Please choose the appropriate terminal type for your system."
        echo "Common console types are:"
        echo "   ansi     Standard ANSI terminal"
        echo "   vt100    VT100 or compatible terminal"
        echo "   xterm    xterm terminal emulator (or compatible)"
        echo "   cons25w  cons25w terminal"
        echo
        echo -n "Console type [vt100]: "
        #read TERM
        #TERM=${TERM:-vt100}
```

3. Add reboot command after installerconfig finishes:
```bash
if [ -f /etc/installerconfig ]; then
        bsdinstall script /etc/installerconfig
        reboot
fi
```

installerconfig
---------------

**installerconfig** script is called if exists. If doesn't exist manual installation is performed.

```bash
#!/bin/bash
# Unattended installation part
...
# After installation you can launch new system shell and change configuration
...
# When work is exit
exit
```

This file must be located in **/etc/** directory.

**/etc/installerconfig** script will install pfSense and replace all configuration files that we want to change before first boot.

Examples
--------
Example file, **installerconfig**, is located in **conifgs/** directory

Problems
--------

During extracting distribution files phase installation sometimes hangs up. I've waited for 15 minutes and nothing happend. My solution was to reset platform.
