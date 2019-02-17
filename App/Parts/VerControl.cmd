
@echo off
chcp 936 >nul
setlocal enableextensions enabledelayedexpansion

::调用
if /i "%1"=="" call :Wizard Install
if /i "%1"=="-upgrade" call :Wizard Upgrade
if /i "%1"=="-uninstall" call :Wizard UnInstall
if /i "%1"=="-install" start "" cmd /c ""%dir.jzip%\Jzip.cmd" -install"
goto :EOF

:Wizard
title Jzip Installer
cls

:: 预设错误代码
set "if.error.lm=您可以在 https://github.com/Dennishaha/JZip 上了解更多信息。"
set "if.error.1=|| ( call :MsgBox "取得 安装信息 失败。" "%if.error.lm%" & goto :EOF )"
set "if.error.2=   ( call :MsgBox "下载的文件不存在，请重新尝试。" "%if.error.lm%" & goto :EOF )"
set "if.error.3=|| ( call :MsgBox "更新包出现错误，请重新尝试。" "%if.error.lm%" & goto :EOF )"

:: 配置路径和窗口
set "dir.jzip.default=%appdata%\JFsoft\JZip\App"

if "%1"=="Install" (
	set "dir.jzip=%dir.jzip.default%"
	set "dir.jzip.temp=%temp%\JFsoft.JZip"
	md "!dir.jzip.temp!"
	mode 80, 25
	color f0
)

:: Jzip 便携版判断
if /i "%dir.jzip%"=="%dir.jzip.default%" (set "jzip.Portable=") else (set "jzip.Portable=1")

:: Mshta 可用性判断
mshta || ( echo Mshta 不可用，无法安装 JZip。 & echo %if.error.lm% & pause >nul )

:: 获取 Github 上的 JZip 安装信息
for %%i in (Install Upgrade) do if "%1"=="%%i" (
	REM 生成vbs下载代码
	(
		echo Set H=CreateObject("Microsoft.XMLHTTP"^)
		echo H.Open "GET", WSH.Arguments(1^), FALSE
		echo H.Send(^)
		echo Set S=CreateObject("ADODB.Stream"^)
		echo S.Mode=3
		echo S.Type=1
		echo S.Open(^)
		echo S.Write(post.responseBody^)
		echo S.SaveToFile WSH.Arguments(2^),2
	)>DownLoad.vbs
	if exist "%dir.jzip.temp%\ver.ini" del "%dir.jzip.temp%\ver.ini"
	cscript /nologo DownLoad.vbs "https://raw.githubusercontent.com/Dennishaha/JZip/master/Server/ver.ini" "%dir.jzip.temp%\ver.ini" %if.error.1%
	if not exist "%dir.jzip.temp%\ver.ini" %if.error.2%
	for /f "eol=[ usebackq tokens=1* delims==" %%a in ("%dir.jzip.temp%\ver.ini") do set "%%a=%%b"
	set "jzip.newver.page=%dir.jzip.temp%\full.!jzip.newver!.exe"
)

::UI--------------------------------------------------

cls
echo;
echo;
echo;

if "%1"=="Install" echo       现在可以安装 Jzip %jzip.newver%
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" echo       现在可以获取新版本 JZip %jzip.newver%

for %%a in (Install Upgrade) do if "%1"=="%%a" (
	if /i not "%jzip.ver%"=="%jzip.newver%" (
		echo;
		echo;
		rem 听说作者喜欢玩弄批处理的thick?
		for %%a in (!jzip.newver.describe!) do echo       %%~a
	)
)

::UI--------------------------------------------------

:: 弹出选择
if "%1"=="Install" call :MsgBox-s key "现在可以安装 Jzip %jzip.newver%。" " " "安装将自动开始。"
if "%1"=="UnInstall" call :MsgBox-s key "确实要解除安装 JZip 吗？"
if "%1"=="Upgrade" if /i "%jzip.ver%"=="%jzip.newver%" call :MsgBox "JZip %jzip.ver% 是最新的。" & goto :EOF
if "%1"=="Upgrade" if /i not "%jzip.ver%"=="%jzip.newver%" call :MsgBox-s key "现在可以获取新版本 JZip %jzip.newver%。" " " "安装将自动开始。"
if not "%key%"=="1" goto :EOF

:: 获取 JZip 安装包
for %%a in (Install Upgrade) do if "%1"=="%%a" (
	if not exist "%jzip.newver.page%" del "%jzip.newver.page%" )
	cscript /nologo DownLoad.vbs "%jzip.newver.url%" "%jzip.newver.page%" %if.error.1%
	if not exist "%jzip.newver.page%" %if.error.2%
	"%jzip.newver.page%" t | find "Everything is Ok" >nul 2>nul %if.error.3%
)

:: 解除安装
for %%a in (Upgrade UnInstall) do if "%1"=="%%a" (
	call "%dir.jzip%\Parts\Set_Lnk.cmd" -off all
	call "%dir.jzip%\Parts\Set_Assoc.cmd"
	if "!tips.FileAssoc!"=="●" call "%dir.jzip%\Parts\Set_Assoc.cmd" -off
)

:: 安装
for %%a in (Install Upgrade) do if "%1"=="%%a" (

	:: Jzip 便携版判断
	set key=1
	if defined jzip.Portable call :MsgBox-s key "您正使用 JZip 便携版，更新前将清空 JZip 所在文件夹。" " " "%dir.jzip%" "请确保路径不含个人文件。" " " "确定吗？"
	if "!key!"=="1" cmd /q /c "rd /q /s "%dir.jzip%" & md "%dir.jzip%" & "%jzip.newver.page%" x -o"%dir.jzip%\" & "%dir.jzip%\%jzip.newver.installer%" -install" >nul 2>nul
	exit /b
)

:: 删除 JZip 注册表项和目录
if "%1"=="UnInstall" (
	>nul (
		reg delete "HKCU\Console\JFsoft.Jzip" /f
		reg delete "HKCU\Software\JFsoft.Jzip" /f
	)

	:: Jzip 便携版判断
	set key=1
	if defined jzip.Portable call :MsgBox-s key "已完成 Jzip 便携版解除安装。" " " "移除 JZip 所在路径吗？" " " "%dir.jzip%" "请确保路径不含个人文件。" " " "确定吗？"
	if "!key!"=="1" start "" /min cmd /q /c ">nul rd /q /s "%dir.jzip%""
)
goto :EOF



:: 插件
:MsgBox
mshta vbscript:execute^("msgbox(""%~1""&vbCrLf&vbCrLf&""%~2"",64+4096,""提示"")(window.close)"^)
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
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:?="%,1+64+4096,"提示"))(window.close)" ') do (
	set "%~1=%%a"
)
goto :EOF
