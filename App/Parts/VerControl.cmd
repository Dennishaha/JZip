
@echo off
setlocal EnableExtensions EnableDelayedExpansion

::调用
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call :Wizard Upgrade
if /i "%1"=="-uninstall" call :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
cls


:: 若未设定语言，依据目前代码页设定 
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


:: 依据设定语言，导入语言包 
if /i "%Language%"=="chs" (call :Langs-chs) else (call :Langs-en)


:: 预设错误代码 
for /l %%i in (1,1,4) do set "if.error.%%i=|| (call :MsgBox "!txt_vc.err.%%i!" "%txt_vc.err.info%" & goto :EOF)"


:: 配置路径和窗口 
set "dir.jzip.default=%appdata%\JFsoft\JZip\App"

if "%1"=="Install" (
	set "dir.jzip=%dir.jzip.default%"
	set "dir.jzip.temp=%temp%\JFsoft.JZip"
	>nul 2>nul md !dir.jzip.temp!
	mode 80, 25
	color f0
)


:: Jzip 便携版判断 
if /i "%dir.jzip%"=="%dir.jzip.default%" (set "jzip.Portable=") else (set "jzip.Portable=1")


:: Mshta 可用性判断 
mshta "vbscript:execute(close)" || (
	echo;%txt_vc.err.hta%
	echo;%txt_vc.err.info%
	pause >nul
)


:: 检测 Bits 组件 
for %%i in (Install Upgrade) do if "%1"=="%%i" (
	bitsadmin /? >nul 2>nul %if.error.4%

	:: 若 Bits 服务被禁用，询问开启 
	sc qc bits | findstr /i "DISABLED" >nul && (
		if "%1"=="Install" call :MsgBox-s key "%txt_vc.bits.n.in%" "%txt_vc.bits.acc%"
		if "%1"=="Upgrade" call :MsgBox-s key "%txt_vc.bits.n.up%" "%txt_vc.bits.acc%"

		if "!key!"=="1" (
			:: 启用 Bits 服务 
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


:: 获取 Github 上的 JZip 安装信息 
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


:: 弹出选择框 
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


:: Jzip 便携版判断，目录清空/移除询问 
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


:: 获取 JZip 安装包 
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	>nul 2>nul ( dir "%jzip.newver.page%" /a:-d /b && del /q /f /s "%jzip.newver.page%" )
	bitsadmin /transfer %random% /download /priority foreground "%jzip.newver.url%" "%jzip.newver.page%" %if.error.1%
	cls
	>nul 2>nul dir "%jzip.newver.page%" /a:-d /b %if.error.2%
	"%jzip.newver.page%" t | findstr "^Everything is Ok" >nul 2>nul %if.error.3%
)


:: 解除安装 
for %%a in (Upgrade UnInstall) do if "%1"=="%%a" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Parts\Set_Assoc.cmd" -off
)


:: 安装 
for %%a in (Install Upgrade) do if "%1"=="%%a" (

	cmd /q /c ">nul 2>nul (rd /q /s "!dir.jzip!"&md "!dir.jzip!")&"!jzip.newver.page!" x -o"!dir.jzip!\"&&"!dir.jzip!\!jzip.newver.installer!" -install"
	exit 0
)


:: 删除 JZip 注册表项和目录 
if "%1"=="UnInstall" (
	>nul (
		reg delete "HKCU\Console\JFsoft.Jzip" /f
		reg delete "HKCU\Software\JFsoft.Jzip" /f
	)
	start "" /min cmd /q /c ">nul rd /q /s "%dir.jzip%""
)
goto :EOF



:: 语言包 
:Langs-chs
set txt_vc.err.info=您可以在 https://github.com/Dennishaha/JZip 上了解更多信息。
set txt_vc.err.1=取得 安装信息 失败。
set txt_vc.err.2=下载的文件不存在，请重新尝试。
set txt_vc.err.3=更新包出现错误，请重新尝试。
set txt_vc.err.4=缺失 Bitsadmin 组件，在早期版本 Windows 中不存在。
set txt_vc.err.hta=Mshta 不可用，无法安装 JZip。
set txt_vc.err.fail=抱歉，无法安装 JZip。

set txt_vc.bits.n.in=Jzip 安装过程需要 Bits 服务。
set txt_vc.bits.n.up=Jzip 更新过程需要 Bits 服务。
set txt_vc.bits.acc=您是否允许 Jzip 启用服务？

set txt_vc.get=现在可以安装 Jzip
set txt_vc.rid=确实要解除安装 JZip 吗？
set txt_vc.getnew=现在可以获取新版本
set txt_vc.getauto=安装将自动开始。
set txt_vc.newest=是最新的。

set txt_vc.pt.update=您正使用 JZip 便携版，更新前将清空 JZip 所在文件夹。
set txt_vc.pt.uninstall=已完成 Jzip 便携版解除安装。

set txt_vc.path.rd=移除 JZip 所在路径吗？
set txt_vc.path.sure=请确保路径不含个人文件。
set txt_vc.sure=确定吗？

set txt_vc.notice=提示
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



:: 插件 
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

