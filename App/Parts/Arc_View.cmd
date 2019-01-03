echo.
echo. 请键入要打开的单个文件：
echo.
echo. 注：通配符不可用。
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF

echo.%Archive.file%|findstr *>nul&&(echo.抱歉，通配符不可用。& pause>nul& goto :EOF)

set "random1=%random%%random%"
set "Archive.file=%Archive.file:"=%"

if "%Archive.file:~-4%"==".exe" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" "%Archive.file%" %iferror%
)

start "" "%dir.jzip.temp%\%random1%\%Archive.file%"
goto :EOF