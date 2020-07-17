import os
import strutils

proc exec(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    quit "External command failed: " & cmd

proc install*(pkgs:varargs[string]) = 
  let pkgsStr = pkgs.join(" ")
  exec("nimble install -y " & pkgsStr )