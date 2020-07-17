import unittest
import web_preprocessor

suite "test to pkg name":
  test "with .git":
    check pathToValidPackageName("https://github.com/zacharycarter/nim-sass.git") == "nim_sass"
  test "with .git and #head":
    check pathToValidPackageName("https://github.com/zacharycarter/nim-sass.git#head") == "nim_sass"
  test "pure pkg name":
    check pathToValidPackageName("nim_sass") == "nim_sass"
