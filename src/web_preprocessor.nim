import tables
import os
import web_preprocessor/fileutils
export fileutils

const pkgDeps = {".scss": @["nim-sass"]}.toTable

proc getDeps*(dir:string = getCurrentDir()):seq[string] =
  let exts = getExts(dir)
  for ext in exts:
    if ext in pkgDeps:
      result.add pkgDeps[ext]

proc installDeps*(dir:string = getCurrentDir()) = 
  let deps = getDeps(dir)