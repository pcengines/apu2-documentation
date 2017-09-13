Flashrom building
=================

Intro
-----
* Instruction based on Linux Voyage
* Checked for ALIX.1E platform
* Root user is recommended

Instructions is based on the informations from official flashrom website. For 
more details visit https://www.flashrom.org/Downloads. 

Building process
----------------

1. Install all required packages.

```
apt-get update \
	git -y \
	build-essential -y \
	libpci-dev -y \
	libusb-dev -y \
	libusb-1.0-0-dev -y \
	libftdi-dev -y
```

2. Clone flashrom repository.

```
git clone https://review.coreboot.org/flashrom.git
```

If an error similar to the showed below occurs:
```
error: Problem with the SSL CA cert (path? access rights?) while accessing https://review.coreboot.org/flashrom.git/info/refs
fatal: HTTP request failed
```
Install `ca-certificates` package:
```
apt-get install ca-certificates -y
```


3. Enter to the downloaded directory and build flashrom.

```
cd flashrom
make
```
You can install it in OS by typing:
```
make install
```

Flashing firmware with flashrom usage
-------------------------------------

```
flashrom -w <ROM directory> -p internal
```

E.g.:
```
flashrom -w coreboot.rom -p internal
```
