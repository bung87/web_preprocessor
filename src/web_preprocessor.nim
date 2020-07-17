import tables
import os
import sequtils
import web_preprocessor/fileutils
import web_preprocessor/shellutils
import web_preprocessor/pkgutils
export fileutils
export shellutils
export pkgutils


const pkgDeps = {".scss": @["https://github.com/zacharycarter/nim-sass"]}.toTable

const dep2pro = {"nim_sass":"sass"}.toTable

proc getDeps*(dir: string = getCurrentDir()): seq[string] =
  ## get all dependencies throght files extensions.
  let exts = getExts(dir)
  for ext in exts:
    if ext in pkgDeps:
      result.add pkgDeps[ext]

proc installDeps*(dir: string = getCurrentDir(),deps = getDeps(dir)) =
  install(deps)

proc isInstalled*(pkgUriOrName: string): bool =
  let pkgName = pathToValidPackageName(pkgUriOrName)
  let pkgs = listInstalled()
  pkgName in pkgs

proc isInstalled*(pkgUriOrName: string, pkgs: seq[string]): bool =
  let pkgName = pathToValidPackageName(pkgUriOrName)
  pkgName in pkgs


when isMainModule:
  let deps = getDeps()
  let notInstalled = deps.filterIt( not isInstalled(it) )
  if notInstalled.len > 0:
    install(notInstalled)
  echo notInstalled
  let namedDeps = deps.mapIt( pathToValidPackageName(it) )
  let names = namedDeps.mapIt( dep2pro[it] )
  for name in names:
    if not processorExists(name):
      discard compileProcessor( name )