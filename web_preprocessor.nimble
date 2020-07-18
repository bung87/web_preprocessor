# Package

version       = "0.1.0"
author        = "bung87"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
installDirs   = @["web_preprocessorpkg/processors"]
bin = @["web_preprocessor"]


# Dependencies

requires "nim >= 1.3.5"
requires "stage"
requires "cligen"
