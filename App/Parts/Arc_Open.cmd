
if not "%~1"=="" set "Archive.file=%~1"

if "%~1"=="" (
	set "Archive.file="
	for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("请输入打开的文件名：","提示"))(window.close)"') do (
		set "Archive.file=%%~a"
	)
	if not defined Archive.file goto :EOF
)

echo.%Archive.file% | findstr "* ?" >nul && (mshta "vbscript:msgbox("通配符不可用。",64,"提示")(window.close)" & goto :EOF)

set "Archive.file=%Archive.file:"=%"

cls
if "%Archive.file:~-4%"==".exe" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" "%Archive.file%" %iferror%
)

start /i "" "%dir.jzip.temp%\%random1%\%Archive.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%random1%"

goto :EOF