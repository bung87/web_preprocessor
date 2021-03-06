import os
import osproc
import strutils
import shellutils

proc toValidPackageName*(name: string): string =
  result = ""
  for c in name:
    case c
    of '_', '-':
      if result[^1] != '_': result.add('_')
    of AllChars - IdentChars - {'-'}: discard
    else: result.add(c)

proc pathToValidPackageName*(path:string):string =
  let noExt = path.changeFileExt("")
  noExt.splitPath.tail.toValidPackageName()

proc listInstalled*():seq[string] = 
  const cmd = "nimble list --installed"
  let (output,exitCode) = execCmdEx( cmd )
  if not exitCode == 0:
    quit "External command failed: " & cmd
  var current:string
  for line in  output.splitLines():
    for c in line :
      if c in IdentChars:
        current.add c
      else:
        break
    if current.len > 0 :
      result.add current
    current = ""

proc install*(pkgs:openarray[string]) = 
  let pkgsStr = pkgs.join(" ")
  exec("nimble install -y " & pkgsStr )