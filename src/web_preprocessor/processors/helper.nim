import macros
import sequtils
export sequtils

macro prepareParams*(prc: untyped): untyped = 
  # Turn all path to absolute and create dest dir if not exists
  # handle prc(src:string, dest:string; files:seq[string])
  # prc(src, dest:string; files:seq[string])
  if prc.kind notin {nnkProcDef, nnkLambda, nnkMethodDef, nnkDo}:
    error("Cannot transform this node kind into an cached_property proc." &
          " proc/method definition or lambda node expected.")
  result = prc
  let oldBody = prc.body
  var body = nnkStmtList.newTree()
  let paramsLen = prc.params.len
  var src,dest,files:NimNode
  if paramsLen == 3:
    src = prc.params[1][0]
    dest = prc.params[1][1]
    files = prc.params[2][0]
  elif paramsLen == 4:
    src = prc.params[1][0]
    dest = prc.params[2][0]
    files = prc.params[3][0]
  let absDest = ident(dest.strVal)
  body.add newLetStmt(ident(src.strVal),newCall("absolutePath",src))
  body.add newLetStmt(absDest,newCall("absolutePath",dest))
  body.add nnkDiscardStmt.newTree newCall("existsOrCreateDir",absDest)
  body.add newLetStmt(ident(files.strVal), newCall("mapIt",files,newCall("absolutePath",ident"it")))
  for item in oldBody:
    body.add item
  result.body = body