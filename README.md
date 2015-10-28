# FilePath [![Hackage version](https://img.shields.io/hackage/v/filepath.svg?label=Hackage)](https://hackage.haskell.org/package/filepath) [![Linux Build Status](https://img.shields.io/travis/haskell/filepath.svg?label=Linux%20build)](https://travis-ci.org/haskell/filepath) [![Windows Build Status](https://img.shields.io/appveyor/ci/ndmitchell/filepath.svg?label=Windows%20build)](https://ci.appveyor.com/project/ndmitchell/filepath)

The `filepath` package provides functionality for manipulating `FilePath` values, and is shipped with both [GHC](https://www.haskell.org/ghc/) and the [Haskell Platform](https://www.haskell.org/platform/). It provides three modules:

* [`System.FilePath.Posix`](http://hackage.haskell.org/package/filepath/docs/System-FilePath-Posix.html) manipulates POSIX/Linux style `FilePath` values (with `/` as the path separator).
* [`System.FilePath.Windows`](http://hackage.haskell.org/package/filepath/docs/System-FilePath-Windows.html) manipulates Windows style `FilePath` values (with either `\` or `/` as the path separator, and deals with drives).
* [`System.FilePath`](http://hackage.haskell.org/package/filepath/docs/System-FilePath.html) is an alias for the module appropriate to your platform.

All three modules provide the same API, and the same documentation (calling out differences in the different variants).
