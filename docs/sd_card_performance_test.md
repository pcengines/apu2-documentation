SD card performance test
-------------------------

Tests can be executed using iozone:

```
apt-get install iozone3
```

An example use of iozone:

```
iozone -e -a -s 4g -r 16M -i 0 -i 1
```

```
-s 4g - file size = 4GB
-r 16m - record size = 16MB (maximum)
-i 0 - write/rewrite test
-i 1 - read/reread test
```

In order to receive valid results (especially in read tests) file size needs to
be big enough. For APU2 it was 4GB. This value can vary, depending on platform.
It is related to system buffer.
