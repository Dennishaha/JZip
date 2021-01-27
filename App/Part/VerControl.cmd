
@echo off
setlocal EnableExtensions EnableDelayedExpansion

::Ԥ�谲װ��ϢԴ
if not defined jzip.branches set "jzip.branches=master"

set jz.urlfix.1=https://raw.githubusercontent.com/Dennishaha/JZip/!jzip.branches!
set jz.urlfix.2=https://dennishaha.oss-cn-shenzhen.aliyuncs.com/JZip/!jzip.branches!
set jz.urlfix.3=https://gitee.com/Dennishaha/JZip/raw/!jzip.branches!
set jz.urlfix.4=https://gitlab.com/Dennishaha/JZip/-/raw/!jzip.branches!

set jz.insini.urldir=Server/ver.ini

::����
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call :Wizard Upgrade
if /i "%1"=="-uninstall" call :Wizard UnInstall
if /i "%1"=="-install" start "" %ComSpec% /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
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
for /l %%i in (1,1,4) do set "if.error.%%i=(call :MsgBox "!txt_vc.err.%%i!" "%txt_vc.err.info%" & exit /b %%i)"


:: ����·���ʹ��� 
title %txt_vc.title%
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
2>nul (
	mshta "vbscript:execute(close)" || path %path%;%SystemRoot%\SysWOW64
	mshta "vbscript:execute(close)" || (
		echo;%txt_vc.err.hta%
		echo;%txt_vc.err.info%
		pause >nul
		exit /b 1
	)
)


:: Powershell �������ж� 
powershell -? >nul 2>nul
if not "%ERRORLEVEL%"=="0" %if.error.4%


:: ��ȡ Github �ϵ� JZip ��װ��Ϣ 
for %%Z in (Install Upgrade) do if "%1"=="%%Z" (
	>nul 2>nul ( dir "%dir.jzip.temp%\ver.ini" /a:-d /b && del /q /f /s "%dir.jzip.temp%\ver.ini" )

	call :psdl "!jz.insini.urldir!" "%dir.jzip.temp%\ver.ini"
	if "!ERRORLEVEL!"=="1" %if.error.1%

	for /f "eol=[ usebackq tokens=1,* delims==" %%a in (`type "%dir.jzip.temp%\ver.ini"`) do set "%%a=%%b"
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
echo;
echo;

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
	>nul 2>nul (
		del /q /f /s "%dir.jzip.temp%\%jz.7zcab.pag%"
		del /q /f /s "%dir.jzip.temp%\%jz.nvzip.pag%"
	)

	call :psdl "!jz.7zcab.urldir!" "%dir.jzip.temp%\%jz.7zcab.pag%" "%jz.7zcab.sha1%"
	if "!ERRORLEVEL!"=="1" %if.error.2%
	call :psdl "!jz.nvzip.urldir!" "%dir.jzip.temp%\%jz.nvzip.pag%" "%jz.nvzip.sha1%"
	if "!ERRORLEVEL!"=="1" %if.error.2%

	cls
	expand -r "%dir.jzip.temp%\%jz.7zcab.pag%" >nul || %if.error.3%
	>nul 2>nul dir "%dir.jzip.temp%\%jz.nv7z.exe%" /a:-d /b || %if.error.3%
)


:: �����װ 
for %%a in (Upgrade UnInstall) do if "%1"=="%%a" (
	call "%dir.jzip%\Part\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Part\Set_Assoc.cmd" -off
)


:: ��װ 
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	
	cls
	%ComSpec% /q /c ">nul 2>nul (rd /q /s "!dir.jzip!"&md "!dir.jzip!")&"!dir.jzip.temp!\!jz.nv7z.exe!" x "!dir.jzip.temp!\!jz.nvzip.pag!" -y -o"!dir.jzip!\"&&"!dir.jzip!\!jzip.newver.installer!" -install"
	exit 0
)


:: ɾ�� JZip ע������Ŀ¼ 
if "%1"=="UnInstall" (
	>nul (
		reg delete "HKCU\Console\JFsoft.Jzip" /f
		reg delete "HKCU\Software\JFsoft.Jzip" /f
	)
	start "" /min %ComSpec% /q /c ">nul rd /q /s "%dir.jzip%""
)
goto :EOF



:: ���԰� 
:Langs-chs
set txt_vc.err.info=�������� github.com/Dennishaha/JZip ��������������װ�Լ��˽������Ϣ�� 
set txt_vc.err.1=��ѽ����·��̫ͨ��Ү��Ҫ��ͨһ�¡� 
set txt_vc.err.2=�����ӣ�����������������һ�£��Ǹ��ļ���èè��Ү�� 
set txt_vc.err.3=�ļ��������������˵��Ƕ��ˣ�Windows Defender �����ܾ����Ҳ��С� 
set txt_vc.err.4=����֣�Powershell ������ò���Ү�� 
set txt_vc.err.hta=Mshta �����ã�JZip װ����Ӵ�� 

set txt_vc.title=JFsoft Zip ѹ�� ��װ��
set txt_vc.get=���ڿ��԰�װ Jzip 
set txt_vc.rid=ȷʵҪ�����װ JZip �� 
set txt_vc.getnew=���ڿ��Ի�ȡ�°汾 
set txt_vc.getauto=�������Ŀ�ʼ�ɡ� 
set txt_vc.newest=�����µġ� 

set txt_vc.pt.update=����ʹ�� JZip ��Я�棬����ǰ����� JZip �����ļ��С� 
set txt_vc.pt.uninstall=����� Jzip ��Я������װ�� 

set txt_vc.path.rd=�Ƴ� JZip ����·���� 
set txt_vc.path.sure=��ȷ��·�����������ļ��� 
set txt_vc.sure=ȷ���� 

set txt_vc.loading=^>^>^>^> ������
goto :EOF


:Langs-en
set txt_vc.err.info=You can install it in other ways and learn more about it on github.com/Dennishaha/JZip.
set txt_vc.err.1=Oops, the internet is not smooth, so I need to clear it up.
set txt_vc.err.2=Hey, the server elder brother helped me find the file, and the file was hidden.
set txt_vc.err.3=The file was downloaded but disappeared. Windows Defender might think I can't do it.
set txt_vc.err.4=It's strange, the Powershell component can't be called.
set txt_vc.err.hta=Mshta is not available, and JZip cannot be installed.

set txt_vc.title=JFsoft Zip Installer
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

set txt_vc.loading=^>^>^> loading
goto :EOF



:: ��� 
:MsgBox
mshta vbscript:execute^("msgbox(""%~1""&vbCrLf&vbCrLf&""%~2"",64+4096)(close)"^)
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
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:`?`="%,1+64+4096))(close)" ') do (
	set "%~1=%%a"
)
goto :EOF

::  Powershell Downloader   
::  �÷� call :psdl "�ļ�Ŀ¼" "���·��" "�ȶ�sha1ֵ����ѡ��"

:psdl
for /f "tokens=1,* delims==" %%a in ('set jz.urlfix.') do (
	<nul set /p ="%txt_vc.loading%"
	2>nul powershell "&{(new-object System.Net.WebClient).DownloadFile('%%~b/%~1', '%~2')}"
	if "%~3"=="" (
		>nul 2>nul dir "%~2" /a:-d /b && exit /b 0
	) else (
	certutil -hashfile "%~2" sha1 | >nul findstr "\<%~3\>" && exit /b 0
	)
	set "%%a="
)
exit /b 1
goto :EOF

