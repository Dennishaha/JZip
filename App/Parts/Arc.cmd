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
for /f "tokens=2 delims= " %%a in ('mode ^| findstr "列: Columns:"') do set "Window.Wide=%%~a"
for /f "tokens=2 delims= " %%a in ('mode ^| findstr "行: Lines:"') do set "Window.Height=%%~a"
set /a "listzip.LineViewBlock=Window.Height-5"

:: 生成压缩档文件列表
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" >"%listzip.txt%" (
	if not defined listzip.Dir "!path.editor.%%a!" l "%path.Archive%" | findstr /v "\\"
	if defined listzip.Dir (
		echo.-----------
		"!path.editor.%%a!" l "%path.Archive%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*"
		echo.-----------
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
		for /f "tokens=2* delims=:" %%i in ('findstr "^详情:" "%listzip.txt%"') do (
			set "listzip.Info=%%i"
		)
	)
	if "%type.editor%"=="7z" (
		set "listzip.Info="
		for /f "tokens=1-2* delims==" %%i in ('findstr "^Type ^Offset ^Method ^Solid " "%listzip.txt%"') do (
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
if "%type.editor%"=="7z" (	
	if not defined listzip.LineFileSel echo.   日期      时间    属性         大小       压缩后  ○  名称
	if defined listzip.LineFileSel echo.   日期      时间    属性         大小       压缩后  ●  名称
)
if "%type.editor%"=="rar" (
	if not defined listzip.LineFileSel echo.     属性        大小     日期     时间  ○  名称
	if defined listzip.LineFileSel echo.     属性        大小     日期     时间  ●  名称
)

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
::%tmouse.test%

::压缩档文件列表坐标判断
set /a listzip.ButtonLine=3
if defined mouse.x if defined mouse.y (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		if defined listzip.LineFile.%%a (
			if %mouse.y% EQU !listzip.ButtonLine! (
				if "%type.editor%"=="rar" (
					if %mouse.x% GEQ 41 if %mouse.x% LEQ 42 (
						if defined listzip.LineFileSel.%%a (set "listzip.LineFileSel.%%a=") else (set "listzip.LineFileSel.%%a=%%a")
						set "listzip.LineFileSel="
						goto :Menu
					)
					if %mouse.x% GEQ 45 (
						call :全不选
						if "!listzip.LineFile.%%a:~7,1!"=="D" call :进入 "!listzip.LineFile.%%a:~41!"
						if not "!listzip.LineFile.%%a:~7,1!"=="D" call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%a:~41!"
					)
				)
				if "%type.editor%"=="7z" (

					if %mouse.x% GEQ 53 if %mouse.x% LEQ 54 (
						if defined listzip.LineFileSel.%%a (set "listzip.LineFileSel.%%a=") else (set "listzip.LineFileSel.%%a=%%a")
						set "listzip.LineFileSel="
						goto :Menu
					)
					if %mouse.x% GEQ 57 (
						call :全不选
						if "!listzip.LineFile.%%a:~20,1!"=="D" call :进入 "!listzip.LineFile.%%a:~53!"
						if not "!listzip.LineFile.%%a:~20,1!"=="D" call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%a:~53!"
					)
				)
			)
		)
		set /a "listzip.ButtonLine+=1"
	)
)

::界面操作栏坐标判断
if "%listzip.Menu%"=="basic" for %%A in (
	10}13}0}0}1}
	15}18}0}0}2}
	20}25}0}0}3}
	27}30}0}0}4}
	32}35}0}0}5}
	37}42}0}0}6}
	44}47}0}0}7}
	49}52}0}0}8}
	54}57}0}0}9}
	59}62}0}0}10}
	64}67}0}0}11}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

if "%listzip.Menu%"=="advance" for %%A in (
	10}13}0}0}a1}
	15}18}0}0}a2}
	20}23}0}0}a3}
	25}28}0}0}a4}
	30}37}0}0}a5}
	39}48}0}0}a6}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

for %%A in (
	1}5}0}0}e}
	41}42}2}2}s1}
	53}54}2}2}s2}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" UnPart & goto :Menu
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip & goto :Menu
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Add
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance" & goto :Menu
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="10" ( call :进入
) else if "%key%"=="11" ( call :进入 ..
) else if "%key%"=="a1" ( set "listzip.Menu=basic" & goto :Menu
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd"
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :全选切换 & goto :Menu
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :全选切换 & goto :Menu
) else if "%key%"=="e" ( start /i "" cmd /c "%path.jzip.launcher%" & goto :EOF
)
call :全不选
goto :Menu


:分析一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do (
	set "listzip.LineFile.%1=%%a"
	call set "listzip.LineView.%1=%%listzip.LineFile.%1!:%listzip.Dir%\=%%"
	if "%type.editor%"=="7z" (
		if "!listzip.LineFile.%1:~20,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,51!  <!listzip.LineView.%1:~53!>"
		if defined listzip.LineFileSel.%1 (
			set "listzip.LineView.%1=!listzip.LineView.%1:~0,51!  ●  !listzip.LineView.%1:~53!"
		) else (
			set "listzip.LineView.%1=!listzip.LineView.%1:~0,51!  ○  !listzip.LineView.%1:~53!"
		)
	)
	if "%type.editor%"=="rar" (
		if "!listzip.LineFile.%1:~7,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,39!  <!listzip.LineView.%1:~41!>"
		if defined listzip.LineFileSel.%1 (
			set "listzip.LineView.%1=!listzip.LineView.%1:~0,39!  ●  !listzip.LineView.%1:~41!"
		) else (
		 	set "listzip.LineView.%1=!listzip.LineView.%1:~0,39!  ○  !listzip.LineView.%1:~41!"
		)
	)
	goto :EOF
)
goto :EOF

:输出一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do echo,%%a & goto :EOF
goto :EOF

:进入
if "%~1"=="" (
	call "%dir.jzip%\Parts\VbsBox" InputBox listzip.Dir "进入的文件夹："
	if not defined listzip.Dir goto :EOF
	if "!listzip.Dir:~0,1!"=="\" set "listzip.Dir=!listzip.Dir:~1!"
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


:全选切换
if defined listzip.LineFileSel (call :全不选) else (call :全选)
goto :EOF

:全选
for /l %%a in (%listzip.LineFileStart%,1,%listzip.LineFileEnd%) do set "listzip.LineFileSel.%%a=%%a"
set "listzip.LineFileSel=all"
goto :EOF

:全不选
for /f "tokens=1 delims==" %%a in ('2^>nul set "listzip.LineFileSel."') do set "%%a="
set "listzip.LineFileSel="
goto :EOF



