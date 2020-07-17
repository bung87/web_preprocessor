import unittest
import web_preprocessor
import os

suite "test project pkgs":
  setup:
    const cmd = "nimble install -y -d"
    if os.execShellCmd(cmd) != 0:
      quit "External command failed: " & cmd
  test "can list installed pkgs":
    check "stage" in listInstalled()
  test "can check pkg installed":
    check isInstalled("stage") == true

