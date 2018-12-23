@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion

::Ԥ����
set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
set "path.jzip.launcher=%~0"
call :preset

::������
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
echo.                           [1] ��ѹ���ļ� ^>
echo.
echo.                           [2] �½�ѹ�� ^>
echo.
echo.                           [3] ��ѹ���ļ� ^>
echo.
echo.                           [4] �ļ������� ^>
echo.                           [5] ����Ȩ�� �J
echo.
echo.                           [6] ���� ^>
echo.
echo.                         ^< [0] �뿪
echo.
echo.             ------------------------------------------------------
echo.
echo. ����ѡ����ѡ��...
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
::������б���������
start "" /b /i cmd /c "%path.jzip.launcher%" & cls & exit /b



:SetPath
cls
echo.
echo.
echo.
echo.             ------------------------------------------------------
echo.
if "%~1"=="list" echo.                             ��ѡ��ѹ�����鿴��
if "%~1"=="unzip" echo.                             ��ѡ��ѹ������ѹ��
if "%~1"=="add" echo.                             ��ѡ���ļ�����ѹ������
echo.
echo.             ------------------------------------------------------
echo.
echo.
echo.
if "%~1"=="list" echo.                       ���Խ� ѹ���ļ� �ϵ�������ڣ�
if "%~1"=="unzip" echo.                       ���Խ� ѹ���ļ� �ϵ�������ڣ�
if "%~1"=="add" echo.                       ���Խ� ��ӵ��ļ� �ϵ�������ڣ�
echo.                       ���� �����ļ�·���� 
echo.
echo.                       ����Ӷ���ļ���ʹ�ÿո����֡�
echo.
echo.
echo.                       [�س�] ����
echo.
echo.
echo.
echo. ���ѹ���ļ�������ڲ��س�...
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
		"%path.editor.rar%" l "!path.Archive!" | findstr "^����:" 1>nul && set "type.editor=rar"
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
echo.                            �����ļ�����ѹ���ļ���
echo.
echo.
echo.          %ui.nospt:"=%
echo.
echo.
echo.
echo.
echo.                                  [�س�] ��
echo.
echo.
echo.
pause >nul
goto :EOF



::����Ϊ�������

:preset
::���� Choice ���
set "choice=choice"
ver|findstr /i /c:" 5.*">nul&& if not exist "%windir%\system32\choice.exe" set "choice=%dir.jzip%\Components\x86\choice.exe"

::�趨ѹ�����༭��
if "%processor_architecture%"=="x86" set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
if "%processor_architecture%"=="x86" set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"

::Ԥ���� Jzip ����
set "jzip.ver=2 181223.0233"
set "title=-- Jzip"
set "������ɫ=f3"
set "�鿴����չ="

set "ѹ������="
set "ѹ������="
set "ѹ������=3"
set "��ʵ�ļ�="
set "�־�ѹ��="
set "ѹ���汾.rar=5"
set "�Խ�ѹ����="

::�����û�������Ϣ����ʱ�ļ���
if exist "%appdata%\JFsoft\Jzip\Setting.txt" for /f "usebackq delims=; tokens=1,*" %%a in ("%appdata%\JFsoft\Jzip\Setting.txt") do set %%a=%%b
call "%dir.jzip%\Parts\Set_Refresh.cmd"
dir "%dir.jzip.temp%" /a:d /b 1>nul 2>nul || md "%dir.jzip.temp%" || (set dir.jzip.temp=%temp%\JFsoft\Jzip & md "!dir.jzip.temp!")

::����
color %������ɫ%
if "%�鿴����չ%"=="y" (set "ViewExten=| more /e /s") else (set "ViewExten=")
goto :EOF


:su
::ȡ�ù���ԱȨ��
if defined %* set "params=%*" & set "params=!params:~4!"
( if exist "%temp%\getadmin.vbs" erase "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /b)
goto :EOF


:END
::�˳�ʱ������ʱ�ļ�
if defined dir.jzip.temp rd /q /s "%dir.jzip.temp%" 1>nul 2>nul
if defined dir.jzip.temp md "%dir.jzip.temp%" 1>nul 2>nul
goto :EOF
