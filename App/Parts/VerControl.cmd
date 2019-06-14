
@echo off
setlocal EnableExtensions EnableDelayedExpansion

::����
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call :Wizard Upgrade
if /i "%1"=="-uninstall" call :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
cls


:: ��δ�趨���ԣ�����Ŀǰ����ҳ�趨 
if not defined Language (
	for /f "tokens=2 delims=:" %%i in ('chcp') do (
		if "%%i"==" 936" (
			set "Language=chs"
		) else ( 
			set "Language=en"
			chcp 437 >nul
		)
	)
)


:: �����趨���ԣ��������԰� 
if /i "%Language%"=="chs" (call :Langs-chs) else (call :Langs-en)


:: Ԥ�������� 
for /l %%i in (1,1,4) do set "if.error.%%i=|| (call :MsgBox "!txt_vc.err.%%i!" "%txt_vc.err.info%" & goto :EOF)"


:: ����·���ʹ��� 
set "dir.jzip.default=%appdata%\JFsoft\JZip\App"

if "%1"=="Install" (
	set "dir.jzip=%dir.jzip.default%"
	set "dir.jzip.temp=%temp%\JFsoft.JZip"
	>nul 2>nul md !dir.jzip.temp!
	mode 80, 25
	color f0
)


:: Jzip ��Я���ж� 
if /i "%dir.jzip%"=="%dir.jzip.default%" (set "jzip.Portable=") else (set "jzip.Portable=1")


:: Mshta �������ж� 
mshta "vbscript:execute(close)" || (
	echo;%txt_vc.err.hta%
	echo;%txt_vc.err.info%
	pause >nul
)


:: ��� Bits ��� 
for %%i in (Install Upgrade) do if "%1"=="%%i" (
	bitsadmin /? >nul 2>nul %if.error.4%

	:: �� Bits ���񱻽��ã�ѯ�ʿ��� 
	sc qc bits | findstr /i "DISABLED" >nul && (
		if "%1"=="Install" call :MsgBox-s key "%txt_vc.bits.n.in%" "%txt_vc.bits.acc%"
		if "%1"=="Upgrade" call :MsgBox-s key "%txt_vc.bits.n.up%" "%txt_vc.bits.acc%"

		if "!key!"=="1" (
			:: ���� Bits ���� 
			net session >nul 2>nul && (sc config bits start= demand >nul)
			net session >nul 2>nul || (
				mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("cmd.exe","/c sc config bits start= demand >nul","","runas",1^)^(window.close^)
			)
			ping localhost -n 2 >nul
		) else (
			call :MsgBox "%txt_vc.err.fail%" "%txt_vc.err.info%"
			goto :EOF
		)
	)
)


:: ��ȡ Github �ϵ� JZip ��װ��Ϣ 
for %%i in (Install Upgrade) do if "%1"=="%%i" (
	>nul 2>nul ( dir "%dir.jzip.temp%\ver.ini" /a:-d /b && del /q /f /s "%dir.jzip.temp%\ver.ini" )
	if not defined jzip.branches set "jzip.branches=master"
	bitsadmin /transfer !random! /download /priority foreground "https://raw.githubusercontent.com/Dennishaha/JZip/!jzip.branches!/Server/ver.ini" "%dir.jzip.temp%\ver.ini" %if.error.1%
	cls
	>nul 2>nul dir "%dir.jzip.temp%\ver.ini" /a:-d /b %if.error.2%

	for /f "eol=[ usebackq tokens=1,* delims==" %%a in (`type "%dir.jzip.temp%\ver.ini"`) do set "%%a=%%b"

	if defined jzip.newver.url set "jzip.newver.url=!jzip.newver.url: =%%20!"
	set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
)


::UI--------------------------------------------------

cls
echo;
echo;
echo;

if "%1"=="Install" echo;	%txt_vc.get% %jzip.newver%
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo;	%txt_vc.getnew% %jzip.newver%

for %%a in (Install Upgrade) do if "%1"=="%%a" if /i not "%jzip.ver%"=="%jzip.newver%" (
	echo;
	echo;
	for %%i in (!jzip.newver.des.%Language%!) do echo;	%%~i
)

::UI--------------------------------------------------


:: ����ѡ��� 
set "key="
if "%1"=="Install" call :MsgBox-s key "%txt_vc.get% %jzip.newver%" " " "%txt_vc.getauto%"
if "%1"=="UnInstall" call :MsgBox-s key "%txt_vc.rid%"
if "%1"=="Upgrade" (
	if /i "%jzip.ver%"=="%jzip.newver%" (
		call :MsgBox "JZip %jzip.ver% %txt_vc.newest%"
	) else (
		call :MsgBox-s key "%txt_vc.getnew% %jzip.newver%" " " "%txt_vc.getauto%"
	)
)
if not "%key%"=="1" goto :EOF


:: Jzip ��Я���жϣ�Ŀ¼���/�Ƴ�ѯ�� 
set "key="
if defined jzip.Portable (
	for %%a in (Install Upgrade) do if "%1"=="%%a" (
		call :MsgBox-s key "%txt_vc.pt.update%" " " "%dir.jzip%" "%txt_vc.path.sure%" " " "%txt_vc.sure%"
	)
	if "%1"=="UnInstall" (
		call :MsgBox-s key "%txt_vc.path.rd%" " " "%dir.jzip%" "%txt_vc.path.sure%" " " "%txt_vc.sure%"
	)
	if not "!key!"=="1" goto :EOF
)


:: ��ȡ JZip ��װ�� 
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	>nul 2>nul ( dir "%jzip.newver.page%" /a:-d /b && del /q /f /s "%jzip.newver.page%" )
	bitsadmin /transfer %random% /download /priority foreground "%jzip.newver.url%" "%jzip.newver.page%" %if.error.1%
	cls
	>nul 2>nul dir "%jzip.newver.page%" /a:-d /b %if.error.2%
	"%jzip.newver.page%" t | findstr "^Everything is Ok" >nul 2>nul %if.error.3%
)


:: �����װ 
for %%a in (Upgrade UnInstall) do if "%1"=="%%a" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Parts\Set_Assoc.cmd" -off
)


:: ��װ 
for %%a in (Install Upgrade) do if "%1"=="%%a" (

	cmd /q /c ">nul 2>nul (rd /q /s "!dir.jzip!"&md "!dir.jzip!")&"!jzip.newver.page!" x -o"!dir.jzip!\"&&"!dir.jzip!\!jzip.newver.installer!" -install"
	exit 0
)


:: ɾ�� JZip ע������Ŀ¼ 
if "%1"=="UnInstall" (
	>nul (
		reg delete "HKCU\Console\JFsoft.Jzip" /f
		reg delete "HKCU\Software\JFsoft.Jzip" /f
	)
	start "" /min cmd /q /c ">nul rd /q /s "%dir.jzip%""
)
goto :EOF



:: ���԰� 
:Langs-chs
set txt_vc.err.info=�������� https://github.com/Dennishaha/JZip ���˽������Ϣ��
set txt_vc.err.1=ȡ�� ��װ��Ϣ ʧ�ܡ�
set txt_vc.err.2=���ص��ļ������ڣ������³��ԡ�
set txt_vc.err.3=���°����ִ��������³��ԡ�
set txt_vc.err.4=ȱʧ Bitsadmin ����������ڰ汾 Windows �в����ڡ�
set txt_vc.err.hta=Mshta �����ã��޷���װ JZip��
set txt_vc.err.fail=��Ǹ���޷���װ JZip��

set txt_vc.bits.n.in=Jzip ��װ������Ҫ Bits ����
set txt_vc.bits.n.up=Jzip ���¹�����Ҫ Bits ����
set txt_vc.bits.acc=���Ƿ����� Jzip ���÷���

set txt_vc.get=���ڿ��԰�װ Jzip
set txt_vc.rid=ȷʵҪ�����װ JZip ��
set txt_vc.getnew=���ڿ��Ի�ȡ�°汾
set txt_vc.getauto=��װ���Զ���ʼ��
set txt_vc.newest=�����µġ�

set txt_vc.pt.update=����ʹ�� JZip ��Я�棬����ǰ����� JZip �����ļ��С�
set txt_vc.pt.uninstall=����� Jzip ��Я������װ��

set txt_vc.path.rd=�Ƴ� JZip ����·����
set txt_vc.path.sure=��ȷ��·�����������ļ���
set txt_vc.sure=ȷ����

set txt_vc.notice=��ʾ
goto :EOF


:Langs-en
set txt_vc.err.info=You can find out more at https://github.com/Dennishaha/JZip .
set txt_vc.err.1=Get installation information Failed.
set txt_vc.err.2=The downloaded file does not exist, please try again.
set txt_vc.err.3=An error occurred in the update package, please try again.
set txt_vc.err.4=The Bitsadmin component is missing, which does not exist in earlier versions of Windows.
set txt_vc.err.hta=Mshta is not available and JZip cannot be installed.
set txt_vc.err.fail=Sorry, so JZip cannot be installed.

set txt_vc.bits.n.in=The installation process of Jzip requires the Bits service.
set txt_vc.bits.n.up=The update process of Jzip requires the Bits service.
set txt_vc.bits.acc=Do you allow Jzip to enable the service?

set txt_vc.get=Now, You can install Jzip
set txt_vc.rid=Are you sure you want to uninstall JZip?
set txt_vc.getnew=Now, you can get the new version 
set txt_vc.getauto=The installation will start automatically.
set txt_vc.newest=is the latest.

set txt_vc.pt.update=You are using JZip Portable, the folder will be cleared before the update.
set txt_vc.pt.uninstall=Completed Jzip Portable uninstallation.

set txt_vc.path.rd=Remove the path to JZip?
set txt_vc.path.sure=Make sure?
set txt_vc.sure=

set txt_vc.notice=Notice
goto :EOF



:: ��� 
:MsgBox
mshta vbscript:execute^("msgbox(""%~1""&vbCrLf&vbCrLf&""%~2"",64+4096,""%txt_vc.notice%"")(close)"^)
goto :EOF

:MsgBox-s
set "msgbox.t1="""
:MsgBox-s_c
if not "%~2"=="" (
	set "msgbox.t2=%~2"

	if "!msgbox.t2: =!"=="" (
		set "msgbox.t1=!msgbox.t1!&vbCrLf"
	) else (
		set "msgbox.t2=!msgbox.t2:(=^(!"
		set "msgbox.t2=!msgbox.t2:)=^)!"
		set "msgbox.t2=!msgbox.t2:&=`?`&Chr(38)&`?`!"
		set "msgbox.t2=!msgbox.t2: =`?`&Chr(32)&`?`!"
		set "msgbox.t2=!msgbox.t2:,=`?`&Chr(44)&`?`!"

		set "msgbox.t1=!msgbox.t1!&"!msgbox.t2!"&vbCrLf"
	)
	shift /2
	goto :MsgBox-s_c
)
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:`?`="%,1+64+4096,"%txt_vc.notice%"))(close)" ') do (
	set "%~1=%%a"
)
goto :EOF

