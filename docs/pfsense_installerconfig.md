# Execute post-install script on PFSense
After successfully installation installerconfig script is called if exists. It has defined structure:
```bash
# Unattended installation variables
...
#!/bin/bash
# Your script is here
...
# When work is done reboot is called
reboot
```
This file is must be located in **/etc/** directory.
#### installerconfig
In **/configs/installerconfig** script we'll use archive with modified configuration files and replace existing files. Script assumes that archive **pfsense.tar.gz** is located in **/home** directory.  