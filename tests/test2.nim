import unittest
import web_preprocessor
import os
import macros

test "compile project file":
  let bin = compileProjectFile("sass.nim")
  when defined(windows):
    check bin == absolutePath getProjectPath() / "src" / "web_preprocessor" / "sass.exe"
  else:
    check bin == absolutePath getProjectPath() / "src" / "web_preprocessor" / "sass"
  removeFile(bin)