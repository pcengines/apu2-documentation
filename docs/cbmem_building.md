Coreboot `cbmem` building
=========================

Intro
-----
* Instruction based on Linux Voyage
* Checked for ALIX.1E and APU5 platforms
* Root user is recommended
* Git is required if it's not installated type:
```
apt-get install git -y
```

Building and installation process
---------------------------------

1. Clone coreboot repository

```
git clone https://review.coreboot.org/coreboot.git
```

If an error similar to the showed below occurs:

```
error: Problem with the SSL CA cert (path? access rights?) while accessing https://review.coreboot.org/coreboot.git/info/refs
fatal: HTTP request failed
```

Install `ca-certificates` package:

```
apt-get install ca-certificates -y
```

2. Build and install `cbmem` in OS

```
cd coreboot/util/cbmem/
make
make install
```

`cbmem` tool should be installed in OS to display help you can type:

```
cbmem -h
```


