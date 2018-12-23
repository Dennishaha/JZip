@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion

::预配置
set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
set "path.jzip.launcher=%~0"
call :preset

::被调用
if exist "%~1" call :Set_Info list %* & goto :END
if exist "%~2" call :Set_Info %* & goto :END
if /i "%~1"=="-su" goto :su
if /i "%~1"=="-install" call "%dir.jzip%\Parts\Set_Lnk.cmd" -reon & call "%dir.jzip%\Parts\Set.cmd"
if /i "%~1"=="-setting" call "%dir.jzip%\Parts\Set.cmd"

:BASIC
title JFsoft Zip
cls
echo.
echo.
echo.                                     Jzip
echo.
echo.             ------------------------------------------------------
echo.
echo.                           [1] 打开压缩文件 ^>
echo.
echo.                           [2] 新建压缩 ^>
echo.
echo.                           [3] 解压缩文件 ^>
echo.
echo.                           [4] 文件管理器 ^>
echo.                           [5] 提升权限 ↗
echo.
echo.                           [6] 设置 ^>
echo.
echo.                         ^< [0] 离开
echo.
echo.             ------------------------------------------------------
echo.
echo. 键入选项以选择...
echo.-----------------------
%choice% /c:1234560 /n
set "next=%errorlevel%"
if "%next%"=="1" call :SetPath list
if "%next%"=="2" call :SetPath add
if "%next%"=="3" call :SetPath unzip
if "%next%"=="4" call "%dir.jzip%\Parts\File.cmd"
if "%next%"=="5" goto :SU
if "%next%"=="6" call "%dir.jzip%\Parts\Set.cmd"
if "%next%"=="7" goto :END
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
set next=&set /p next=
if not defined next goto :EOF
if defined next call :Set_Info %~1 !next! & goto :EOF
goto :setpath


:Set_Info
if not "%~2"=="" set "path.raw=!path.raw! "%~2"" & shift /2 & goto :Set_Info
for %%a in (list,unzip,add,add-7z) do if "%~1"=="%%a" set "ArchiveOrder=%%a"

for %%a in (add,add-7z) do if "%~1"=="%%a" (
	if "%%a"=="add" set "Archive.exten=.rar" & set "type.editor=rar"
	if "%%a"=="add-7z" set "Archive.exten=.7z" & set "type.editor=7z"
	
	set "path.File=!path.raw!"
	set "path.Archive=!path.raw:"=!%Archive.exten%"
	call "%dir.jzip%\Parts\Arc_Add.cmd"
)

for %%a in (list,unzip) do if "%~1"=="%%a" for %%a in (!path.raw!) do (
	set "path.Archive=%%~a"
	set "dir.Archive=%%~dpa" & set "dir.Archive=!dir.Archive:~0,-1!"
	set "Archive.name=%%~na"
	set "Archive.exten=%%~xa"
	title %%a %title%
	
	for %%A in (7z,zip,bz2,gz,tgz,tar,wim,xz,001,cab,iso,dll) do if /i "!Archive.exten!"==".%%A" set "type.editor=7z"
	if /i "!Archive.exten!"==".rar" set "type.editor=rar"
	if /i "!Archive.exten!"==".exe" (
		"%path.editor.7z%" l "!path.Archive!" | findstr "^   Date" 1>nul && set "type.editor=7z"
		"%path.editor.rar%" l "!path.Archive!" | findstr "^详情:" 1>nul && set "type.editor=rar"
	)
	
	if defined type.editor (
		if "%~1"=="list" start "%%a %title%" cmd /c "%dir.jzip%\Parts\Arc.cmd"
		if "%~1"=="unzip" call "%dir.jzip%\Parts\Arc_Unzip.cmd"
		set "type.editor="
	) else (
		set "ui.nospt=!ui.nospt! %%a"
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
echo.                            以下文件不是压缩文件。
echo.
echo.
echo.          %ui.nospt:"=%
echo.
echo.
echo.
echo.
echo.                                  [回车] 好
echo.
echo.
echo.
pause >nul
goto :EOF



::以下为调用组件

:preset
::加载 Choice 组件
set "choice=choice"
ver|findstr /i /c:" 5.*">nul&& if not exist "%windir%\system32\choice.exe" set "choice=%dir.jzip%\Components\x86\choice.exe"

::设定压缩包编辑器
if "%processor_architecture%"=="x86" set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
if "%processor_architecture%"=="x86" set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"

::预配置 Jzip 环境
set "jzip.ver=2 181223.0233"
set "title=-- Jzip"
set "界面颜色=f3"
set "查看器扩展="

set "压缩加密="
set "压缩密码="
set "压缩级别=3"
set "固实文件="
set "分卷压缩="
set "压缩版本.rar=5"
set "自解压程序="

::加载用户配置信息及临时文件夹
if exist "%appdata%\JFsoft\Jzip\Setting.txt" for /f "usebackq delims=; tokens=1,*" %%a in ("%appdata%\JFsoft\Jzip\Setting.txt") do set %%a=%%b
call "%dir.jzip%\Parts\Set_Refresh.cmd"
dir "%dir.jzip.temp%" /a:d /b 1>nul 2>nul || md "%dir.jzip.temp%" || (set dir.jzip.temp=%temp%\JFsoft\Jzip & md "!dir.jzip.temp!")

::配置
color %界面颜色%
if "%查看器扩展%"=="y" (set "ViewExten=| more /e /s") else (set "ViewExten=")
goto :EOF


:su
::取得管理员权限
if defined %* set "params=%*" & set "params=!params:~4!"
( if exist "%temp%\getadmin.vbs" erase "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /b)
goto :EOF


:END
::退出时清理临时文件
if defined dir.jzip.temp rd /q /s "%dir.jzip.temp%" 1>nul 2>nul
if defined dir.jzip.temp md "%dir.jzip.temp%" 1>nul 2>nul
goto :EOF
