Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
apuX platform users and developers to customize firmware to their needs.

Binary releases
---------------

All information about firmware releases (including changes, fixes and known
issues) are available on the PC Engines Github site:
https://pcengines.github.io/

All the newest binaries can be found there.


Also lease take a look at changelogs:

* [v4.6.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.6.x/CHANGELOG.md)
* [v4.5.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.5.x/CHANGELOG.md)
* [v4.0.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.0.x/CHANGELOG.md)




Building firmware using PC Engines firmware builder
---------------------------------------------------

Since releases v4.6.9 and v4.0.17 build process has been simplified.
PC Engines firmware builder is a dedicated tool to build fully featured apu
firmware binaries using separated docker environment. It provides users-friendly
scripts that allow to build release and custom binaries. For more information
and usage details please visit: https://github.com/pcengines/pce-fw-builder

For releases older than v4.0.17 and v4.6.9 use the procedure described in this
[document](docs/release_process.md)


Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
