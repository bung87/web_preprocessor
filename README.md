# web_preprocessor  

a cli tool write in Nim 
web assets preprocessor compile sass,optimize png,optimize jpg  

## Installation  

`nimble install https://github.com/bung87/web_preprocessor`  


## Dependencies  

Automatically install dependencies( only nimble packages, shared libraries need install by yourself) when `web_preprocessor` find specific file extensions  

sass compilation requires [libsass](https://github.com/sass/libsass) shared library  
jpg optimization requires [mozjpeg](https://github.com/mozilla/mozjpeg) shared library  
png optimization dependencies are all in pure Nim 

## Usage  
```
web_preprocessor [required&optional-params] 
-s=, --srcDir=    string  REQUIRED  set srcDir
-d=, --destDir=   string  REQUIRED  set destDir
-p, --production  bool    false     set production
```
