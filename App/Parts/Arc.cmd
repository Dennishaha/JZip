
:: 初始变量设定 
@echo off
color %Color%
title %Arc.path% %title%

set /a Window.Columns=110, Window.Lines=35
mode %Window.Columns%, %Window.Lines%
for %%a in (%jzip.spt.write%) do if /i "%Arc.exten%"==".%%a" set "Arc.Writable=y"

:: 从注册表读取 GUID 配置 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" 2^>nul') do (
	if /i "%%b"=="REG_SZ" set "%%a=%%c"
)
reg delete "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" /f >nul 2>nul

:: 变量设定 
set "listzip.txt=%dir.jzip.temp%\%Arc.Guid%.tmp"
if not defined listzip.Menu set listzip.Menu=basic
if not defined listzip.FileSel set listzip.FileSel=0

:: 设定编码开关 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
	for %%z in (
		rar}ansi}-sca
		rar}utf8}-scf
		7z}ansi}-sccwin}-scswin
		7z}utf8}-sccutf-8}-scsutf-8
	) do for /f "tokens=1-4 delims=}" %%a in ("%%z") do (
		if "%type.editor%"=="%%a" (
			if "%%b"=="utf8" if "%%i"==" 65001" (
				set "btn.utf.a=%%c" & set "btn.utf.b=%%d"
			)
			if "%%b"=="ansi" if not "%%i"==" 65001" (
				set "btn.utf.a=%%c" & set "btn.utf.b=%%d"
			)
		)
	)
)

:: 压缩文件可用性检测 
for %%a in (rar 7z cab) do if "%type.editor%"=="%%a" >nul "!path.editor.%%a!" l "%Arc.path%" %iferror%

:Menu

:: 配置压缩参数栏，处于压缩文件根目录时  
if not defined listzip.Dir (
	set "listzip.Info="
	if "%type.editor%"=="rar" (
		for /f "tokens=2* delims=:" %%i in (' call "%path.editor.rar%" l "%Arc.path%" ^| findstr /r "^Details:" ') do (
			set "listzip.Info=%%i"
			set "listzip.Info=!listzip.Info:solid=%txt_solid%!"
			set "listzip.Info=!listzip.Info:SFX=%txt_sfx%!"
			set "listzip.Info=!listzip.Info:lock=%txt_lock%!"
		)
	)
	if "%type.editor%"=="7z" (
		for /f "tokens=1-2* delims==" %%i in (' call "%path.editor.7z%" l "%Arc.path%" ^| findstr /r "^Type ^Offset ^Method ^Solid " ') do (
			if "%%i"=="Type " set "listzip.Info=!listzip.Info!%%j"
			if "%%i"=="Offset " set "listzip.Info=!listzip.Info!, %txt_sfx%"
			if "%%i"=="Method " set "listzip.Info=!listzip.Info!,%%j"
			if "%%i"=="Solid " if "%%j"==" +" set "listzip.Info=!listzip.Info!, %txt_solid%"
		)
	)
)

:: 生成压缩档文件列表 
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

for %%z in (
	rar}"^    ...D... "}"^    ..A\.... "
	7z}"^.......... ........ D.... "}"^.......... ........ \..... "
) do for /f "tokens=1-3 delims=}" %%a in ("%%z") do (
	if "%type.editor%"=="%%a" >"%listzip.txt%" (
		echo,.
		if defined listzip.Dir (
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*" | findstr /r /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | find " %listzip.Dir%\" | findstr /v "\<%listzip.Dir.p%\\.*\\.*" | findstr /r /c:"%%~c"
		) else (
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | findstr /v "\\" | findstr /r /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | findstr /v "\\" | findstr /r /c:"%%~c"
		)
	)
)

:: 分析文件列表行数 
set listzip.LineFileStart=1
for /f "tokens=3 delims=:" %%i in ('find /v /c "" "%listzip.txt%"') do (
	if %%i LSS 1 ( set "listzip.LineFileEnd=1" ) else ( set /a "listzip.LineFileEnd=%%i-1" )
)

:Menu-fast

:: 动态调整窗口大小，调试时需注释以禁用 
for /f "tokens=1-2" %%a in ('mode') do (
	if /i "%%a"=="行:　" set Window.Lines=%%~b
	if /i "%%a"=="Lines:" set Window.Lines=%%~b
	if /i "%%a"=="列:　　" set /a Window.Columns=%%~b-1
	if /i "%%a"=="Columns:" set /a Window.Columns=%%~b-1
)
set /a "listzip.LineViewBlock=Window.Lines-5"

::设定显示行首行数 
if not defined listzip.LineViewStart set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% LSS %listzip.LineFileStart% set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% GTR %listzip.LineViewBlock% (
	if %listzip.LineViewStart% GTR %listzip.LineFileEnd% set /a "listzip.LineViewStart-=listzip.LineViewBlock"
)

::设定显示行末行数 
set /a "listzip.LineViewEnd=listzip.LineViewStart+listzip.LineViewBlock-1"
if %listzip.LineViewEnd% GTR %listzip.LineFileEnd% set /a "listzip.LineViewEnd=listzip.LineFileEnd"

::计算文件项数和显示页数 
set /a "listzip.FileTotal=listzip.LineFileEnd-listzip.LineFileStart+1"
set /a "listzip.ViewPageNow=((listzip.LineViewStart-listzip.LineFileStart)/listzip.LineViewBlock)+1"
set /a "listzip.ViewPageTotal=(listzip.FileTotal-1)/listzip.LineViewBlock+1"

:: 读取文本至变量并处理 	
if "%type.editor%"=="7z" (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :分析一行内容 %%a 20 51 53
)
if "%type.editor%"=="rar" (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :分析一行内容 %%a 7 39 41
)

::UI--------------------------------------------------

cls

:: 配置第一列栏 

<nul set /p ="  %txt_e.home%  |  "

if "%listzip.Menu%"=="basic" (
	<nul set /p =" %txt_e.open% %txt_e.extr% %txt_e.unzip% "
	if defined Arc.Writable (
		<nul set /p =" %txt_e.add% %txt_e.del% %txt_e.rn% "
	) else (
		<nul set /p ="                  "
	)
	<nul set /p =" %txt_e.adv% "
	if 1 LSS %listzip.ViewPageNow% (
		<nul set /p =" %txt_e.up% "
	) else (
		<nul set /p ="      "
	)
	if %listzip.ViewPageNow% LSS %listzip.ViewPageTotal% (
		<nul set /p =" %txt_e.down% "
	) else (
		<nul set /p ="      "
	)
	<nul set /p =" %txt_e.ent% "
	if defined listzip.Dir (
		<nul set /p =" %txt_e.back%"
	) else (
		<nul set /p ="      "
	)
)

if "%listzip.Menu%"=="advance" (
	<nul set /p =" %txt_e.basic% %txt_e.test% "
	if "%type.editor%"=="rar" <nul set /p =" %txt_e.fix% %txt_e.lock% %txt_e.rem% %txt_e.sfx%"
)
echo,
echo,

:: 配置第三列栏 
for %%i in (7z rar) do if "%type.editor%"=="%%i" (
	if %listzip.FileTotal% GTR 0 (
		if "%listzip.FileSel%"=="%listzip.FileTotal%" (
			echo,!txt_e.bar.%%i:%txt_sym.squ%=%txt_sym.squ.s%!
		) else (
			echo,!txt_e.bar.%%i!
		)
	) else (
		echo,!txt_e.bar.%%i!
	)
)

:: 读取变量内容并输出到屏幕 
for %%a in (%Window.Columns%) do (
	for /l %%i in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		echo,!listzip.LineView.%%i:~0,%%a!
	)
)

:: 补充空行 
set /a "listzip.ViewEchoEnd=listzip.LineViewStart+listzip.LineViewBlock-2"
for /l %%i in (!listzip.LineFileEnd!,1,!listzip.ViewEchoEnd!) do echo,

:: 调试注释，常闭 
::echo, File {%listzip.LineFileStart%:%listzip.LineFileEnd%} View [%listzip.LineViewStart%:%listzip.LineViewEnd%]
::echo,!listzip.Dir!  !listzip.Dir.p!

:: 下方提示栏 
<nul set /p ="  %listzip.ViewPageNow%/%listzip.ViewPageTotal% %txt_pages%  "
if "%listzip.Dir%"=="" echo,%listzip.FileTotal% %txt_items% %listzip.Info%
if not "%listzip.Dir%"=="" echo,%listzip.FileTotal% %txt_items%  %listzip.Dir:\= ^> %

::UI--------------------------------------------------

:: Arc.Do 行为判断 
if defined Arc.Do (
	for %%z in (
		Unzip}3}
		Add}4}
		Delete}5}
		ReName}6}
		Repair}a3}
		Lock}a4}
		Note}a5}
		Sfx}a6}
	) do for /f "tokens=1-2 delims=}" %%a in ("%%z") do (
		if /i "%Arc.Do%"=="%%a" (
			set key=%%b
			goto :Arc.Do
		)
	)
)

:: 坐标判断 
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

:: 压缩档文件列表坐标判断 
set /a listzip.ButtonLine=listzip.LineViewStart+mouse.y-3
if %listzip.LineViewStart% LEQ %listzip.ButtonLine% if %listzip.ButtonLine% LEQ %listzip.LineViewEnd% (
	for /f %%i in ("%listzip.ButtonLine%") do (
		if defined listzip.LineFile.%%i (
			for %%z in (
				7z:53:54:56:20
				rar:41:42:44:7
			) do for /f "tokens=1-5 delims=:" %%a in ("%%z") do (
				if "%type.editor%"=="%%a" (
					if %%b LEQ %mouse.x% if %mouse.x% LEQ %%c (
						if defined listzip.FileSel.%%i (
							set "listzip.FileSel.%%i="
							set /a "listzip.FileSel-=1"
						) else (
							set "listzip.FileSel.%%i=%%i"
							set /a "listzip.FileSel+=1"
							)
						goto :Menu-fast
					)
					if %mouse.x% GEQ %%d (
						call :全不选 
						if "!listzip.LineFile.%%i:~%%e,1!"=="D" (
							call :进入 "!listzip.LineFile.%%i:~%%b!"
							goto :Menu
						) else (
							call "%dir.jzip%\Parts\Arc_Expan.cmd" Open "!listzip.LineFile.%%i:~%%b!"
							goto :Menu-fast
						)
					)
				)
			)
		)
	)
)

:: 界面操作栏坐标判断 
if "%listzip.Menu%"=="basic" for %%A in (
	11}14}0}0}1}
	16}19}0}0}2}
	21}26}0}0}3}
	28}31}0}0}4}
	33}36}0}0}5}
	38}43}0}0}6}
	45}48}0}0}7}
	50}53}0}0}8}
	55}58}0}0}9}
	60}63}0}0}10}
	65}68}0}0}11}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %%a LEQ %mouse.x% if %mouse.x% LEQ %%b if %%c LEQ %mouse.y% if %mouse.y% LEQ %%d set "key=%%e"
)

if "%listzip.Menu%"=="advance" for %%A in (
	11}14}0}0}a1}
	16}19}0}0}a2}
	21}24}0}0}a3}
	26}29}0}0}a4}
	31}38}0}0}a5}
	40}49}0}0}a6}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %%a LEQ %mouse.x% if %mouse.x% LEQ %%b if %%c LEQ %mouse.y% if %mouse.y% LEQ %%d set "key=%%e"
)

for %%A in (
	1}6}0}0}e}
	41}42}2}2}s1}
	53}54}2}2}s2}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %%a LEQ %mouse.x% if %mouse.x% LEQ %%b if %%c LEQ %mouse.y% if %mouse.y% LEQ %%d set "key=%%e"
)


:Arc.Do
if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Extr
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip
) else if "%key%"=="4" ( if "%Arc.Writable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Add
) else if "%key%"=="5" ( if "%Arc.Writable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Delete
) else if "%key%"=="6" ( if "%Arc.Writable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance" & goto :Menu-fast
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%" & goto :Menu-fast
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%" & goto :Menu-fast
) else if "%key%"=="10" ( call :进入 
) else if "%key%"=="11" ( call :进入  ..
) else if "%key%"=="a1" ( set "listzip.Menu=basic" & goto :Menu-fast
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Sfx
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :全选切换 & goto :Menu-fast
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :全选切换 & goto :Menu-fast
) else if "%key%"=="e" ( start /i cmd /c call "%path.jzip.launcher%" & goto :EOF
)

:: Arc.Do 结束 
set Arc.Do=

call :全不选 
goto :Menu


:分析一行内容 
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do (
	set "listzip.LineFile.%1=%%a"
	call set "listzip.LineView.%1=%%listzip.LineFile.%1!:%listzip.Dir%\=%%"
	if "!listzip.LineFile.%1:~%2,1!"=="D" set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  <!listzip.LineView.%1:~%4!>"
	if defined listzip.FileSel.%1 (
		set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  %txt_sym.squ.s% !listzip.LineView.%1:~%4!"
	) else (
		set "listzip.LineView.%1=!listzip.LineView.%1:~0,%3!  %txt_sym.squ% !listzip.LineView.%1:~%4!"
	)
	goto :EOF
)
goto :EOF


:进入 
if "%~1"=="" (
	%InputBox-r% listzip.Dir "\%listzip.Dir%" "%txt_e.type.enterfold%"
	if "!listzip.Dir:~0,1!"=="\" set "listzip.Dir=!listzip.Dir:~1!"
) else if "%~1"==".." (
	if defined listzip.Dir (
		for /f "delims=" %%b in ("!listzip.Dir!") do (
			set "listzip.Dir=%%~b"
			set "listzip.Dir=!listzip.Dir:%%~nxb=!"
			if "!listzip.Dir:~-1!"=="\" set "listzip.Dir=!listzip.Dir:~0,-1!"
		)
	)
) else if not "%~1"=="" (
	set "listzip.Dir=%~1"
	)

set "listzip.LineViewStart="
goto :EOF


:全选切换 
if "%listzip.FileSel%"=="%listzip.FileTotal%" ( call :全不选 ) else ( call :全选 )
goto :EOF

:全选 
for /l %%a in (%listzip.LineFileStart%,1,%listzip.LineFileEnd%) do set "listzip.FileSel.%%a=%%a"
set "listzip.FileSel=%listzip.FileTotal%"
goto :EOF

:全不选 
for /f "tokens=1 delims==" %%a in ('2^>nul set "listzip.FileSel."') do set "%%a="
set "listzip.FileSel=0"
goto :EOF



