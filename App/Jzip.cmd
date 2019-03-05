
@setlocal EnableExtensions EnableDelayedExpansion

@set "jzip.ver=3.2.4.2"
@set "path.jzip.launcher=%~0"
@set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
@set "dir.jzip.temp=%temp%\JFsoft.Jzip"

@if not "%~1"==":s" >nul (

	:: 检测注册表中 Jzip 语言设定
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip" /v "Language" 2^>nul') do (
		if /i "%%b"=="REG_SZ" set "%%a=%%c"
	)

	:: 注册表无语言设定时，则依据目前代码页设定。
	if not defined Language (
		for /f "tokens=2 delims=:" %%i in ('chcp') do (
			if "%%i"==" 936" (set "Language=chs") else (set "Language=en")
		)
	)
	reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Language" /d "!Language!" /f

	:: 检测语言/控制台，设定代码页/字体/大小/快速编辑，加载制表符补偿/语言配置
	reg query "HKCU\Console" /t REG_DWORD /v "ForceV2" 2>nul | findstr "0x1" >nul && set "Console.ver=2" || set "Console.ver=1"

	for %%z in (
		"chs":"936":"1":"0x30":"":"0x100008":"1"
		"chs":"936":"2":"0x36":"黑体":"0x100000":"2"
		"en":"437":"1":"0x30":"":"0x120008":"2"
		"en":"437":"2":"0x36":"Consolas":"0x100000":"2"
	) do for /f "tokens=1-7 delims=:" %%a in ("%%z") do (
		if /i "!Language!"=="%%~a" if "!Console.ver!"=="%%~c" (
			reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "CodePage" /d "%%~b" /f
			reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontFamily" /d "%%~d" /f
			reg add "HKCU\Console\JFsoft.Jzip" /t REG_SZ /v "FaceName" /d "%%~e" /f
			reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~f" /f
			reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "QuickEdit" /d "0x0" /f

			if "%%~g"=="1" set "echo=echo"
			if "%%~g"=="2" set "echo=call "%dir.jzip%\Function\Echo.cmd" "

			for /f "eol=[ tokens=1,*" %%i in ('type "%dir.jzip%\Langs\%%~a.ini"') do set "%%i%%j"
		)
	)
)

@if /i "%~1"=="-su" call :-su & goto :EOF
@if /i "%~1"=="-help" call :-help & goto :EOF

@if not "%~1"==":s" (
	start "JFsoft.Jzip" cmd /c call "%~0" :s %*
	goto :EOF
)

:: 预配置 Jzip 环境

@echo off
mode 80, 25

call %* & exit /b
:s

set title=-- Jzip
set Color=f0
set FileAssoc=
set ShortCut=y
set RightMenu=y
set "dir.jzip.temp.default=%dir.jzip.temp%"

:: 配置组件
color %Color%
set "iferror=|| ( call "%dir.jzip%\Function\EdCode.cmd" & goto :EOF )"
call "%dir.jzip%\Function\VbsBox.cmd" import

:: Ttool 配置
set "tmouse="%dir.jzip%\Components\x86\tmouse.exe""
set "tmouse.process= set "mouse=^^!errorlevel^^!" & (if "^^!mouse:~0,1^^!"=="-" set "mouse=^^!mouse:~1^^!" ) & set /a "mouse.x=^^!mouse:~0,-3^^!" & set /a "mouse.y=^^!mouse^^!-1000*^^!mouse.x^^!" & set "key=" "
set "tmouse.test= echo,[^!mouse.x^!,^!mouse.y^!] & ping localhost -n 2 >nul "
set "tcurs="%dir.jzip%\Components\x86\tcurs.exe""
%tcurs% /crv 0

:: Jzip 文件支持类型
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z zip bz2 gz tgz tar wim xz 001 cab iso dll msi chm cpio deb dmg lzh lzma rpm udf vhd xar"
set "jzip.spt.exe=exe"
set "jzip.spt.write=exe rar 7z zip tar wim"
set "jzip.spt.write.noadd=bz2 gz xz cab"
set "jzip.spt.open=%jzip.spt.rar% %jzip.spt.7z%"

:: 压缩编辑器配置
if "%processor_architecture%"=="AMD64" (
	set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
	set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
) else (
	set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
	set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
)
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"

:: 加载用户配置信息及临时文件夹
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip" 2^>nul') do if /i "%%b"=="REG_SZ" set "%%a=%%c"
for %%a in (Dir.Jzip.Temp Color FileAssoc ShortCut RightMenu RecentTime) do >nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 
>nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "RecentTime" /d "%date:~0,10% %time%" /f
dir "%dir.jzip.temp%" /a:d /b >nul 2>nul || ( md "%dir.jzip.temp%" || (set "dir.jzip.temp=%dir.jzip.temp.default%" & md "!dir.jzip.temp!") )


::被调用
if exist "%~1" call :Set_Info list %* & goto :EOF
if exist "%~2" call :Set_Info %* & goto :EOF
if /i "%~1"=="-setting" call "%dir.jzip%\Parts\Set.cmd"	
if /i "%~1"=="-install" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -reon
	call "%dir.jzip%\Parts\Set_Assoc.cmd" -reon
	call "%dir.jzip%\Parts\Set.cmd"
)

:BASIC
title %txt_title%
cls

::UI--------------------------------------------------

(
echo,
echo,
echo,
echo,
echo,
echo,
%echo%,                %txt_b12.top%%txt_b12.top%
%echo%,                %txt_b12.emp%%txt_b12.emp%
%echo%,                %txt_b12.emp%%txt_b12.emp%
%echo%,                %txt_m.open%%txt_m.add%
%echo%,                %txt_b12.emp%%txt_b12.emp%
%echo%,                %txt_b12.emp%%txt_b12.emp%
%echo%,                %txt_b12.bot%%txt_b12.bot%
net session >nul 2>nul && (
%echo%,                                        %txt_b12.top%
%echo%,                                        %txt_b12.emp%
%echo%,                                        %txt_m.set%
) || (
%echo%,                %txt_b12.top%%txt_b12.top%
%echo%,                %txt_m.right%%txt_b12.emp%
%echo%,                %txt_b12.bot%%txt_m.set%
)
%echo%,                                        %txt_b12.emp%
%echo%,                                        %txt_b12.bot%
echo,
echo,
echo,
echo,
echo,
)

::UI--------------------------------------------------

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	18}38}6}12}1}
	41}61}6}12}2}
	18}38}13}15}3}
	41}61}13}17}4}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %%a LEQ %mouse.x% if %mouse.x% LEQ %%b if %%c LEQ %mouse.y% if %mouse.y% LEQ %%d set "key=%%e"
	)
)

if "%key%"== "1" ( call :SetPath list
) else if "%key%"== "2" ( call :SetPath add
) else if "%key%"== "3" ( net session >nul 2>nul || ( call :-su & goto :EOF )
) else if "%key%"== "4" ( call "%dir.jzip%\Parts\Set.cmd"
)
goto :BASIC


:SetPath
set key=
call "%dir.jzip%\Function\Select_File.cmd" key
if defined key call :Set_Info %~1 "!key!"
goto :EOF


:Set_Info
setlocal
for %%a in (list unzip add add-7z) do if "%~1"=="%%a" set "ArchiveOrder=%%a"
set raw.num=1
set ui.nospt=

:Set_Info_Cycle
if not "%~2"=="" (
	dir "%~2" /b >nul 2>nul && set "path.raw.!raw.num!=%~2"
	set /a "raw.num+=1"
	shift /2
	goto :Set_Info_Cycle
)

for %%a in (add add-7z) do if "%~1"=="%%a" (
	
	for /f "usebackq delims== tokens=1,*" %%a in (`set "path.raw."`) do (
		set "path.File=!path.File! "%%~b""
	)

	dir "!path.raw.1!" /a:d /b >nul 2>nul && set "File.Single=n"
	if defined path.raw.2 dir "!path.raw.2!" /b >nul 2>nul && set "File.Single=n"
	
	for /f "delims=" %%i in ("!path.raw.1!") do (
	set "Archive.dir=%%~dpi"
	set "Archive.name=%%~ni"
	)

	if "%~1"=="add" (
		for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record" 2^>nul') do (
			if /i "%%b"=="REG_SZ" set "%%a=%%c"
		)
	)
	if not defined Archive.exten set "Archive.exten=.7z"
	
	if defined path.File call "%dir.jzip%\Parts\Add.cmd"
	
	if "%~1"=="add" (
	for %%a in (Archive.exten Add-Level Add-Solid) do (
		reg add "HKCU\Software\JFsoft.Jzip\Record" /t REG_SZ /v "%%a" /d "!%%a!" /f >nul %iferror%
		)
	)
)

for %%a in (list unzip) do if "%~1"=="%%a" (
	for /l %%b in (1,1,%raw.num%) do (
		for /f "delims=" %%c in ("!path.raw.%%b!") do (
			
			set "path.Archive=%%~c"
			set "dir.Archive=%%~dpc" & set "dir.Archive=!dir.Archive:~0,-1!"
			set "Archive.name=%%~nc"
			set "Archive.exten=%%~xc"
	
			dir "!path.Archive!" /a:-d /b >nul 2>nul && (
			for %%A in (%jzip.spt.7z%) do if /i "!Archive.exten!"==".%%A" set "type.editor=7z"
			for %%A in (%jzip.spt.rar%) do if /i "!Archive.exten!"==".%%A" set "type.editor=rar"
			for %%A in (%jzip.spt.exe%) do if /i "!Archive.exten!"==".%%A" (
				"%path.editor.7z%" l "!path.Archive!" | findstr /r "^   Date" >nul && set "type.editor=7z"
				"%path.editor.rar%" l "!path.Archive!" | findstr /r "^Details:" >nul && set "type.editor=rar"
				)
			)
	
			if defined type.editor (
				if "%~1"=="list" (
					if defined path.raw.2 start "JFsoft.Jzip" cmd /e:on /v:on /c "%dir.jzip%\Parts\Arc.cmd"
					if not defined path.raw.2 "%dir.jzip%\Parts\Arc.cmd" & exit 0
					)
				if "%~1"=="unzip" call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip /all
				set "type.editor="
			) else (
				set "ui.nospt=!ui.nospt! "%%~nxc""
			)
		)
	)
)
if defined ui.nospt start /min "" cmd  /q /v:on /c %MsgBox% "%txt_notzip%" " " %ui.nospt%
endlocal
goto :EOF


:-su
::当前权限判断
@net session >nul 2>nul || (

	::处理传入参数以适应 vbs
	setlocal enabledelayedexpansion
	set params=%*
	if defined params set "params=!params:"=""!"

	::取得管理员权限
	mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("cmd.exe","/c call ""%~s0"" !params!","","runas",1^)^(window.close^)

	endlocal
)
@goto :EOF


:-help
@echo,
@echo, JFsoft JZip %jzip.ver%   2012-2019 (c) Dennishaha  保留所有权利
@echo,
@echo, 用法： Jzip ^<开关^> ^<命令^> ^<文件^|压缩档^>
@echo,
@echo,   ^<开关^>
@echo,	-help		查看帮助
@echo,	-su		以管理员权限运行 Jzip
@echo,	-install	安装模式启动 Jzip
@echo,	-setting	启动 Jzip 并转到设置页
@echo,
@echo,   ^<命令^>
@echo,	""		默认缺省查看压缩档
@echo,	add		添加文件到压缩档
@echo,	unzip		解压压缩档至子文件夹
@echo,
@goto :EOF
