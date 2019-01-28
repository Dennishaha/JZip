@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul
color %界面颜色%

::初始变量设定
set /a Window.Wide=110, Window.Height=35
mode %Window.Wide%, %Window.Height%
for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
for /f "delims=" %%a in ('cscript //nologo "%dir.jzip%\Parts\Create_GUID.vbs"') do set "random1=%%a"
set "listzip.txt=%dir.jzip.temp%\%random1%.tmp"
set "listzip.Dir="
set "listzip.Menu=basic"

:: 压缩文件可用性检测
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" >nul "!path.editor.%%a!" l "%path.Archive%" %iferror%

:Menu
cls

:: 动态调整窗口大小，调试时需注释以禁用
for /f "tokens=1-2 delims= " %%i in ('mode') do (
	if "%%i"=="行:　" set "Window.Height=%%~j"
	if "%%i"=="列:　　" set "Window.Wide=%%~j"
)
set /a "listzip.LineViewBlock=Window.Height-5"

:: 生成压缩档文件列表
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" >"%listzip.txt%" (
	if not defined listzip.Dir "!path.editor.%%a!" l "%path.Archive%" | findstr /v "\\"
	if defined listzip.Dir (
		echo.-----------
		"!path.editor.%%a!" l "%path.Archive%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*"
		echo,-----------
	)
)

:: 找到列出压缩档内容的位置
set /a listzip.LineFileStart=0, listzip.LineFileEnd=0
for /f "tokens=1 delims=:" %%i in ('findstr /n "^-----------" "%listzip.txt%" ') do (
	if "!listzip.LineFileStart!"=="0" (set "listzip.LineFileStart=%%i") else (set /a "listzip.LineFileEnd=%%i-2")
)

::设定显示行首行数
if not defined listzip.LineViewStart set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% LSS %listzip.LineFileStart% set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% GTR %listzip.LineFileEnd% set /a "listzip.LineViewStart-=listzip.LineViewBlock"

::设定显示行末行数
set /a "listzip.LineViewEnd=listzip.LineViewStart+listzip.LineViewBlock-1"
if %listzip.LineViewEnd% GTR %listzip.LineFileEnd% set /a "listzip.LineViewEnd=listzip.LineFileEnd"

::计算文件项数和显示页数
set /a "listzip.LineFileTotal=listzip.LineFileEnd-listzip.LineFileStart+1"
set /a "listzip.ViewPageNow=((listzip.LineViewStart-listzip.LineFileStart)/listzip.LineViewBlock)+1"
set /a "listzip.ViewPageTotal=(listzip.LineFileTotal-1)/listzip.LineViewBlock+1"

::配置压缩参数栏
if "%listzip.Dir%"=="" (
	if "%type.editor%"=="rar" (
		set /a "listzip.LineFileInfo=listzip.LineFileStart-4"
		call :分析一行内容 !listzip.LineFileInfo!
		call set "listzip.Info=%%listzip.LineFile.!listzip.LineFileInfo!:~3%%"
	)
	
	if "%type.editor%"=="7z" (
		set "listzip.Info="
		for /f "tokens=1-2 delims==" %%i in ('findstr "^Type ^Offset ^Method ^Solid " "%listzip.txt%"') do (
			if "%%i"=="Type " set "listzip.Info=!listzip.Info!%%j"
			if "%%i"=="Offset " set "listzip.Info=!listzip.Info!, 自解压"
			if "%%i"=="Method " set "listzip.Info=!listzip.Info!,%%j"
			if "%%i"=="Solid " if "%%j"==" +" set "listzip.Info=!listzip.Info!, 固实"
		)
	)
)

::UI--------------------------------------------------

::显示压缩档操作选项
if "%listzip.Menu%"=="basic" (
	if "%ui.Archive.writeable%"=="y" echo.  主页 │  打开 提取 解压到 添加 删除 重命名 高级 上页 下页 进入 上级
	if "%ui.Archive.writeable%"==""  echo.  主页 │  打开 提取 解压到                  高级 上页 下页 进入 上级
)
if "%listzip.Menu%"=="advance" (
	if "%type.editor%"=="7z"  echo.  主页 │  基本 测试
	if "%type.editor%"=="rar" echo.  主页 │  基本 测试 修复 锁定 添加注释 自解压转换
)
echo.
if "%type.editor%"=="7z" echo.   日期      时间    属性         大小       压缩后  名称
if "%type.editor%"=="rar" echo.     属性        大小     日期     时间  名称

:: if 判断排除空压缩档。输出压缩档内容到屏幕，读至变量
if %listzip.LineFileStart% LEQ %listzip.LineFileEnd% (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :分析一行内容 %%a
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		for %%d in (%Window.Wide%) do echo,!listzip.LineView.%%a:~0,%%d!
	)
)

::补充空行
set /a "listzip.ViewEchoEnd=listzip.LineViewStart+listzip.LineViewBlock"
set /a "listzip.ViewEchoSpace=listzip.ViewEchoEnd-listzip.LineFileEnd-2"
if %listzip.LineViewEnd% LSS %listzip.ViewEchoEnd% (
	for /l %%a in (0,1,!listzip.ViewEchoSpace!) do echo.
)

::调试注释，常闭
::echo. File {%listzip.LineFileStart%:%listzip.LineFileEnd%} View [%listzip.LineViewStart%:%listzip.LineViewEnd%]
::echo,!listzip.Dir!  !listzip.Dir.p!

::下方提示
if "%listzip.Dir%"=="" echo.  %listzip.ViewPageNow%/%listzip.ViewPageTotal% 页  %listzip.LineFileTotal% 个项目 %listzip.Info%
if not "%listzip.Dir%"=="" echo.  %listzip.ViewPageNow%/%listzip.ViewPageTotal% 页  %listzip.LineFileTotal% 个项目  %listzip.Dir:\= ^> %

::UI--------------------------------------------------
::坐标判断
%tmouse% /d 0 -1 1
%tmouse.process%
::ping localhost -n 2 >nul

set /a listzip.ButtonLine=3
if defined mouse.x if defined mouse.y (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		if defined listzip.LineFile.%%a (
			if %mouse.y% EQU !listzip.ButtonLine! (
				if "%type.editor%"=="rar" if %mouse.x% GEQ 41 (
					if "!listzip.LineFile.%%a:~7,1!"=="D" call :进入 "!listzip.LineFile.%%a:~41!"
					if not "!listzip.LineFile.%%a:~7,1!"=="D" call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%a:~41!"
				)
				if "%type.editor%"=="7z" if %mouse.x% GEQ 53 (
					if "!listzip.LineFile.%%a:~20,1!"=="D" call :进入 "!listzip.LineFile.%%a:~53!"
					if not "!listzip.LineFile.%%a:~20,1!"=="D" call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%a:~53!"
				)
			)
		)
		set /a "listzip.ButtonLine+=1"
	)
)

for %%A in (
	basic}10}13}0}0}1}
	basic}15}18}0}0}2}
	basic}20}25}0}0}3}
	basic}27}30}0}0}4}
	basic}32}35}0}0}5}
	basic}37}42}0}0}6}
	basic}44}47}0}0}7}
	basic}49}52}0}0}8}
	basic}54}57}0}0}9}
	basic}59}62}0}0}10}
	basic}64}67}0}0}11}
	advance}10}13}0}0}a1}
	advance}15}18}0}0}a2}
	advance}20}23}0}0}a3}
	advance}25}28}0}0}a4}
	advance}30}37}0}0}a5}
	advance}39}48}0}0}a6}
	basic}1}5}0}0}e}
	advance}1}5}0}0}e}
) do for /f "tokens=1-6 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y if "%listzip.Menu%"=="%%a" (
		if %mouse.x% GEQ %%b if %mouse.x% LEQ %%c if %mouse.y% GEQ %%d if %mouse.y% LEQ %%e set "key=%%f"
	)
)

if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" UnPart
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Add.cmd"
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance"
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%"
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%"
) else if "%key%"=="10" ( call :进入
) else if "%key%"=="11" ( call :进入 ..
) else if "%key%"=="a1" ( set "listzip.Menu=basic"
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd"
) else if "%key%"=="e" ( start /i "" "%path.jzip.launcher%" & goto :EOF
)
goto :Menu


:分析一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do (
	set "listzip.LineFile.%1=%%a"
	call set "listzip.LineView.%1=%%listzip.LineFile.%1!:%listzip.Dir%\=%%"
	if "%type.editor%"=="7z" if "!listzip.LineFile.%1:~20,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,53!<!listzip.LineView.%1:~53!>"
	if "%type.editor%"=="rar" if "!listzip.LineFile.%1:~7,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,41!<!listzip.LineView.%1:~41!>"
	goto :EOF
)
goto :EOF

:输出一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do echo,%%a & goto :EOF
goto :EOF

:进入
if "%~1"=="" (
	set "listzip.Dir="
	for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("进入的文件夹：","提示"))(window.close)"') do (
		set "listzip.Dir=%%a"
		if "!listzip.Dir:~0,1!"=="\" set "listzip.Dir=!listzip.Dir:~1!"
	)
) else if "%~1"==".." (
	for /f "delims=" %%b in ("!listzip.Dir!") do (
		set "listzip.Dir=%%~b"
		set "listzip.Dir=!listzip.Dir:%%~nxb=!"
		if "!listzip.Dir:~-1!"=="\" set "listzip.Dir=!listzip.Dir:~0,-1!"
	)
) else if not "%~1"=="" (
	set "listzip.Dir=%~1"
	)

if defined listzip.Dir (
	set "listzip.Dir.p=!listzip.Dir:\=\\!"
	set "listzip.Dir.p=!listzip.Dir.p: =\ !"
	set "listzip.Dir.p=!listzip.Dir.p:[=\[!"
	set "listzip.Dir.p=!listzip.Dir.p:]=\]!"
	set "listzip.Dir.p=!listzip.Dir.p:.=\.!"
	set "listzip.Dir.p=!listzip.Dir.p:^=\^!"
	set "listzip.Dir.p=!listzip.Dir.p:$=\$!"
) else (
	set "listzip.Dir.p="
)
set "listzip.LineViewStart="
goto :EOF


