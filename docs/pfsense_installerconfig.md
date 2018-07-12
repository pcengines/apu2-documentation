# Execute post-install script on PFSense
After successfully installation **installerconfig** script is called if exists. It has defined structure:
```bash
# Unattended installation variables
...
#!/bin/bash
# Your script is here
...
# When work is done reboot is called
reboot
```
This file must be located in **/etc/** directory.
#### installerconfig
**/configs/installerconfig** script will replace all options in configuration files that we want to change before first boot.
