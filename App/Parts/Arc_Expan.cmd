
::调用接口
if not "%~1"=="" call :%*
goto :EOF


:Open
if "%~1"=="" (
	call :InputBox Archive.file "请输入打开的文件名："
	if not defined Archive.file goto :EOF
	echo.%Archive.file% | findstr "* ?" >nul && (call :msgbox "通配符不可用。" & goto :EOF)
) else (
	set "Archive.file=%~1"
)

cls
if "%Archive.file:~-4%"==".exe" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" "%Archive.file%" %iferror%
)
echo.%Archive.file.dir%
start /i "" "%dir.jzip.temp%\%random1%\%Archive.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


:UnPart
call :InputBox Archive.file "请键入要取出的文件/夹：" "可以使用通配符。" "提取的文件将置于临时文件夹。"
if not defined Archive.file goto :EOF

if "%type.editor%"=="rar"  "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


:Unzip
if "%~1"=="/all" (
	set "dir.release=%dir.Archive%\%Archive.name%_unzip"
) else (
	call "%dir.jzip%\Parts\Select_Folder.cmd"
	if not defined key goto :EOF
	dir /a:d /b "!key!" && set "dir.release=!key!" || goto :EOF
)
cls

if not defined listzip.Dir (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" %iferror%
)
if defined listzip.Dir (
	if "%type.editor%"=="rar" "%path.editor.rar%" x  "%path.Archive%" "%listzip.Dir%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\"  "%path.Archive%" "%listzip.Dir%" %iferror%
)
goto :EOF


:Delete
call :InputBox Archive.file "请键入要删除的文件/夹：" "可以使用通配符。"
if not defined Archive.file goto :EOF
cls
for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" %iferror%
goto :EOF


:ReName
call :InputBox Archive.file "请键入要重命名的文件/夹：" "可以使用通配符。"
if not defined Archive.file goto :EOF
call :InputBox Archive.file.rn "请键入文件/夹的新名字：" "可以使用通配符。"
if not defined Archive.file.rn goto :EOF

for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" "%Archive.file.rn%" %iferror%
goto :EOF


:Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%path.Archive%" %iferror%
pause
goto :EOF


:Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%path.Archive%" %iferror%
pause
goto :EOF


:Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%path.Archive%" %iferror%
pause
goto :EOF


:Lock
call :msgbox2 key "锁定压缩文件后不可修改，确认锁定？"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%" %iferror%
	pause
)
goto :EOF


::调用组件
:InputBox
set "%~1="
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("%~2"&vbCrLf&vbCrLf&"%~3"&vbCrLf&"%~4","提示"))(window.close)"') do (
	if not defined listzip.Dir set "%~1=%%~a"
	if defined listzip.Dir set "%~1=!listzip.Dir!\%%~a"
)
goto :EOF

:msgbox
mshta "vbscript:msgbox("%~1",64,"提示")(window.close)"
goto :EOF

:msgbox2
set "%~1="
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox("%~2",1+64,"提示"))(window.close)"') do (
	set "%~1=%%a"
)
goto :EOF

