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


Also please take a look at changelogs:

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

Branch description
------------------

* `master` - keeps track of [coreboot's master branch](https://review.coreboot.org/cgit/coreboot.git/log/)
* `release` - where all releases are merged
* `develop` - where current development takes place periodically synced with
  coreboot master
* `rel_x.y.z` - release branches described below

# Steps for new release

1. Create new branch `rel_x.y.z`, where:
    * `x` is coreboot major version
    * `y` is coreboot minor version
    * `z` is PC Engines firmware fork patch number
2. Create PR for all required changes for version `rel_x.y.z`
3. When all changes pushed we closing merge window and start testing - this is
   typically first week of each month
4. Perform automated regression testing on `rel_x.y.z`
5. Fix all required issues and repeat point 4 until fixed - this doesn't mean
   all tests pass, this mean that approved set passed
6. If results are accepted merge it to `release` branch
7. Add tag, which should trigger CI and publish binaries
8. Merge release branch to develop

# Feature/bug fix development

1. Update `develop` by margining coreboot's master
2. Checkout feature branch from `develop`
3. Commit changes to feature branch
4. Run regression tests
5. Setup PR to `develop`

Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
