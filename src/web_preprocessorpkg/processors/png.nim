
import zopflipng
import os
import helper

proc processFiles(src:string, dest:string; files:seq[string];production = false){.prepareParams.} = 
  var rel:string
  for file in files:
    rel = relativePath(file, src)
    createDir(parentDir(dest / rel))
    optimizePNG(file, dest / rel)

when isMainModule:
  # png -s tests/static/ -d dest logo.png
  import cligen
  dispatch(processFiles)