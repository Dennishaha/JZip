@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul

::调用
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call  :Wizard Upgrade
if /i "%1"=="-uninstall" call  :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
cls

if "%1"=="Install" (
	set "dir.jzip.temp=%temp%\JFsoft\JZip"
	md !dir.jzip.temp! 1>nul 2>nul
)

sc qc bits | findstr "DISABLED" >nul && (
	echo.
	echo.
	if "%1"=="Install" echo.      Jzip 安装过程需要 bits 服务。
	if "%1"=="Upgrade" echo.      Jzip 更新过程需要 bits 服务。
	echo.
	if "%1"=="Install" echo.      您是否允许 Jzip 启用服务？
	if "%1"=="Upgrade" echo.      您是否允许 Jzip 启用服务？
	echo.
	echo.
	echo.      [回车] 允许  [0] 取消
	set "key=" & set /p "key="
	if /i not "!key!"=="" goto :EOF
	cls
	net session >nul 2>nul && sc config bits start= demand >nul", "", "runas", 1
	net session >nul 2>nul || (
		1> "%dir.jzip.temp%\getadmin.vbs" (
			echo.Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c sc config bits start= demand >nul", "", "runas", 1
			echo.Set fso = CreateObject^("Scripting.FileSystemObject"^) : fso.DeleteFile^(WScript.ScriptFullName^)
			)
		) && "%dir.jzip.temp%\getadmin.vbs"
	)
	ping localhost -n 2 >nul
)

set "if.error.1=|| (echo. bitsadmin 组件出现错误，在早期版本的 Windows 中可能缺失。 & pause & goto :EOF)"
set "if.error.2=|| (echo. 网路连接出现错误，请重新尝试。 & pause & goto :EOF)"
set "if.error.3=|| (echo. 更新文件出现错误，请重新尝试。 & pause & goto :EOF)"

for %%a in (Install,Upgrade) do if "%1"=="%%a" (
	dir "%dir.jzip.temp%\ver.ini" /a:-d /b 1>nul 2>nul && del /q /f /s "%dir.jzip.temp%\ver.ini" 1>nul 2>nul
	bitsadmin /transfer %random% /download /priority foreground https://raw.githubusercontent.com/Dennishaha/JZip/master/Server/ver.ini "%dir.jzip.temp%\ver.ini" %if.error.1%
	cls
	dir "%dir.jzip.temp%\ver.ini" /a:-d /b 1>nul 2>nul %if.error.2%

	for /f "eol=[ usebackq tokens=1,2* delims==" %%a in (`type "%dir.jzip.temp%\ver.ini"`) do set "%%a=%%b"
	set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
)

cls
echo.
echo.
echo.

if "%1"=="Install" echo.      现在安装 Jzip %jzip.newver% 。
if "%1"=="UnInstall" echo.       要卸载 JZip 吗？
if "%1"=="Upgrade" (
	if /i "%jzip.ver%"=="%jzip.newver%" (
		echo.      JZip %jzip.newver% 是最新的。
	) else (
		echo.      现在可以获取新版本 JZip %jzip.newver% 。
	)
)
for %%a in (Install,Upgrade) do if "%1"=="%%a" if /i not "%jzip.ver%"=="%jzip.newver%" (
	echo. & echo.
	:describe_split
	for /f "tokens=1,* delims=;" %%a in ("!jzip.newver.describe!") do (
		set "jzip.newver.describe=%%~b"
		echo.      %%~a
	)
	if not "!jzip.newver.describe!"=="" goto :describe_split
)
echo.
echo.
if "%1"=="Install" echo.       [回车] 安装  [0] 返回
if "%1"=="UnInstall" echo.       [Y] 卸载  [回车] 返回
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" echo.       [回车] 好
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo.       [回车] 更新  [0] 返回
echo.
set "key=" & set /p "key="

if "%1"=="Install" if /i not "%key%"=="" goto :EOF
if "%1"=="UnInstall" if /i not "%key%"=="y" goto :EOF
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" goto :EOF
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" if /i not "%key%"=="" set "key=" & goto :EOF

for %%a in (Install,Upgrade) do  if "%1"=="%%a" (
	dir "%jzip.newver.page%" /a:-d /b 1>nul 2>nul && del /q /f /s "%jzip.newver.page%" 1>nul 2>nul
	bitsadmin /transfer %random% /download /priority foreground %jzip.newver.url% "%jzip.newver.page%" %if.error.1%
	cls
	dir "%jzip.newver.page%" /a:-d /b 1>nul 2>nul %if.error.2%
	"%jzip.newver.page%" t | findstr "^Everything is Ok" 1>nul 2>nul %if.error.3%
)

if "%1"=="Install" set "dir.jzip=%appdata%\JFsoft\JZip\App"

for %%a in (UnInstall,Upgrade) do if "%1"=="%%a" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Parts\Set_Assoc.cmd" & if "!tips.FileAssoc!"=="●" call "%dir.jzip%\Parts\Set_Assoc.cmd" -off
)

for %%a in (Install,Upgrade) do if "%1"=="%%a" (
	cmd /q /c "rd /q /s "%dir.jzip%" >nul 2>nul & md "%dir.jzip%" >nul 2>nul & "%jzip.newver.page%" x -o"%dir.jzip%\" & "%dir.jzip%\%jzip.newver.installer%" -install"
	exit
)

if "%1"=="UnInstall" (
	reg delete "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /f >nul
	cmd /q /c "rd /q /s "%dir.jzip%"  >nul 2>nul"
)
goto :EOF
