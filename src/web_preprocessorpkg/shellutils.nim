import os
import osproc
import strutils

proc getCurrentPkgDir():string =
  let cmd = "nimble path web_preprocessor"
  let (output,exitCode) = execCmdEx( cmd )
  if exitCode != 0:
    quit "External command failed: " & cmd
  output.strip

proc exec*(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    quit "External command failed: " & cmd

proc toBin*( file: string):string = 
  when defined(windows):
    result = file.changeFileExt("exe")
  else:
    result = file.changeFileExt("")

proc compileProjectFile*(file:string):string = 
  let abs = getCurrentPkgDir() / file
  result = toBin( abs )
  exec("nim c -d:release " & abs )

proc runProcessor*(name:string,args:string): (string,int) =
  let oName = getCurrentPkgDir() / "processors" / name
  let binName = toBin(oName)
  # os.execShellCmd( binName & " " & args)
  execCmdEx( binName & " " & args )

proc compileProcessor*(name:string ):string = 
  compileProjectFile( "processors" / name & ".nim" )

proc processorExists*(name:string):bool = 
  fileExists( getCurrentPkgDir() / "processors" / name )