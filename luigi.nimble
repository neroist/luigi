# Package

version       = "0.1.0"
author        = "Jasmine"
description   = "Nim wrapper of Luigi UI library"
license       = "MIT"
srcDir        = "src"


# Tasks

after install:
  ## Download freetype headers

  echo "\nDownloading freetype headers..."

  # clone main repository
  exec "git clone -q https://gitlab.freedesktop.org/freetype/freetype.git"

  # copy files
  cpDir "freetype/include/freetype", "luigi/source/freetype/freetype"
  cpFile "freetype/include/ft2build.h", "luigi/source/freetype/ft2build.h"

  # clean up
  rmDir "freetype"

# Dependencies

requires "nim >= 1.2.0"
requires "freetype >= 0.1.2"
