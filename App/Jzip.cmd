@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul
mode 80, 25

::���ٱ༭ģʽ���
reg query "HKCU\Console" /t REG_DWORD /v "QuickEdit" | findstr "0x0" >nul || (
	reg add "HKCU\Console" /t REG_DWORD /v "QuickEdit" /d "0x0000000" /f >nul
	start "" cmd /c "%~0" & exit /b
)
::����̨������
reg query "HKCU\Console" /t REG_SZ /v "FaceName" | findstr "����" >nul || (
	reg add "HKCU\Console" /t REG_SZ /v "FaceName" /d "����" /f >nul
	start "" cmd /c "%~0" & exit /b
)

:: Ԥ���� Jzip ����
set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
set "path.jzip.launcher=%~0"
set "dir.jzip.temp=%temp%\JFsoft.Jzip"

set "jzip.ver=3 (190123.0000)"
set "title=-- Jzip"

set "������ɫ=f0"
set "�ļ�����="
set "����ݾ�=y"
set "�Ҽ��ݾ�=y"

:: Jzip �ļ�֧������
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z,zip,bz2,gz,tgz,tar,wim,xz,001,cab,iso,dll,msi,chm,cpio,deb,dmg,lzh,lzma,rpm,udf,vhd,xar"
set "jzip.spt.exe=exe"
set "jzip.spt.write=exe,rar,7z,zip,tar,wim"
set "jzip.spt.open=%jzip.spt.rar%,%jzip.spt.7z%"

:: �����û�������Ϣ����ʱ�ļ���
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip" 2^>nul') do if /i "%%b"=="REG_SZ" set "%%a=%%c"
set "�������=%date:~0,10% %time%"
for %%a in (dir.jzip.temp,������ɫ,�ļ�����,����ݾ�,�Ҽ��ݾ�,�������) do reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f >nul
dir "%dir.jzip.temp%" /a:d /b 1>nul 2>nul || md "%dir.jzip.temp%" || (set dir.jzip.temp=%temp%\JFsoft\Jzip & md "!dir.jzip.temp!")

:: �������
color %������ɫ%

set "iferror=|| (echo.��Ǹ��Jzip �������⡣ & pause >nul & goto :EOF)"
choice /? >nul 2>nul && set "choice=choice" || set "choice="%dir.jzip%\Components\x86\choice.exe""
set "key.request=set "key=" & for /f "usebackq delims=" %%a in (`xcopy /l /w "%~f0" "%~f0" 2^^>nul`) do if not defined key set "key=%%a" & set "key=^^!key:~-1%^^!""

set "tmouse="%dir.jzip%\Components\x86\tmouse.exe""
set "tmouse.echo=off"
set "tmouse.process=set "mouse=^^!errorlevel^^!" & (if "^^!mouse:~0,1^^!"=="-" set "mouse=^^!mouse:~1^^!" ) & set /a "mouse.x=^^!mouse:~0,-3^^!" & set /a "mouse.y=^^!mouse^^!-1000*^^!mouse.x^^!" & ( if "^^!tmouse.echo^^!"=="on" echo,[^!mouse.x^!,^!mouse.y^!] ) & set "key=" "
set "tcurs="%dir.jzip%\Components\x86\tcurs.exe""
%tcurs% /crv 0

if "%processor_architecture%"=="x86" set "path.editor.7z=%dir.jzip%\Components\x86\7z.exe"
if "%processor_architecture%"=="x86" set "path.editor.rar=%dir.jzip%\Components\x86\rar.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.7z=%dir.jzip%\Components\x64\7z.exe"
if "%processor_architecture%"=="AMD64" set "path.editor.rar=%dir.jzip%\Components\x64\rar.exe"
set "path.editor.cab=%dir.jzip%\Components\x86\cabarc.exe"


::������
if exist "%~1" call :Set_Info list %* & goto :EOF
if exist "%~2" call :Set_Info %* & goto :EOF
if /i "%~1"=="-su" call :su "%*" & goto :EOF
if /i "%~1"=="-install" call "%dir.jzip%\Parts\Set_Lnk.cmd" -reon & call "%dir.jzip%\Parts\Set_Assoc.cmd" -reon & call "%dir.jzip%\Parts\Set.cmd"
if /i "%~1"=="-setting" call "%dir.jzip%\Parts\Set.cmd"


:BASIC
title JFsoft Zip ѹ��
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.                 ��--------------------�� ��--------------------��
echo.                 ��                    �� ��                    ��
echo.                 ��                    �� ��                    ��
echo.                 ��    ��ѹ���ļ�    �� ��    �½�ѹ���ļ�    ��
echo.                 ��                    �� ��                    ��
echo.                 ��                    �� ��                    ��
echo.                 ��--------------------�� ��--------------------��
net session >nul 2>nul && (
echo.                                        ��--------------------��
echo.                                        ��                    ��
echo.                                        ��        ����        ��
) || (
echo.                 ��--------------------�� ��--------------------��
echo.                 ��      ����Ȩ��      �� ��                    ��
echo.                 ��--------------------�� ��        ����        ��
)
echo.                                        ��                    ��
echo.                                        ��--------------------��
echo.
echo.
echo.
echo.
echo.

%tmouse% /d 0 -1 1
%tmouse.process%

for %%A in (
	18}38}6}12}1}
	41}61}6}12}2}
	18}38}13}15}3}
	41}61}13}17}4}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"== "1" ( call :SetPath list
) else if "%key%"== "2" ( call :SetPath add
) else if "%key%"== "3" ( net session >nul 2>nul || ( call :su & goto :EOF )
) else if "%key%"== "4" ( call "%dir.jzip%\Parts\Set.cmd"
)

::������б���������
::start "" /b /i cmd /c "%path.jzip.launcher%" & cls & exit /b
goto :BASIC


:SetPath
call "%dir.jzip%\Parts\Select_File.cmd"
if defined key call :Set_Info %~1 "!key!"
goto :EOF


:Set_Info
for %%a in (list,unzip,add,add-7z) do if "%~1"=="%%a" set "ArchiveOrder=%%a"
set "raw.num=1"
set "ui.nospt="""""

:Set_Info_Cycle
if not "%~2"=="" (
	dir "%~2" /b 1>nul 2>nul && set "path.raw.!raw.num!=%~2"
	set /a "raw.num+=1"
	shift /2
	goto :Set_Info_Cycle
)

for %%a in (add,add-7z) do if "%~1"=="%%a" (
	set "Archive.exten=.7z"
	if "%~1"=="add" (
		for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record" 2^>nul') do (
			if /i "%%b"=="REG_SZ" set "%%a=%%c"
		)
	)
	for /f "usebackq delims== tokens=1,*" %%a in (`set "path.raw."`) do (
		set "path.File=!path.File! "%%~b""
	)

	dir "!path.raw.1!" /a:d /b 1>nul 2>nul && set "File.Single=n"
	if defined path.raw.2 dir "!path.raw.2!" /b >nul 2>nul && set "File.Single=n"
	
	set "path.Archive=!path.raw.1!%Archive.exten%"	
	if defined path.File call "%dir.jzip%\Parts\Arc_Add.cmd" new
	
	if "%~1"=="add" (
	for %%a in (Archive.exten,ѹ������,��ʵ�ļ�) do (
		reg add "HKCU\Software\JFsoft.Jzip\Record" /t REG_SZ /v "%%a" /d "!%%a!" /f >nul %iferror%
		)
	)
)

for %%a in (list,unzip) do if "%~1"=="%%a" (
	for /l %%b in (1,1,%raw.num%) do (
		for /f "delims=" %%c in ("!path.raw.%%b!") do (
			set "path.Archive=%%~c"
			set "dir.Archive=%%~dpc" & set "dir.Archive=!dir.Archive:~0,-1!"
			set "Archive.name=%%~nc"
			set "Archive.exten=%%~xc"
			title %%~c %title%
	
			dir "!path.Archive!" /a:-d /b 1>nul 2>nul && (
			for %%A in (%jzip.spt.7z%) do if /i "!Archive.exten!"==".%%A" set "type.editor=7z"
			for %%A in (%jzip.spt.rar%) do if /i "!Archive.exten!"==".%%A" set "type.editor=rar"
			for %%A in (%jzip.spt.exe%) do if /i "!Archive.exten!"==".%%A" (
				"%path.editor.7z%" l "!path.Archive!" | findstr "^   Date" >nul && set "type.editor=7z"
				"%path.editor.rar%" l "!path.Archive!" | findstr "^����:" >nul && set "type.editor=rar"
				)
			)
	
			if defined type.editor (
				if "%~1"=="list" (
					if defined path.raw.2 start "!path.raw.%%b! %title%" cmd /c ""%dir.jzip%\Parts\Arc.cmd""
					if not defined path.raw.2 "%dir.jzip%\Parts\Arc.cmd" & exit 0
					)
				if "%~1"=="unzip" call "%dir.jzip%\Parts\Arc_Unzip.cmd"
				set "type.editor="
			) else (
				set "ui.nospt=!ui.nospt!^&vbCrLf^&""%%~nxc"""
			)
		)
	)
)

if not "!ui.nospt!"=="""""" start /b "" mshta vbscript:execute^("msgbox^(""�������ѹ���ļ���""^&vbCrLf^&!ui.nospt!,64+4096,""��ʾ""^)^(window.close^)"^)

goto :EOF



:: ����Ϊ����

:su
::��ǰȨ���ж�
net session >nul 2>nul || (
	::�������������Ӧ vbs
	set "params=%*"
	if defined params (
		set "params=!params:~5,-1!"
		set "params=!params:"=""!"
		)
	)
	::ȡ�ù���ԱȨ��
	mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("cmd.exe","/c call ""%~s0"" !params!","","runas",1^)^(window.close^)
)
goto :EOF


