
import nim_sass
import os
import helper
import strutils
template debugLog(body) = 
  when not defined(release):
    debugEcho body

proc processFiles(src:string, dest:string; files:seq[string];production = false){.prepareParams.} = 
  var rel:string
  var fileCtx: ptr Sass_File_Context 
  var options: ptr nim_sass.context.Sass_Options
  var compiler:ptr nim_sass.context.Sass_Compiler
  var ctx:ptr Sass_Context 
  var output:cstring
  var error_status:cint
  var json_error:cstring
  for file in files:
    if extractFilename(file).startsWith('_'):
      continue
    fileCtx = sass_make_file_context(file)
    options = sass_file_context_get_options(fileCtx)
    sass_option_set_precision(options, 1)
    sass_option_set_source_comments(options, not production)

    sass_file_context_set_options(fileCtx, options)

    compiler = sass_make_file_compiler(fileCtx)
    discard sass_compiler_parse(compiler)
    discard sass_compiler_execute(compiler)

    ctx = sass_file_context_get_context(fileCtx)
    output = sass_context_get_output_string(ctx)
    # Retrieve errors during compilation
    error_status = sass_context_get_error_status(ctx)
    json_error = sass_context_get_error_json(ctx)
    stderr.write json_error
    # Release memory dedicated to the C compiler
    sass_delete_compiler(compiler)

    assert error_status == 0
    assert json_error.isNil
    rel = relativePath(file, src)
    createDir(parentDir(dest / rel))
    writeFile( dest / rel.changeFileExt("css"), $output)

when isMainModule:
  #sass -s tests/static/ -d dest in.scss
  import cligen
  dispatch(processFiles)