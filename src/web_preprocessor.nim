import tables
import os
import sequtils
import strutils
import algorithm
import web_preprocessorpkg/fileutils
import web_preprocessorpkg/shellutils
import web_preprocessorpkg/pkgutils
import strformat
import json, md5

export fileutils
export shellutils
export pkgutils

const jpgDeps = ["https://github.com/bung87/mozjpeg"]

const pkgDeps = {".scss": @["https://github.com/zacharycarter/nim-sass"], ".png": @[
    "https://github.com/bung87/zopflipng"],".jpg": @jpgDeps ,".jpeg": @jpgDeps}.toTable

const dep2pro = {"nim_sass": "sass", "zopflipng": "png","mozjpeg": "jpeg"}.toTable

const ext2pro = {".scss": "sass", ".png": "png",".jpeg": "jpeg",".jpg": "jpeg"}.toTable

proc getDeps*(dir: string = getCurrentDir()): seq[string] =
  ## get all dependencies throght files extensions.
  let exts = getExts(dir)
  for ext in exts:
    if ext in pkgDeps:
      result.add pkgDeps[ext]

proc getDeps*(files: seq[string]): seq[string] =
  ## get all dependencies throght files extensions.
  let exts = getExts(files)
  for ext in exts:
    if ext in pkgDeps:
      result.add pkgDeps[ext]

proc installDeps*(dir: string = getCurrentDir(), deps = getDeps(dir)) =
  install(deps)

proc isInstalled*(pkgUriOrName: string): bool =
  let pkgName = pathToValidPackageName(pkgUriOrName)
  let pkgs = listInstalled()
  pkgName in pkgs

proc isInstalled*(pkgUriOrName: string, pkgs: seq[string]): bool =
  let pkgName = pathToValidPackageName(pkgUriOrName)
  pkgName in pkgs

proc processExtTable(tbl: var Table[string, seq[string]], ext: string, rel: string) =
  if tbl.hasKey(ext):
    tbl[ext].add rel
  else:
    tbl[ext] = @[rel]


proc main(srcDir, destDir: string, production = false) =
  let files = toSeq(walkDirRec(srcDir)).filterIt(splitFile(it)[2].len > 0)
  let deps = getDeps(files)
  let notInstalled = deps.filterIt(not isInstalled(it))
  if notInstalled.len > 0:
    install(notInstalled)
  debugEcho "not installed:" & $notInstalled
  let namedDeps = deps.mapIt(pathToValidPackageName(it))
  let names = namedDeps.mapIt(dep2pro[it])
  for name in names:
    if not processorExists(name):
      discard compileProcessor(name)
  var dir, name, ext: string
  var extTable: Table[string, seq[string]]
  var manifest: Table[string, string]
  if not fileExists("manifest.json"):
    var f = open("manifest.json", fmWrite)
    var rel: string
    for path in files:
      (dir, name, ext) = splitFile(path)
      rel = relativePath(path, getCurrentDir())
      processExtTable(extTable, ext, rel)
      manifest[rel] = getMD5(readFile(path))
    let output = pretty(%*manifest)
    f.write(output)
    f.close()
    echo output
  else:
    manifest = parseFile("manifest.json").to(Table[string, string])
    var fileChanged = newSeq[string]()
    var rel: string
    for path in files:
      (dir, name, ext) = splitFile(path)
      rel = relativePath(path, getCurrentDir())
      if manifest[rel] != getMD5(readFile(path)):
        processExtTable(extTable, ext, rel)

  debugEcho "manifest:" & $manifest
  debugEcho "ext table:" & $extTable
  let productionFlag = if production: "-p" else: ""
  var rel: string
  for k, v in extTable:
    if k in ext2pro: # need process
      let (output, exitCode) = runProcessor(ext2pro[k], &"-s {srcDir} -d {destDir} {productionFlag} " & v.join(" "))
      debugEcho output
    else:
      for file in v:
        if file.len == 0:
          continue
        rel = relativePath(file, srcDir)
        createDir(parentDir(destDir / rel))
        copyFile(file, destDir / rel)
  if currentSourcePath.parentDir().parentDir() == getCurrentDir():
    removeFile("manifest.json")

when isMainModule:
  import cligen
  dispatch(main)
