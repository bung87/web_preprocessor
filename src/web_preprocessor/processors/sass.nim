
import nim_sass
import os
import helper

proc processFiles(src:string, dest:string; files:seq[string];production = false){.prepareParams.} = 
  var rel:string
  for file in files:
    var fileCtx: ptr Sass_File_Context = sass_make_file_context(file)
    let options = sass_file_context_get_options(fileCtx)
    sass_option_set_precision(options, 1)
    sass_option_set_source_comments(options, not production)

    sass_file_context_set_options(fileCtx, options)

    let compiler = sass_make_file_compiler(fileCtx)
    discard sass_compiler_parse(compiler)
    discard sass_compiler_execute(compiler)

    let ctx = sass_file_context_get_context(fileCtx)
    let output = sass_context_get_output_string(ctx)
    # Retrieve errors during compilation
    let error_status = sass_context_get_error_status(ctx)
    let json_error = sass_context_get_error_json(ctx)
    debugEcho json_error
    # Release memory dedicated to the C compiler
    sass_delete_compiler(compiler)

    assert error_status == 0
    assert json_error.isNil
    rel = relativePath(file, src)
    writeFile( dest / rel.changeFileExt("css"), $output)

when isMainModule:
  #sass -s tests/static/ -d dest in.scss
  import cligen
  dispatch(processFiles)