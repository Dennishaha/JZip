@echo off

::����
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call  :Wizard Upgrade
if /i "%1"=="-uninstall" call  :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Version Controler
if "%1"=="Install" set "dir.jzip.temp=%temp%\JFsoft\JZip"
if "%1"=="Install" md %dir.jzip.temp% 1>nul 2>nul
for %%a in (Install,Upgrade) do if "%1"=="%%a" call :NewVer_Get
cls
echo.
echo.
echo.

if "%1"=="Install" echo.       ���ڰ�װ Jzip %jzip.newver% ��
if "%1"=="UnInstall" echo.       Ҫж�� JZip ��
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" (
echo.      JZip %jzip.newver% �����µġ�
)
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" (
	echo.      ���ڿ��Ի�ȡ�°汾 JZip %jzip.newver% ��
	echo.
	for /f "usebackq tokens=1-9 delims=;" %%a in ('"%jzip.newver.describe%"') do (
		if not "%%~a"=="" echo.      %%~a
		if not "%%~b"=="" echo.      %%~b
		if not "%%~c"=="" echo.      %%~c
		if not "%%~d"=="" echo.      %%~d
		if not "%%~e"=="" echo.      %%~e
		if not "%%~f"=="" echo.      %%~f
		if not "%%~g"=="" echo.      %%~g
		if not "%%~h"=="" echo.      %%~h
		if not "%%~i"=="" echo.      %%~i
	)
)
echo.
echo.
if "%1"=="Install" echo.       [�س�] ��װ  [0] ����
if "%1"=="UnInstall" echo.       [Y] ж��  [�س�] ����
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" echo.       [�س�] ��
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo.       [�س�] ����  [0] ����
echo.
set "next=" & set /p "next="

if "%1"=="Install" if /i not "%next%"=="" goto :EOF
if "%1"=="UnInstall" if /i not "%next%"=="y" goto :EOF
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" goto :EOF
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" if /i not "%next%"=="" set "next=" & goto :EOF

for %%a in (Install,Upgrade) do  if "%1"=="%%a" call :NewVer_Down

if "%1"=="Install" set "dir.jzip=%appdata%\JFsoft\JZip\App"

for %%a in (UnInstall,Upgrade) do if "%1"=="%%a" call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all

for %%a in (Install,Upgrade) do if "%1"=="%%a" (
	cmd /c "@echo off & rd /q /s "%dir.jzip%" 1>nul 2>nul & md "%dir.jzip%" 1>nul 2>nul & "%jzip.newver.page%" x -o"%dir.jzip%\" & "%dir.jzip%\%jzip.newver.installer%" -install"
	exit
)
if "%1"=="UnInstall" cmd /c "rd /q /s "%dir.jzip%"  1>nul 2>nul"
goto :EOF


:NewVer_Get
dir "%dir.jzip.temp%\verinfo.txt" /a:-d /b 1>nul 2>nul && del /q /f /s "%dir.jzip.temp%\verinfo.txt" 1>nul 2>nul
bitsadmin /transfer %random% /download /priority foreground https://jfsoft.cc/jzip/verinfo.txt "%dir.jzip.temp%\verinfo.txt"
cls
dir "%dir.jzip.temp%\verinfo.txt" /a:-d /b 1>nul 2>nul || (call :error 1 & goto :EOF)

for /f "usebackq tokens=1,2* delims==" %%a in (`type "%dir.jzip.temp%\verinfo.txt"`) do set "%%a=%%b"
set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
cls
goto :EOF

:NewVer_Down
dir "%jzip.newver.page%" /a:-d /b 1>nul 2>nul && del /q /f /s "%jzip.newver.page%" 1>nul 2>nul
bitsadmin /transfer %random% /download /priority foreground %jzip.newver.url% "%jzip.newver.page%"
cls
dir "%jzip.newver.page%" /a:-d /b 1>nul 2>nul || (call :error 2 & goto :EOF)
"%jzip.newver.page%" t | findstr "^Everything is Ok" 1>nul 2>nul || (call :error 3 & goto :EOF)
goto :EOF

:error
if "%1"=="1" echo. ��Ҫ���������ӡ� 
if "%1"=="2" echo. ��·���ӳ��ִ��������³��ԡ� 
if "%1"=="3" echo. �����ļ����ִ��������³��ԡ�
pause
goto :EOF
