# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import posix_utils
import web_preprocessor
import os
import algorithm

suite "test basic":
  var temp: string
  var files: seq[string]
  setup:
    temp = mkdtemp("exts")
    files = @[temp / "a.scss", temp / "a.jpg", temp / "a.png"]
    for f in files:
      writeFile(f, "")
  teardown:
    removeDir(temp)
  test "can get list of extensions":
    check getExts(temp).sorted == @[".jpg", ".scss", ".png"].sorted
  test "can get list of pkgs":
    check getDeps(temp).sorted == @["https://github.com/zacharycarter/nim-sass",
        "https://github.com/bung87/zopflipng"].sorted


