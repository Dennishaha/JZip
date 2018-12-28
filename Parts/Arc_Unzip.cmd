
if "%ArchiveOrder%"=="list" (
	call :Set_Unzip 
	if "%dir.typein%"=="" set "dir.release=%dir.Archive%"
	if "%dir.typein%"=="1" set "dir.release=%dir.Archive%\%Archive.name%"
	if "%dir.typein%"=="0" goto :EOF
)

if "%dir.typein%"=="" set "dir.release=%dir.Archive%"

if exist "%dir.release%" set "dir.release=%dir.Archive%\%Archive.name%_folder"

if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%dir.release%\" %iferror%
if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" %iferror%

echo.------------------------------------------------------------------------------
echo.
echo.    生成路径：
echo.     %dir.release%\
echo.
echo.                                    [回车] 好
pause>nul
goto :EOF

:Set_Unzip
echo.
echo. [回车] 解压到 %dir.Archive%\
echo.    [1] 解压到 %dir.Archive%\%Archive.name%\
echo.
echo. 或者键入自定义路径解压   [0] 返回
echo.
set dir.typein=&set /p dir.typein=
goto :EOF
