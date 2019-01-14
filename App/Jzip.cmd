@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul

::预配置
set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
set "path.jzip.launcher=%~0"
call :preset

::被调用
if exist "%~1" call :Set_Info list %* & goto :END
if exist "%~2" call :Set_Info %* & goto :END
if /i "%~1"=="-su" call :su %* & if errorlevel 1 goto :EOF
if /i "%~1"=="-install" call "%dir.jzip%\Parts\Set_Lnk.cmd" -reon
if /i "%~1"=="-setting" call "%dir.jzip%\Parts\Set.cmd"

:BASIC
title JFsoft Zip 压缩
cls
echo.
echo.
echo.                                   Jzip 压缩
echo.
echo.             ------------------------------------------------------
echo.
echo.                               [1] 打开压缩文件 ^>
echo.
echo.                               [2] 新建压缩 ^>
echo.
echo.                               [3] 解压缩文件 ^>
echo.
echo.                               [4] 文件管理器 ^>
net session >nul 2>nul || echo.                               [5] 提升权限 ↗
echo.
echo.                               [6] 设置 ^>
echo.
echo.                             ^< [0] 离开
echo.
echo.             ------------------------------------------------------
echo.
echo. 键入选项以选择...
echo.-----------------------
%choice% /c:1234560 /n
set "key=%errorlevel%"
if "%key%"=="1" call :SetPath list
if "%key%"=="2" call :SetPath add
if "%key%"=="3" call :SetPath unzip
if "%key%"=="4" call "%dir.jzip%\Parts\File.cmd"
if "%key%"=="5" call :su %* & if errorlevel 1 goto :EOF
if "%key%"=="6" call "%dir.jzip%\Parts\Set.cmd"
if "%key%"=="7" goto :END
::清除已有变量并重启
start "" /b /i cmd /c "%path.jzip.launcher%" & cls & exit /b



:SetPath
cls
echo.
echo.
echo.
echo.             ------------------------------------------------------
echo.
if "%~1"=="list" echo.                             请选择压缩档查看。
if "%~1"=="unzip" echo.                             请选择压缩档解压。
if "%~1"=="add" echo.                             请选择文件加入压缩档。
echo.
echo.             ------------------------------------------------------
echo.
echo.
echo.
if "%~1"=="list" echo.                       可以将 压缩文件 拖到这个窗口，
if "%~1"=="unzip" echo.                       可以将 压缩文件 拖到这个窗口，
if "%~1"=="add" echo.                       可以将 添加的文件 拖到这个窗口，
echo.                       或是 输入文件路径。 
echo.
echo.                       若添加多个文件，使用空格区分。
echo.
echo.
echo.                       [回车] 返回
echo.
echo.
echo.
echo. 请把压缩文件拖入框内并回车...
echo.----------------------------------
set key=&set /p key=
if not defined key goto :EOF
if defined key call :Set_Info %~1 !key! & goto :EOF
goto :setpath


:Set_Info
if not "%~2"=="" (
	if not defined raw.number set "raw.number=0"
	set /a "raw.number=!raw.number!+1"
	dir "%~2" /b 1>nul 2>nul && set "path.raw.!raw.number!=%~2"
	shift /2
	goto :Set_Info
)

for %%a in (list,unzip,add,add-7z) do if "%~1"=="%%a" set "ArchiveOrder=%%a"

for %%a in (add,add-7z) do if "%~1"=="%%a" (
	set "Archive.exten=.7z"
	if "%~1"=="add" (
		for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKEY_CURRENT_USER\Software\JFsoft.Jzip\Record" 2^>nul') do if /i "%%b"=="REG_SZ" set "%%a=%%c"
	)
	for /f "usebackq delims== tokens=1,*" %%a in (`set "path.raw."`) do (
		set "path.File=!path.File! "%%~b""
	)
	dir "!path.raw.1!" /a:d /b 1>nul 2>nul && set "File.Single=n"
	if defined path.raw.2 dir "!path.raw.2!" /b 1>nul 2>nul && set "File.Single=n"
	
	set "path.Archive=!path.raw.1!%Archive.exten%"	
	if defined path.File call "%dir.jzip%\Parts\Arc_Add.cmd" new
	
	if "%~1"=="add" (
	for %%a in (Archive.exten,压缩级别,固实文件) do (
		reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip\Record" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul %iferror%
		)
	)
)

for %%a in (list,unzip) do if "%~1"=="%%a" for /f "usebackq delims== tokens=1,*" %%a in (`set "path.raw."`) do (
	set "path.Archive=%%~b"
	set "dir.Archive=%%~dpb" & set "dir.Archive=!dir.Archive:~0,-1!"
	set "Archive.name=%%~nb"
	set "Archive.exten=%%~xb"
	title %%~b %title%
	
	dir "!path.Archive!" /a:-d /b 1>nul 2>nul && (
		for %%A in (%jzip.spt.7z%) do if /i "!Archive.exten!"==".%%A" set "type.editor=7z"
		for %%A in (%jzip.spt.rar%) do if /i "!Archive.exten!"==".%%A" set "type.editor=rar"
		for %%A in (%jzip.spt.exe%) do if /i "!Archive.exten!"==".%%A" (
			"%path.editor.7z%" l "!path.Archive!" | findstr "^   Date" 1>nul && set "type.editor=7z"
			"%path.editor.rar%" l "!path.Archive!" | findstr "^详情:" 1>nul && set "type.editor=rar"
		)
	)
	
	if defined type.editor (
		if "%~1"=="list" start "%%~b %title%" cmd /q /e:on /v:on /c "chcp 936 >nul & color %界面颜色% & call "%dir.jzip%\Parts\Arc.cmd""
		if "%~1"=="unzip" call "%dir.jzip%\Parts\Arc_Unzip.cmd"
		set "type.editor="
	) else (
		set "ui.nospt=!ui.nospt!/!path.Archive!"
	)
)

if defined ui.nospt call :NOSUPPORT
goto :EOF


:NOSUPPORT
cls
echo.
echo.
echo.
echo.
echo.
echo.                              以下项不是压缩文件。
echo.
echo.
:describe_split
for /f "tokens=1,* delims=/" %%a in ("!ui.nospt!") do set "ui.nospt=%%~b" & echo.      %%~a
if not "!ui.nospt!"=="" goto :describe_split
echo.
echo.
echo.                                  [回车] 好
echo.
echo.
echo.
pause >nul
goto :EOF



:: 以下为函数

:preset
:: 预配置 Jzip 环境
set "jzip.ver=2 190114.1130"
set "title=-- Jzip"

set "dir.jzip.temp=%temp%\JFsoft\Jzip"
set "界面颜色=f3"
set "桌面捷径=y"
set "右键捷径=y"
set "查看器扩展="

:: Jzip 文件支持类型
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z,zip,bz2,gz,tgz,tar,wim,xz,001,cab,iso,dll,msi,chm,cpio,deb,dmg,lzh,lzma,rpm,udf,vhd,xar"
set "jzip.spt.exe=exe"
set "jzip.spt.write=exe,rar,7z,zip,tar,wim"
set "jzip.spt.open=%jzip.spt.rar%,%jzip.spt.7z%"

:: 加载用户配置信息及临时文件夹
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKEY_CURRENT_USER\Software\JFsoft.Jzip" 2^>nul') do if /i "%%b"=="REG_SZ" set "%%a=%%c"
set "最近运行=%date:~0,10% %time%"
for %%a in (dir.jzip.temp,界面颜色,桌面捷径,右键捷径,查看器扩展,最近运行) do reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul
dir "%dir.jzip.temp%" /a:d /b 1>nul 2>nul || md "%dir.jzip.temp%" || (set dir.jzip.temp=%temp%\JFsoft\Jzip & md "!dir.jzip.temp!")

:: 配置组件 - 动态
color %界面颜色%
if "%查看器扩展%"=="y" (set "ViewExten=| more /e /s") else (set "ViewExten=")
set "key.request=set "key=" & for /f "usebackq delims=" %%a in (`xcopy /l /w "%~f0" "%~f0" 2^^>nul`) do if not defined key set "key=%%a" & set "key=^^!key:~-1%^^!""
set "iferror=|| (echo.抱歉，Jzip 出现问题。 & pause 1>nul & goto :EOF)"

:: 配置组件 - 静态
set "choice=choice"
ver|findstr /i /c:" 5.">nul&& if not exist "%windir%\system32\choice.exe" set ""choice=%dir.jzip%\Components\x86\choice.exe""

if "%processor_architecture%"=="x86" set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
if "%processor_architecture%"=="x86" set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"
goto :EOF


:su
::取得管理员权限
set "params=%*" && set "params=!params:~4!"
net session >nul 2>nul || (
	1> "%dir.jzip.temp%\getadmin.vbs" (
		echo.Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1
		echo.Set fso = CreateObject^("Scripting.FileSystemObject"^)
		echo.fso.DeleteFile^(WScript.ScriptFullName^)
		)
	) && "%dir.jzip.temp%\getadmin.vbs" && exit /b 1
)
goto :EOF


:END
::退出时清理临时文件
if defined dir.jzip.temp rd /q /s "%dir.jzip.temp%" 1>nul
if defined dir.jzip.temp md "%dir.jzip.temp%" 1>nul
goto :EOF
