@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion

::����
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call  :Wizard Upgrade
if /i "%1"=="-uninstall" call  :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
set "if.error.1=|| (echo.��Ҫ bitsadmin ����������ڰ汾�� Windows �п���ȱʧ�� & goto :EOF)"
set "if.error.2=|| (echo.��·���ӳ��ִ��������³��ԡ� & goto :EOF)"
set "if.error.3=|| (echo. �����ļ����ִ��������³��ԡ� & goto :EOF)"

if "%1"=="Install" set "dir.jzip.temp=%temp%\JFsoft\JZip"
if "%1"=="Install" md %dir.jzip.temp% 1>nul 2>nul

for %%a in (Install,Upgrade) do if "%1"=="%%a" (
	dir "%dir.jzip.temp%\verinfo.txt" /a:-d /b 1>nul 2>nul && del /q /f /s "%dir.jzip.temp%\verinfo.txt" 1>nul 2>nul
	bitsadmin /transfer %random% /download /priority foreground https://jfsoft.cc/jzip/verinfo.txt "%dir.jzip.temp%\verinfo.txt" %if.error.1%
	cls
	dir "%dir.jzip.temp%\verinfo.txt" /a:-d /b 1>nul 2>nul %if.error.2%

	for /f "usebackq tokens=1,2* delims==" %%a in (`type "%dir.jzip.temp%\verinfo.txt"`) do set "%%a=%%b"
	set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
)

cls
echo.
echo.
echo.

if "%1"=="Install" echo.      ���ڰ�װ Jzip %jzip.newver% ��
if "%1"=="UnInstall" echo.       Ҫж�� JZip ��
if "%1"=="Upgrade" (
	if /i "%jzip.ver%"=="%jzip.newver%" (
		echo.      JZip %jzip.newver% �����µġ�
	) else (
		echo.      ���ڿ��Ի�ȡ�°汾 JZip %jzip.newver% ��
	)
)
for %%a in (Install,Upgrade) do if "%1"=="%%a" if /i not "%jzip.ver%"=="%jzip.newver%" (
	echo.
	:describe_split
	for /f "tokens=1,* delims=;" %%a in ("!jzip.newver.describe!") do (
		set "jzip.newver.describe=%%~b"
		echo. & echo.      %%~a
	)
	if not "!jzip.newver.describe!"=="" goto :describe_split
)
echo.
echo.
if "%1"=="Install" echo.       [�س�] ��װ  [0] ����
if "%1"=="UnInstall" echo.       [Y] ж��  [�س�] ����
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" echo.       [�س�] ��
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo.       [�س�] ����  [0] ����
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

for %%a in (UnInstall,Upgrade) do if "%1"=="%%a" call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all

for %%a in (Install,Upgrade) do if "%1"=="%%a" (
	cmd /c "@echo off & rd /q /s "%dir.jzip%" 1>nul 2>nul & md "%dir.jzip%" 1>nul 2>nul & "%jzip.newver.page%" x -o"%dir.jzip%\" & "%dir.jzip%\%jzip.newver.installer%" -install"
	exit
)
if "%1"=="UnInstall" (
	reg delete "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /f 1>nul
	cmd /c "rd /q /s "%dir.jzip%"  1>nul 2>nul"
)
goto :EOF

