@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul

::����
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call :Wizard Upgrade
if /i "%1"=="-uninstall" call :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
cls

:: Ԥ��������
set "if.error.lm=�������� https://github.com/Dennishaha/JZip ���˽������Ϣ��"
set "if.error.1=|| ( call :MsgBox "ȡ�� ��װ��Ϣ ʧ�ܡ�" "%if.error.lm%" & goto :EOF )"
set "if.error.2=|| ( call :MsgBox "���ص��ļ������ڣ������³��ԡ�" "%if.error.lm%" & goto :EOF )"
set "if.error.3=|| ( call :MsgBox "���°����ִ��������³��ԡ�" "%if.error.lm%" & goto :EOF )"
set "if.error.4=|| ( call :MsgBox "ȱʧ Bitsadmin ����������ڰ汾 Windows �в����ڡ�" "%if.error.lm%" & goto :EOF )"

:: ��װʱ������·���ʹ���
if "%1"=="Install" (
	set "dir.jzip=%appdata%\JFsoft\JZip\App"
	set "dir.jzip.temp=%temp%\JFsoft.JZip"
	>nul 2>nul md !dir.jzip.temp!
	mode 80, 25
	color f0
)
	
:: ��� Bits ���
bitsadmin /? >nul 2>nul %if.error.4%

:: �� Bits ���񱻽��ã�ѯ�ʿ���
sc qc bits | findstr /i "DISABLED" >nul && (
	if "%1"=="Install" call :MsgBox-s key "Jzip ��װ������Ҫ Bits ����" " ���Ƿ����� Jzip ���÷���"
	if "%1"=="Upgrade" call :MsgBox-s key "Jzip ���¹�����Ҫ Bits ����" "���Ƿ����� Jzip ���÷���"
	
	if "!key!"=="1" (
		:: ���� Bits ����
		net session >nul 2>nul && (sc config bits start= demand >nul)
		net session >nul 2>nul || (
			mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("cmd.exe","/c sc config bits start= demand >nul","","runas",1^)^(window.close^)
		)
		ping localhost -n 2 >nul
	) else (
		call :MsgBox "��Ǹ���޷���װ JZip��" "%if.error.lm%"
		goto :EOF
	)
)

:: ��ȡ Github �ϵ� JZip ��װ��Ϣ
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	dir "%dir.jzip.temp%\ver.ini" /a:-d /b >nul 2>nul && del /q /f /s "%dir.jzip.temp%\ver.ini" >nul 2>nul
	bitsadmin /transfer !random! /download /priority foreground https://raw.githubusercontent.com/Dennishaha/JZip/master/Server/ver.ini "%dir.jzip.temp%\ver.ini" %if.error.1%
	cls
	dir "%dir.jzip.temp%\ver.ini" /a:-d /b >nul 2>nul %if.error.2%

	for /f "eol=[ usebackq tokens=1,2* delims==" %%a in (`type "%dir.jzip.temp%\ver.ini"`) do set "%%a=%%b"
	set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
)

::UI--------------------------------------------------

cls
echo.
echo.
echo.

if "%1"=="Install" echo.      ���ڿ��԰�װ Jzip %jzip.newver%
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo.      ���ڿ��Ի�ȡ�°汾 JZip %jzip.newver%

for %%a in (Install Upgrade) do if "%1"=="%%a" if /i not "%jzip.ver%"=="%jzip.newver%" (
	echo. & echo.
	:describe_split
	for /f "tokens=1,* delims=;" %%a in ("!jzip.newver.describe!") do (
		set "jzip.newver.describe=%%b"
		echo.      %%~a
	)
	if not "!jzip.newver.describe!"=="" goto :describe_split
)

::UI--------------------------------------------------

:: ����ѡ��
if "%1"=="Install" call :MsgBox-s key "���ڿ��԰�װ Jzip %jzip.newver%��"
if "%1"=="UnInstall" call :MsgBox-s key "ȷʵҪж�� JZip ��"
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" call :MsgBox "JZip %jzip.ver% �����µġ�" & goto :EOF
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" call :MsgBox-s key "���ڿ��Ի�ȡ�°汾 JZip %jzip.newver%��"
if not "%key%"=="1" goto :EOF

:: ��ȡ JZip ��װ��
for %%a in (Install Upgrade) do  if "%1"=="%%a" (
	dir "%jzip.newver.page%" /a:-d /b >nul 2>nul && del /q /f /s "%jzip.newver.page%" >nul 2>nul
	bitsadmin /transfer %random% /download /priority foreground %jzip.newver.url% "%jzip.newver.page%" %if.error.1%
	cls
	dir "%jzip.newver.page%" /a:-d /b >nul 2>nul %if.error.2%
	"%jzip.newver.page%" t | findstr "^Everything is Ok" >nul 2>nul %if.error.3%
)

:: �����װ
for %%a in (UnInstall Upgrade) do if "%1"=="%%a" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Parts\Set_Assoc.cmd" & if "!tips.FileAssoc!"=="��" call "%dir.jzip%\Parts\Set_Assoc.cmd" -off
)

:: ��װ
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	cmd /q /c "rd /q /s "%dir.jzip%" >nul 2>nul & md "%dir.jzip%" >nul 2>nul & "%jzip.newver.page%" x -o"%dir.jzip%\" & "%dir.jzip%\%jzip.newver.installer%" -install"
	exit
)

:: ɾ�� JZip Ŀ¼
if "%1"=="UnInstall" (
	>nul (
		reg delete "HKCU\Console\JFsoft.Jzip" /f
		reg delete "HKCU\Software\JFsoft.Jzip" /f
	)
	cmd /q /c "rd /q /s "%dir.jzip%"  >nul 2>nul"
)
goto :EOF



:: ���
:MsgBox
mshta vbscript:execute^("msgbox(""%~1""&vbCrLf&vbCrLf&""%~2"",64+4096,""��ʾ"")(window.close)"^)
goto :EOF

:MsgBox-s
set "msgbox.t1="""
:MsgBox-s_c
if not "%~2"=="" (
	set "msgbox.t2=%~2"
	set "msgbox.t2=!msgbox.t2:&=?&Chr(38)&?!"
	set "msgbox.t2=!msgbox.t2: =?&Chr(32)&?!"
	set "msgbox.t2=!msgbox.t2:,=?&Chr(44)&?!"

	set "msgbox.t1=!msgbox.t1!&"!msgbox.t2!"&vbCrLf"
	shift /2
	goto MsgBox-s_c
)
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:?="%,1+64+4096,"��ʾ"))(window.close)" ') do (
	set "%~1=%%a"
)
goto :EOF
