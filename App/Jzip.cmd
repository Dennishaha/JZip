@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul

::Ԥ����
set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
set "path.jzip.launcher=%~0"
call :preset

::������
if exist "%~1" call :Set_Info list %* & goto :END
if exist "%~2" call :Set_Info %* & goto :END
if /i "%~1"=="-su" call :su %* & if errorlevel 1 goto :EOF
if /i "%~1"=="-install" call "%dir.jzip%\Parts\Set_Lnk.cmd" -reon
if /i "%~1"=="-setting" call "%dir.jzip%\Parts\Set.cmd"

:BASIC
title JFsoft Zip ѹ��
cls
echo.
echo.
echo.                                   Jzip ѹ��
echo.
echo.             ------------------------------------------------------
echo.
echo.                               [1] ��ѹ���ļ� ^>
echo.
echo.                               [2] �½�ѹ�� ^>
echo.
echo.                               [3] ��ѹ���ļ� ^>
echo.
echo.                               [4] �ļ������� ^>
net session >nul 2>nul || echo.                               [5] ����Ȩ�� �J
echo.
echo.                               [6] ���� ^>
echo.
echo.                             ^< [0] �뿪
echo.
echo.             ------------------------------------------------------
echo.
echo. ����ѡ����ѡ��...
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
	for %%a in (Archive.exten,ѹ������,��ʵ�ļ�) do (
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
			"%path.editor.rar%" l "!path.Archive!" | findstr "^����:" 1>nul && set "type.editor=rar"
		)
	)
	
	if defined type.editor (
		if "%~1"=="list" start "%%~b %title%" cmd /q /e:on /v:on /c "chcp 936 >nul & color %������ɫ% & call "%dir.jzip%\Parts\Arc.cmd""
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
echo.                              �������ѹ���ļ���
echo.
echo.
:describe_split
for /f "tokens=1,* delims=/" %%a in ("!ui.nospt!") do set "ui.nospt=%%~b" & echo.      %%~a
if not "!ui.nospt!"=="" goto :describe_split
echo.
echo.
echo.                                  [�س�] ��
echo.
echo.
echo.
pause >nul
goto :EOF



:: ����Ϊ����

:preset
:: Ԥ���� Jzip ����
set "jzip.ver=2 190114.1130"
set "title=-- Jzip"

set "dir.jzip.temp=%temp%\JFsoft\Jzip"
set "������ɫ=f3"
set "����ݾ�=y"
set "�Ҽ��ݾ�=y"
set "�鿴����չ="

:: Jzip �ļ�֧������
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z,zip,bz2,gz,tgz,tar,wim,xz,001,cab,iso,dll,msi,chm,cpio,deb,dmg,lzh,lzma,rpm,udf,vhd,xar"
set "jzip.spt.exe=exe"
set "jzip.spt.write=exe,rar,7z,zip,tar,wim"
set "jzip.spt.open=%jzip.spt.rar%,%jzip.spt.7z%"

:: �����û�������Ϣ����ʱ�ļ���
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKEY_CURRENT_USER\Software\JFsoft.Jzip" 2^>nul') do if /i "%%b"=="REG_SZ" set "%%a=%%c"
set "�������=%date:~0,10% %time%"
for %%a in (dir.jzip.temp,������ɫ,����ݾ�,�Ҽ��ݾ�,�鿴����չ,�������) do reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul
dir "%dir.jzip.temp%" /a:d /b 1>nul 2>nul || md "%dir.jzip.temp%" || (set dir.jzip.temp=%temp%\JFsoft\Jzip & md "!dir.jzip.temp!")

:: ������� - ��̬
color %������ɫ%
if "%�鿴����չ%"=="y" (set "ViewExten=| more /e /s") else (set "ViewExten=")
set "key.request=set "key=" & for /f "usebackq delims=" %%a in (`xcopy /l /w "%~f0" "%~f0" 2^^>nul`) do if not defined key set "key=%%a" & set "key=^^!key:~-1%^^!""
set "iferror=|| (echo.��Ǹ��Jzip �������⡣ & pause 1>nul & goto :EOF)"

:: ������� - ��̬
set "choice=choice"
ver|findstr /i /c:" 5.">nul&& if not exist "%windir%\system32\choice.exe" set ""choice=%dir.jzip%\Components\x86\choice.exe""

if "%processor_architecture%"=="x86" set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
if "%processor_architecture%"=="x86" set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"
goto :EOF


:su
::ȡ�ù���ԱȨ��
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
::�˳�ʱ������ʱ�ļ�
if defined dir.jzip.temp rd /q /s "%dir.jzip.temp%" 1>nul
if defined dir.jzip.temp md "%dir.jzip.temp%" 1>nul
goto :EOF
