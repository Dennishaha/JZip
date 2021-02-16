
:: 预处理变量 
set Arc.file=
set key.e=

:: 文件夹选择检测 
if /i "%~1"=="Unzip" (
	if not defined Arc.Do (
		if "%~2"=="" (
			call "%dir.jzip%\Function\Select_Folder.cmd" dir.release
			if not defined dir.release goto :EOF
			dir /a:d /b "!dir.release!" || goto :EOF

			:: 目标文件夹权限检测 
			net session >nul 2>nul || >nul 2>nul (
				>"!dir.release!%Arc.Guid%.tmp" echo; && (
					del /q "!dir.release!%Arc.Guid%.tmp"
				) || (
					set "Arc.Uac=y"
				)
			)
		)
		if "%~2"=="/unzip" (
			set "dir.release=%Arc.dir%\%Arc.name%"
			:dir.release_cycle
			dir "!dir.release!" /a /b >nul 2>nul && (
				set "dir.release=!dir.release! (1)"
				goto :dir.release_cycle
			)

			:: 目标文件夹权限检测 
			net session >nul 2>nul || >nul 2>nul (
				ren "%Arc.path%" "%Arc.name%%Arc.exten%" || (
					%sudo% "%path.jzip.launcher%" unzip "%Arc.path%" 
					if "!sudoback!"=="1" (exit /b) else (exit)
				)
			)
		)
	)

	if defined Arc.Do (
		if not defined dir.release goto :EOF
	)
)

:: JZip 权限提升准备 
for %%i in (Unzip Add Delete ReName Repair Lock Note Sfx) do if /i "%~1"=="%%i" (
	if defined Arc.Uac (
		:: 保存临时配置到注册表
		for %%a in (dir.release lz.Dir lz.Menu lz.search lz.FileSel) do (
			for /f "tokens=1 delims==" %%b in ('2^>nul set "%%a"') do >nul (
				reg add "HKCU\Software\JFsoft.Jzip\Recent\@\%Arc.Guid%" /t REG_SZ /v "%%b" /d "!%%b!;" /f %iferror%
			)
		)
		%sudo% "%path.jzip.launcher%" list "%Arc.path%" --%%i //%Arc.Guid%
		if "!sudoback!"=="1" (exit /b) else (exit)
	)
)

:: 空选检测 
>nul 2>nul set "lz.FileSel." || (
	for %%z in (
		Open\1\"%txt_x.type.open%"
		ReName\1\"%txt_x.type.rn%"\"%txt_x.wildcard%"
		Extr\1\"%txt_x.type.extr%"\"%txt_x.wildcard%"\"%txt_x.totmp%"
		Delete\1\"%txt_x.type.del%"\"%txt_x.wildcard%"
		Unzip\2
	) do for /f "usebackq tokens=1-5 delims=\" %%a in ('%%z') do (
		if /i "%~1"=="%%a" (
			if "%%b"=="1" (
				%InputBox% Arc.file "%%~c" " " "%%~d" "%%~e"
				if not defined Arc.file goto :EOF
				set "ui.Arc.file=!Arc.file!"
				if defined lz.Dir set "Arc.file=!lz.Dir!\!Arc.file!"
				md "%lz.txt%" >nul 2>nul
				> "%lz.txt%\ld" echo;!Arc.file!
			)
			call :%*
			goto :EOF
		)
	)
)

:: 多项检测 
>nul 2>nul set "lz.FileSel." && (
	<nul set /p =".."
	md "%lz.txt%" >nul 2>nul && goto :EOF

	< "%lz.txt%\lzs" (
		for /l %%i in (0 1 %lz.LnRawEnd%) do set /p lz.LnRaw.%%i=
	)

	for %%z in (
		7z:53,rar:41
	) do for /f "tokens=1-2 delims=:" %%a in ("%%z") do (
		if "%type.editor%"=="%%a" (
			> "%lz.txt%\ld" (
				for /f "tokens=2 delims==" %%i in ('set "lz.FileSel."') do echo;!lz.LnRaw.%%i:~%%b!
			)

			for /f "tokens=2 delims==" %%i in ('set "lz.FileSel."') do (
				set "Arc.file=!lz.LnRaw.%%i:~%%b!"
				if defined lz.Dir (
					set "ui.Arc.file=!Arc.file:%lz.Dir%\=!"
				) else (
					set "ui.Arc.file=!Arc.file!"
				)
				call :%*
				if not "!errorlevel!"=="0" goto :EOF
				if "!key.e!"=="2" goto :EOF
				for %%k in (Extr Delete) do if /i "%~1"=="%%k" goto :EOF
			)
		)
	)
)

:: 其他选项检测 
for %%i in (Add Check Repair Note Lock Sfx) do if /i "%~1"=="%%i" (
	call :%*
	goto :EOF
)
goto :EOF


:: 添加文件 
:Add
call "%dir.jzip%\Function\Select_File.cmd" key
set "path.File=!key!"
if not defined path.File goto :EOF

cls
if defined lz.Dir (
	for /f "delims=" %%i in ('powershell -noprofile -command "&{ [guid]::NewGuid().ToString()}"') do (
		>nul md "%dir.jzip.temp%\%%i\%lz.Dir%"
		xcopy "!path.File!" "%dir.jzip.temp%\%%i\%lz.Dir%" /s /q /h /k
		if "%type.editor%"=="7z" "!path.editor.7z!" a -w"%dir.jzip.temp%" "%Arc.path%" "%dir.jzip.temp%\%%i\%lz.Dir%" %iferror%
		if "%type.editor%"=="rar" "!path.editor.rar!" a -ep1 -w"%dir.jzip.temp%" "%Arc.path%" "%dir.jzip.temp%\%%i\%lz.Dir%" %iferror%
		>nul rd /s /q "%dir.jzip.temp%\%%i"
	)
) else (
	if "%type.editor%"=="7z" "!path.editor.7z!" a -w"%dir.jzip.temp%" "%Arc.path%" "!path.File!" %iferror%
	if "%type.editor%"=="rar" "!path.editor.rar!" a -ep1 -w"%dir.jzip.temp%" "%Arc.path%" "!path.File!" %iferror%
)

exit /b %errorlevel%


:: 打开文件 
:Open
cls

:: EXE 类型询问 
if /i "%Arc.file:~-4%"==".exe" %MsgBox-s% key.e "%txt_x.exetakeall%"
if "%key.e%"=="1" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%Arc.path%" %dir.jzip.temp%\%Arc.Guid%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%Arc.Guid%" -y "%Arc.path%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%Arc.path%" "%Arc.file%" %dir.jzip.temp%\%Arc.Guid%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%Arc.Guid%" -y "%Arc.path%" "%Arc.file%" %iferror%
)

:: 批处理 类型判断 
for %%i in (cmd bat ps1) do if /i "%Arc.file:~-4%"==".%%i" (
	start /i "%ComSpec%" /c call "%dir.jzip.temp%\%Arc.Guid%\%Arc.file%"
	goto :EOF
)

start /i "" "%dir.jzip.temp%\%Arc.Guid%\%Arc.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%Arc.Guid%\%lz.Dir%"
exit /b %errorlevel%


:: 提取文件 
:Extr
cls
if "%type.editor%"=="rar" "%path.editor.rar%" x %btn.utf.b% -y "%Arc.path%" @"%lz.txt%\ld" %dir.jzip.temp%\%Arc.Guid%\ %iferror%
if "%type.editor%"=="7z" "%path.editor.7z%" x %btn.utf.b% -o"%dir.jzip.temp%\%Arc.Guid%" -y "%Arc.path%"  @"%lz.txt%\ld" %iferror%

start "" "%dir.jzip.temp%\%Arc.Guid%\%lz.Dir%"
exit /b %errorlevel%


:: 解压文件 
:Unzip
cls
if not defined Arc.file (
	set "Arc.file=*"
)
if defined lz.Dir (
	for /f "delims=" %%i in ('powershell -noprofile -command "&{ [guid]::NewGuid().ToString()}"') do (
		>nul md "%dir.jzip.temp%\%%i"
		if "%type.editor%"=="rar" "%path.editor.rar%" x "%Arc.path%" "%Arc.file%" "%dir.jzip.temp%\%%i\" %iferror%
		if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%%i\" "%Arc.path%" "%Arc.file%" %iferror%
		xcopy "%dir.jzip.temp%\%%i\%lz.Dir%" "%dir.release%\*" /e /q /h /k
		>nul rd /s /q "%dir.jzip.temp%\%%i"
	)
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%Arc.path%" "%Arc.file%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%Arc.path%" "%Arc.file%" %iferror%
)
exit /b %errorlevel%


:: 删除文件 
:Delete
if %lz.FileSel% GTR 1 (
	%MsgBox-s% key.e "%txt_x.del.confirm%" " " "%lz.FileSel% %txt_items%"
) else (
	%MsgBox-s% key.e "%txt_x.del.confirm%" " " "%ui.Arc.file%"
)

if "!key.e!"=="1" (
	cls
	for %%a in (rar,7z) do if "%type.editor%"=="%%a" (
		"!path.editor.%%a!" d %btn.utf.b% -w"%dir.jzip.temp%" "%Arc.path%" @"%lz.txt%\ld" %iferror%
	)
	if not exist "%Arc.path%" %MsgBox% "%txt_x.zip.deled%" & exit /b
)
exit /b %errorlevel%


:: 重命名文件 
:ReName
set Arc.file.rn=
%InputBox-r% Arc.file.rn "%ui.Arc.file%" "%txt_x.type.rn.new%" " " "%txt_x.wildcard%"
if not defined Arc.file.rn set "key.e=2" & goto :EOF
if defined lz.Dir set "Arc.file.rn=!lz.Dir!\!Arc.file.rn!"

cls
for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%Arc.path%" "%Arc.file%" "%Arc.file.rn%" %iferror%
exit /b %errorlevel%


:: 压缩档检查 
:Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%Arc.path%" %iferror%
if not "!errorlevel!"=="0" pause
exit /b %errorlevel%


:: 压缩档修复 
:Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%Arc.path%" %iferror%
if not "!errorlevel!"=="0" pause
exit /b %errorlevel%


:: 压缩档注释 
:Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%Arc.path%" %iferror%
pause
exit /b %errorlevel%


:: 压缩档锁定 
:Lock
%MsgBox-s% key.e "%txt_x.lock.confirm%"
if "%key.e%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%Arc.path%" %iferror%
	if not "!errorlevel!"=="0" pause
)
exit /b %errorlevel%


:: 自解压文件 
:Sfx
call "%dir.jzip%\Part\Arc_Sfx.cmd"
goto :EOF

