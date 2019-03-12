
:: 预处理变量 
set Archive.file=
set key.e=

:: 文件夹选择检测 

for %%i in (Unzip) do if /i "%~1"=="%%i" (
	if "%~2"=="" (
		call "%dir.jzip%\Function\Select_Folder.cmd" dir.release
		if not defined dir.release goto :EOF
		dir /a:d /b "!dir.release!" || goto :EOF
	)
	if "%~2"=="/all" (
		set "dir.release=%dir.Archive%\%Archive.name%"
		:dir.release_cycle
		dir "!dir.release!" /a /b >nul 2>nul && (
			set "dir.release=!dir.release! (1)"
			goto :dir.release_cycle
		)
	)
)

:: 单击打开检测 
for %%i in (Open) do if /i "%~1"=="%%i" (
	if not "%~2"=="" (
		set "Archive.file=%~2"
		call :%*
		goto :EOF
	)
)

:: 空选检测 
>nul 2>nul set "listzip.FileSel." || (
	for %%z in (
		Open\1\"%txt_x.type.open%"
		ReName\1\"%txt_x.type.rn%"\"%txt_x.wildcard%"
		Extr\1\"%txt_x.type.extr%"\"%txt_x.wildcard%"\"%txt_x.totmp%"
		Delete\1\"%txt_x.type.del%"\"%txt_x.wildcard%"
		Unzip\2
	) do for /f "usebackq tokens=1-5 delims=\" %%a in ('%%z') do (
		if /i "%~1"=="%%a" (
			if "%%b"=="1" (
				%InputBox% Archive.file "%%~c" " " "%%~d" "%%~e"
				if not defined Archive.file goto :EOF
				set "ui.Archive.file=!Archive.file!"
				if defined listzip.Dir set "Archive.file=!listzip.Dir!\!Archive.file!"
				> "%listzip.txt%o" echo,!Archive.file!
			)
			call :%*
			goto :EOF
		)
	)
)

:: 多项检测 
>nul 2>nul set "listzip.FileSel." && (
	> "%listzip.txt%o" echo,
	for /f "tokens=2 delims==" %%a in ('2^>nul set "listzip.FileSel."') do (
		if "%type.editor%"=="7z" set "Archive.file=!listzip.LineFile.%%a:~53!"
		if "%type.editor%"=="rar" set "Archive.file=!listzip.LineFile.%%a:~41!"
		set "ui.Archive.file=!Archive.file:%listzip.Dir%\=!"
		>> "%listzip.txt%o" echo,!Archive.file!

		for %%i in (Open UnZip ReName) do if /i "%~1"=="%%i" (
			call :%*
			if not "!errorlevel!"=="0" goto :EOF
			if "!key.e!"=="2" goto :EOF
		)
	)
	for %%i in (Extr Delete) do if /i "%~1"=="%%i" (
		call :%*
		goto :EOF
	)
	goto :EOF
)

:: 其他选项检测 
for %%i in (Add Check ReName Repair Note Lock) do if /i "%~1"=="%%i" (
	call :%*
	goto :EOF
)
goto :EOF


::添加文件 
:Add
call "%dir.jzip%\Function\Select_File.cmd" key
set "path.File=!key!"
if not defined path.File goto :EOF

for %%a in (rar,7z) do if "%type.editor%"=="%%a" (
	if defined listzip.Dir (
		for /f "delims=" %%i in ('cscript //nologo "%dir.jzip%\Function\Create_GUID.vbs"') do (
			>nul md "%dir.jzip.temp%\%%i\%listzip.Dir%"
			xcopy "!path.File!" "%dir.jzip.temp%\%%i\%listzip.Dir%" /s /q /h /k
			"!path.editor.%%a!" a -w"%dir.jzip.temp%" "%path.Archive%" "%dir.jzip.temp%\%%i\%listzip.Dir%" %iferror%
			>nul rd /s /q "%dir.jzip.temp%\%%i"
		)
	) else (
		"!path.editor.%%a!" a -w"%dir.jzip.temp%" "%path.Archive%" "!path.File!" %iferror%
	)
)
exit /b %errorlevel%


::打开文件 
:Open
cls

:: EXE 类型询问 
if /i "%Archive.file:~-4%"==".exe" %MsgBox-s% key.e "%txt_x.exetakeall%"
if "%key.e%"=="1" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" "%Archive.file%" %iferror%
)

:: 批处理 类型判断 
for %%i in (cmd bat) do if /i "%Archive.file:~-4%"==".%%i" (
	start /i cmd /c call "%dir.jzip.temp%\%random1%\%Archive.file%"
	goto :EOF
)

start /i "" "%dir.jzip.temp%\%random1%\%Archive.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
exit /b %errorlevel%


::提取文件 
:Extr
cls
if "%type.editor%"=="rar" "%path.editor.rar%" x %btn.utf.b% -y "%path.Archive%" @"%listzip.txt%o" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z" "%path.editor.7z%" x %btn.utf.b% -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%"  @"%listzip.txt%o" %iferror%

start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
exit /b %errorlevel%


::解压文件 
:Unzip
cls
if not defined Archive.file (
	set "Archive.file=*"
)
if defined listzip.Dir (
	for /f "delims=" %%i in ('cscript //nologo "%dir.jzip%\Function\Create_GUID.vbs"') do (
		>nul md "%dir.jzip.temp%\%%i"
		if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" "%dir.jzip.temp%\%%i\" %iferror%
		if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%%i\" "%path.Archive%" "%Archive.file%" %iferror%
		xcopy "%dir.jzip.temp%\%%i\%listzip.Dir%" "%dir.release%" /e /q /h /k
		>nul rd /s /q "%dir.jzip.temp%\%%i"
	)
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" "%Archive.file%" %iferror%
)
exit /b %errorlevel%


::删除文件 
:Delete
if %listzip.FileSel% GTR 1 (
	%MsgBox-s% key.e "%txt_x.del.confirm%" " " "%listzip.FileSel% %txt_items%"
) else (
	%MsgBox-s% key.e "%txt_x.del.confirm%" " " "%ui.Archive.file%"
)

if "!key.e!"=="1" (
	cls
	for %%a in (rar,7z) do if "%type.editor%"=="%%a" (
		"!path.editor.%%a!" d %btn.utf.b% -w"%dir.jzip.temp%" "%path.Archive%" @"%listzip.txt%o" %iferror%
	)
	if not exist "%path.Archive%" %MsgBox% "%txt_x.zip.deled%" & exit /b
)
exit /b %errorlevel%


::重命名文件 
:ReName
set Archive.file.rn=
%InputBox-r% Archive.file.rn "%ui.Archive.file%" "%txt_x.type.rn.new%" " " "%ui.Archive.file%" " " "%txt_x.wildcard%"
if not defined Archive.file.rn set "key.e=2" & goto :EOF
if defined listzip.Dir set "Archive.file.rn=!listzip.Dir!\!Archive.file.rn!"

cls
for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" "%Archive.file.rn%" %iferror%
exit /b %errorlevel%


::压缩档检查 
:Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%path.Archive%" %iferror%
if not "!errorlevel!"=="0" pause
exit /b %errorlevel%


::压缩档修复 
:Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%path.Archive%" %iferror%
if not "!errorlevel!"=="0" pause
exit /b %errorlevel%


::压缩档注释 
:Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%path.Archive%" %iferror%
pause
exit /b %errorlevel%


::压缩档锁定 
:Lock
%MsgBox-s% key.e "%txt_x.lock.confirm%"
if "%key.e%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%" %iferror%
	if not "!errorlevel!"=="0" pause
)
exit /b %errorlevel%

