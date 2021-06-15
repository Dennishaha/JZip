
@echo off
setlocal EnableDelayedExpansion EnableDelayedExpansion

:: 调用 
%tcurs% /crv 0
mode 80,27
color %color%

:: 安装配置 
if /i "%~2"=="-setting" call "%dir.jzip%\Part\Set.cmd" %3 %4
if /i "%~2"=="-install" (
	call "%dir.jzip%\Part\Set_Lnk.cmd" -reon
	call "%dir.jzip%\Part\Set_Assoc.cmd" -reon
	call "%dir.jzip%\Part\Set.cmd"
	goto :Main
)

call %*
exit /b 0

:Main
title %txt_title%
cls

for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\History" 2^>nul') do set "%%a=%%c"

::UI--------------------------------------------------

(
echo;
echo;
echo;
echo;
echo;
echo;
echo;
%echo%;                %txt_b12.top%%txt_b12.top%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_m.open%%txt_m.add%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_b12.emp%%txt_b12.emp%
%echo%;                %txt_b12.bot%%txt_b12.bot%
%echo%;                                        %txt_b12.top%
%echo%;                                        %txt_m.set%
%echo%;                                        %txt_b12.bot%

for /l %%i in (1,1,3) do dir "!arc%%i!" /a:-d /b >nul 2>nul && (
	%echocut% "!arc%%i!" ui.arc%%i equ46
) || (
	%echocut% "!arc%%i! %txt_m.arcdis%" ui.arc%%i equ46
) >nul 2>nul
for /l %%i in (1,1,3) do if defined Arc%%i (
echo;
echo;		!ui.arc%%i! X
) else echo;&echo;
)

::UI--------------------------------------------------

%tcurs% /crv 0
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	17}38}7}15}1}
	41}62}7}15}2}
	41}62}16}18}3}

	16}60}20}20}h1}
	16}60}22}22}h2}
	16}60}24}24}h3}

	63}63}20}20}h1d}
	63}63}22}22}h2d}
	63}63}24}24}h3d}

) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %%a LEQ %mouse.x% if %mouse.x% LEQ %%b if %%c LEQ %mouse.y% if %mouse.y% LEQ %%d set "key=%%e"
	)
)

if "%key%"=="1" ( call :SetPath list
) else if "%key%"=="2" ( call :SetPath add
) else if "%key%"=="3" ( call "%dir.jzip%\Part\Set.cmd"
)

for /l %%i in (1,1,3) do (
	if defined Arc%%i (
		if "%key%"=="h%%i" call :Set_Info list "!Arc%%i!"
		if "%key%"=="h%%id" call :History-del %%i
	)
)
goto :Main


:SetPath
set key=
call "%dir.jzip%\Function\Select_File.cmd" key
if defined key call :Set_Info %~1 "!key!"
goto :EOF


:Set_Info

setlocal
for %%a in (list unzip add add-7z) do if /i "%~1"=="%%a" set "Arc.Order=%%a"
set raw.num=1
set ui.nospt=

:Set_Info_Cycle
if not "%~2"=="" (
	
	dir "%~2" /b >nul 2>nul && (
		set "path.raw.!raw.num!=%~2"
	) || (
		echo;"%~2" | find "//" >nul && (set "Guid=%~2" & set "Guid=!Guid:~2!")
		echo;"%~2" | find "--" >nul && (set "Arc.Do=%~2" & set "Arc.Do=!Arc.Do:~2!")
	)
	set /a "raw.num+=1"
	shift /2
	goto :Set_Info_Cycle
)

for %%a in (add add-7z) do if /i "%~1"=="%%a" (
	
	for /f "usebackq delims== tokens=1,*" %%a in (`set "path.raw."`) do (
		set "path.File=!path.File! "%%~b""
	)

	:: 生成 GUID 
	if defined Guid (
		set "Arc.Guid=%Guid%"
	) else (
		for /f "delims=" %%a in ('powershell -noprofile -command "&{ [guid]::NewGuid().ToString()}"') do set "Arc.Guid=%%a"
	)

	:: 添加文件数判断 
	dir "!path.raw.1!" /a:d /b >nul 2>nul && set "File.Single=n"
	if defined path.raw.2 dir "!path.raw.2!" /b >nul 2>nul && set "File.Single=n"
	
	for /f "delims=" %%i in ("!path.raw.1!") do (

		set "Arc.dir=%%~dpi" & set "Arc.dir=!Arc.dir:~0,-1!"

		:: 压缩文件名判断 
		dir "!path.raw.1!" /a:d /b >nul 2>nul && set "Arc.name=%%~nxi" || set "Arc.name=%%~ni"

		)
	)

	if defined path.File call "%dir.jzip%\Part\Add.cmd"
)

for %%a in (list unzip) do if /i "%~1"=="%%a" (
	
	if defined path.raw.2 set "jz.wdnew=y"
	
	for /l %%b in (1,1,%raw.num%) do (
		for /f "delims=" %%c in ("!path.raw.%%b!") do (
			
			set "Arc.path=%%~c"
			set "Arc.dir=%%~dpc" & set "Arc.dir=!Arc.dir:~0,-1!"
			set "Arc.name=%%~nc"
			set "Arc.exten=%%~xc"

			:: 分析文件类型 
			>nul 2>nul (
				dir "%%~c" /a:d /b || (
					dir "%%~c" /a:-d /b  && (
						for %%A in (%jzip.spt.7z%) do if /i "!Arc.exten!"==".%%A" set "type.editor=7z"
						for %%A in (%jzip.spt.rar%) do if /i "!Arc.exten!"==".%%A" set "type.editor=rar"
						if not defined type.editor (
							"%path.editor.7z%" l "!Arc.path!" | findstr /r /c:"^   Date" >nul && set "type.editor=7z"
							"%path.editor.rar%" l "!Arc.path!" | findstr /r /c:"^Details:" >nul && set "type.editor=rar"
						)
					)
				)
			)

			if defined type.editor (

				:: 生成 GUID 
				if defined Guid (
					set "Arc.Guid=%Guid%"
				) else (
					for /f "delims=" %%a in ('powershell -noprofile -command "&{ [guid]::NewGuid().ToString()}"') do set "Arc.Guid=%%a"
				)

				:: 访问权限判断 
				>nul 2>nul (
					net session || (ren "%%~c" "%%~nxc" || set "Arc.Uac=y")
				)

				if /i "%~1"=="list" (
					call :History-add "%%~c"
					if "!jz.wdnew!"=="y" (
						set jz.wdnew=
						start "JFsoft.Jzip" "%ComSpec%" /c "%dir.jzip%\Part\Arc.cmd"
					) else (
						call "%dir.jzip%\Part\Arc.cmd"
					)
				)
				if /i "%~1"=="unzip" call "%dir.jzip%\Part\Arc_Expan.cmd" Unzip /unzip
				set "type.editor="

			) else (
				set ui.nospt=!ui.nospt! "%%~nxc"
			)
		)
	)
)
if defined ui.nospt start "" /min "%ComSpec%" /v:on /c %MsgBox% "%txt_notzip%" " " %ui.nospt%
endlocal
goto :EOF


:History-add
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\History" 2^>nul') do set "%%a=%%c"
if "%~1"=="" exit /b

:: 路径处理 
>nul (
echo;"%~1" | find "%Arc1%" || (set "Arc1=%~1" & set "Arc2=%Arc1%" & set "Arc3=%Arc2%")
echo;"%~1" | find "%Arc2%" && (set "Arc1=%Arc2%" & set "Arc2=%Arc1%" & set "Arc3=%Arc3%")
echo;"%~1" | find "%Arc3%" && (set "Arc1=%Arc3%" & set "Arc2=%Arc1%" & set "Arc3=%Arc2%")
)

:: 更新注册表 
for /l %%n in (1,1,3) do (
	reg add "HKCU\Software\JFsoft.Jzip\History" /t REG_SZ /v "Arc%%n" /d "!Arc%%n!" /f >nul
)
exit /b


:History-del
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\History" 2^>nul') do set "%%a=%%c"
if "%~1"=="" exit /b

:: 顺序替换 
if "%~1"=="all" set "Arc1=" & set "Arc2="
if "%~1"=="1" set "Arc1=%Arc2%" & set "Arc2=%Arc3%"
if "%~1"=="2" set "Arc2=%Arc3%"
set "Arc3="

:: 更新注册表 
for /l %%n in (1,1,3) do (
	reg add "HKCU\Software\JFsoft.Jzip\History" /t REG_SZ /v "Arc%%n" /d "!Arc%%n!" /f >nul
)

exit /b

