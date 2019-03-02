
::初始变量设定 
@echo off
color %Color%
title %path.Archive% %title%

set /a Window.Columns=110, Window.Lines=35
mode %Window.Columns%, %Window.Lines%
for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
for /f "delims=" %%a in ('cscript //nologo "%dir.jzip%\Function\Create_GUID.vbs"') do set "random1=%%a"
set "listzip.txt=%dir.jzip.temp%\%random1%.tmp"
set "listzip.Dir="
set "listzip.Menu=basic"

:: 压缩文件可用性检测 
for %%a in (rar 7z cab) do if "%type.editor%"=="%%a" >nul "!path.editor.%%a!" l "%path.Archive%" %iferror%

:Menu
cls

:: 动态调整窗口大小，调试时需注释以禁用 
for /f "tokens=1-2" %%a in ('mode') do (
	if /i "%%a"=="行:　" set Window.Lines=%%~b
	if /i "%%a"=="Lines:" set Window.Lines=%%~b
	if /i "%%a"=="列:　　" set /a Window.Columns=%%~b-1
	if /i "%%a"=="Columns:" set /a Window.Columns=%%~b-1
)
set /a "listzip.LineViewBlock=Window.Lines-5"

:: UTF-8 代码页检测 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
	for %%z in (
		65001}rar}-scf
		65001}7z}-sccutf-8
	) do for /f "tokens=1-3 delims=}" %%a in ("%%z") do (
		if "%%i"==" %%a" if "%type.editor%"=="%%b" set "btn.utf8=%%c"
	)
)

:: 配置压缩参数栏，处于压缩文件根目录时 
if "%listzip.Dir%"=="" (
	set "listzip.Info="
	if "%type.editor%"=="rar" (
		for /f "tokens=2* delims=:" %%i in (' call "%path.editor.rar%" l "%path.Archive%" ^| findstr /r "^Details:" ') do (
			set "listzip.Info=%%i"
			set "listzip.Info=!listzip.Info:solid=%txt_solid%!"
			set "listzip.Info=!listzip.Info:SFX=%txt_sfx%!"
			set "listzip.Info=!listzip.Info:lock=%txt_lock%!"
		)
	)
	if "%type.editor%"=="7z" (
		for /f "tokens=1-2* delims==" %%i in (' call "%path.editor.7z%" l "%path.Archive%" ^| findstr /r "^Type ^Offset ^Method ^Solid " ') do (
			if "%%i"=="Type " set "listzip.Info=!listzip.Info!%%j"
			if "%%i"=="Offset " set "listzip.Info=!listzip.Info!, %txt_sfx%"
			if "%%i"=="Method " set "listzip.Info=!listzip.Info!,%%j"
			if "%%i"=="Solid " if "%%j"==" +" set "listzip.Info=!listzip.Info!, %txt_solid%"
		)
	)
)

:: 生成压缩档文件列表
for %%z in (
	rar}"^    ...D... "}"^    ..A\.... "
	7z}"^.......... ........ D.... "}"^.......... ........ \..... "
) do for /f "tokens=1-3 delims=}" %%a in ("%%z") do (
	if "%type.editor%"=="%%a" >"%listzip.txt%" (
		echo,.
		if defined listzip.Dir (
			"!path.editor.%%a!" l %btn.utf8% "%path.Archive%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*" | findstr /r /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf8% "%path.Archive%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*" | findstr /r /c:"%%~c"
		) else (
			"!path.editor.%%a!" l %btn.utf8% "%path.Archive%" | findstr /v "\\" | findstr /r /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf8% "%path.Archive%" | findstr /v "\\" | findstr /r /c:"%%~c"
		)
	)
)

:: 找到列出压缩档内容的位置 
set listzip.LineFileStart=1
for /f "tokens=3 delims=:" %%i in (' find /v /c "" "%listzip.txt%" ') do (
	if %%i LSS 1 ( set "listzip.LineFileEnd=1" ) else ( set /a "listzip.LineFileEnd=%%i-1" )
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

::UI--------------------------------------------------

::显示压缩档操作选项 
if "%listzip.Menu%"=="basic" (
	if "%ui.Archive.writeable%"=="y" %echo%,  %txt_e.home% %txt_sym.delim% %txt_e.open% %txt_e.extr% %txt_e.unzip% %txt_e.add% %txt_e.del% %txt_e.rn% %txt_e.adv% %txt_e.up% %txt_e.down% %txt_e.ent% %txt_e.back%
	if "%ui.Archive.writeable%"==""  %echo%,  %txt_e.home% %txt_sym.delim% %txt_e.open% %txt_e.extr% %txt_e.unzip%                  %txt_e.adv% %txt_e.up% %txt_e.down% %txt_e.ent% %txt_e.back%
)
if "%listzip.Menu%"=="advance" (
	if "%type.editor%"=="7z"  %echo%,  %txt_e.home% %txt_sym.delim% %txt_e.basic% %txt_e.test%
	if "%type.editor%"=="rar" %echo%,  %txt_e.home% %txt_sym.delim% %txt_e.basic% %txt_e.test% %txt_e.fix% %txt_e.lock% %txt_e.rem% %txt_e.sfx%
)
echo,
for %%i in (7z rar) do if "%type.editor%"=="%%i" (
	if defined listzip.LineFileSel ( echo=!txt_e.bar.%%i:%txt_sym.squ%=%txt_sym.squ.s%! ) else (echo=!txt_e.bar.%%i! )
)

:: if 判断排除空压缩档，处理变量内容并输出到屏幕 
if %listzip.LineFileStart% LEQ %listzip.LineFileEnd% (
	if "%type.editor%"=="7z" (
		for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :分析一行内容 %%a 20 51 53
	)
	if "%type.editor%"=="rar" (
		for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :分析一行内容 %%a 7 39 41
	)
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		for %%d in (%Window.Columns%) do echo,!listzip.LineView.%%a:~0,%%d!
	)
)

::补充空行 
set /a "listzip.ViewEchoEnd=listzip.LineViewStart+listzip.LineViewBlock"
set /a "listzip.ViewEchoSpace=listzip.ViewEchoEnd-listzip.LineFileEnd-2"
if %listzip.LineViewEnd% LSS %listzip.ViewEchoEnd% (
	for /l %%a in (0,1,!listzip.ViewEchoSpace!) do echo,
)

::调试注释，常闭 
::echo, File {%listzip.LineFileStart%:%listzip.LineFileEnd%} View [%listzip.LineViewStart%:%listzip.LineViewEnd%]
::echo,!listzip.Dir!  !listzip.Dir.p!

::下方提示栏 
if "%listzip.Dir%"=="" echo,  %listzip.ViewPageNow%/%listzip.ViewPageTotal% %txt_pages%  %listzip.LineFileTotal% %txt_items% %listzip.Info%
if not "%listzip.Dir%"=="" echo,  %listzip.ViewPageNow%/%listzip.ViewPageTotal% %txt_pages%  %listzip.LineFileTotal% %txt_items%  %listzip.Dir:\= ^> %

::UI--------------------------------------------------
::坐标判断 
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

::压缩档文件列表坐标判断 
set /a listzip.ButtonLine=3
if defined mouse.x if defined mouse.y (
	for /l %%i in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		if defined listzip.LineFile.%%i (
			if %mouse.y% EQU !listzip.ButtonLine! (
				for %%z in (
					7z:53:54:56:20
					rar:41:42:44:7
				) do for /f "tokens=1-5 delims=:" %%a in ("%%z") do (
					if "%type.editor%"=="%%a" (

						if %mouse.x% GEQ %%b if %mouse.x% LEQ %%c (
							if defined listzip.LineFileSel.%%i (set "listzip.LineFileSel.%%i=") else (set "listzip.LineFileSel.%%i=%%i")
							set "listzip.LineFileSel="
							goto :Menu
						)
						if %mouse.x% GEQ %%d (
							call :全不选 
							if "!listzip.LineFile.%%i:~%%e,1!"=="D" call :进入 "!listzip.LineFile.%%i:~%%b!"
							if not "!listzip.LineFile.%%i:~%%e,1!"=="D" call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%i:~%%b!"
						)
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
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Extr & goto :Menu
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip & goto :Menu
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Add
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance" & goto :Menu
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="10" ( call :进入 
) else if "%key%"=="11" ( call :进入  ..
) else if "%key%"=="a1" ( set "listzip.Menu=basic" & goto :Menu
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd"
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :全选切换 & goto :Menu
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :全选切换 & goto :Menu
) else if "%key%"=="e" ( start /i cmd /c call "%path.jzip.launcher%" & goto :EOF
)
call :全不选 
goto :Menu


:分析一行内容 
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do (
	set "listzip.LineFile.%1=%%a"
	call set "listzip.LineView.%1=%%listzip.LineFile.%1!:%listzip.Dir%\=%%"
	if "!listzip.LineFile.%1:~%2,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  <!listzip.LineView.%1:~%4!>"
	if defined listzip.LineFileSel.%1 (
		set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  %txt_sym.squ.s% !listzip.LineView.%1:~%4!"
	) else (
		set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  %txt_sym.squ% !listzip.LineView.%1:~%4!"
	)
	goto :EOF
)
goto :EOF


:进入 
if "%~1"=="" (
	%InputBox% listzip.Dir "%txt_e.type.enterfold%"
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
if defined listzip.LineFileSel ( call :全不选 ) else ( call :全选 )
goto :EOF

:全选 
for /l %%a in (%listzip.LineFileStart%,1,%listzip.LineFileEnd%) do set "listzip.LineFileSel.%%a=%%a"
set "listzip.LineFileSel=all"
goto :EOF

:全不选 
for /f "tokens=1 delims==" %%a in ('2^>nul set "listzip.LineFileSel."') do set "%%a="
set "listzip.LineFileSel="
goto :EOF



