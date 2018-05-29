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
* `feature_branch` - sample feature branch name for workflow explanation needs

# Feature/bug fix development

We are in favor of [Test Driven Bug Fixing (TDBF)](https://geeknarrator.com/2018/01/28/test-driven-bug-fixing-guidelines/).

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Push `coreboot's master branch` to `master`
3. Update `develop` by `master`
4. Checkout `feature_branch` from `develop`
5. Commit changes to `feature_branch`
6. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
7. Submit PR to `develop`

# Steps for new release

1. Checkout new branch `rel_x.y.z` from recent commit on `release`, where:
    * `x` is coreboot major version
    * `y` is coreboot minor version
    * `z` is PC Engines firmware fork patch number
2. Merge current `develop` to `rel_x.y.z`
3. End of month we close merge window
4. Perform automated regression testing on `rel_x.y.z` including all new tests
5. Fix all required issues and repeat point 4 until fixed - this doesn't mean
   all tests pass, this mean that approved set passed
6. If results are accepted merge it to `release` branch
7. Add tag, which should trigger CI and publish binaries
8. Merge release branch to develop

Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
