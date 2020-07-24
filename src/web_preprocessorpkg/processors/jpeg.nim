
import mozjpeg
import os
import helper

proc processFiles(src:string, dest:string; files:seq[string];production = false){.prepareParams.} = 
  var rel:string
  for file in files:
    rel = relativePath(file, src)
    createDir(parentDir(dest / rel))
    optimizeJPG(file,75,false, dest / rel)

when isMainModule:
  # jpeg -s tests/static/ -d dest logo.png
  import cligen
  dispatch(processFiles)