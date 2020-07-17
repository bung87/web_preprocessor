import os

const currentDir = currentSourcePath.parentDir()

proc exec*(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    quit "External command failed: " & cmd

proc toBin*( file: string):string = 
  when defined(windows):
    result = file.changeFileExt("exe")
  else:
    result = file.changeFileExt("")

proc compileProjectFile*(file:string):string = 
  let abs = currentDir / file
  result = toBin( abs )
  exec("nim c -d:release " & abs )

proc compileProcessor*(name:string ):string = 
  compileProjectFile( "processors" / name & ".nim" )

proc processorExists*(name:string):bool = 
  fileExists( currentDir / "processors" / name )