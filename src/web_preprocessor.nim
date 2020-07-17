import tables
import os
import sequtils
import web_preprocessor/fileutils
import web_preprocessor/shellutils
export fileutils
export shellutils


const pkgDeps = {".scss": @["https://github.com/zacharycarter/nim-sass"]}.toTable

proc getDeps*(dir: string = getCurrentDir()): seq[string] =
  let exts = getExts(dir)
  for ext in exts:
    if ext in pkgDeps:
      result.add pkgDeps[ext]

proc installDeps*(dir: string = getCurrentDir()) =
  let deps = getDeps(dir)
  # let namedDeps = deps.mapIt( pathToValidPackageName(it)  )
  install(deps)

proc isInstalled*(pkgUriOrName:string):bool = 
  let pkgName = pathToValidPackageName(pkgUriOrName)
  let pkgs= listInstalled()
  pkgName in pkgs

proc isInstalled*(pkgUriOrName:string,pkgs: seq[string]):bool = 
  let pkgName = pathToValidPackageName(pkgUriOrName)
  pkgName in pkgs

when isMainModule:
  installDeps()