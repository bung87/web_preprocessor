import os

proc getExts*(srcDir:string):seq[string] = 
  var dir,name,ext:string
  for path in walkDirRec(srcDir):
    (dir, name, ext) = splitFile(path)
    if ext notin result:
      result.add ext
      