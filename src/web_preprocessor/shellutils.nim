import os
import strutils
import osproc

const currentDir = currentSourcePath.parentDir()

proc toValidPackageName*(name: string): string =
  result = ""
  for c in name:
    case c
    of '_', '-':
      if result[^1] != '_': result.add('_')
    of AllChars - IdentChars - {'-'}: discard
    else: result.add(c)

proc exec(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    quit "External command failed: " & cmd

proc install*(pkgs:openarray[string]) = 
  let pkgsStr = pkgs.join(" ")
  exec("nimble install -y " & pkgsStr )

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

proc compileProjectFile*(file:string):string = 
  when defined(windows):
    result = (currentDir / file).changeFileExt("exe")
  else:
    result = (currentDir / file).changeFileExt("")
  exec("nim c -d:release " & currentDir / file)

when isMainModule:
  echo listInstalled()