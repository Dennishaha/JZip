
:: 初始变量设定 
@echo off
color %Color%
title %Arc.path% %title%

set /a Window.Columns=115, Window.Lines=35
mode %Window.Columns%, %Window.Lines%
for %%a in (%jzip.spt.write%) do if /i "%Arc.exten%"==".%%a" set "Arc.Writable=y"

:: 从注册表读取 GUID 配置 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" 2^>nul') do (
	if /i "%%b"=="REG_SZ" set "%%a=%%c"
)
reg delete "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" /f >nul 2>nul

:: 变量设定 
set "lz.txt=%dir.jzip.temp%\%Arc.Guid%.tmp"
if not defined lz.Menu set lz.Menu=basic
if not defined lz.FileSel set lz.FileSel=0

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
if not defined lz.Dir (
	set "lz.Info="
	if "%type.editor%"=="rar" (
		for /f "tokens=2* delims=:" %%i in (' call "%path.editor.rar%" l "%Arc.path%" ^| findstr /r "^Details:" ') do (
			set "lz.Info=%%i"
			set "lz.Info=!lz.Info:solid=%txt_solid%!"
			set "lz.Info=!lz.Info:SFX=%txt_sfx%!"
			set "lz.Info=!lz.Info:lock=%txt_lock%!"
		)
	)
	if "%type.editor%"=="7z" (
		for /f "tokens=1-2* delims==" %%i in (' call "%path.editor.7z%" l "%Arc.path%" ^| findstr /r "^Type ^Offset ^Method ^Solid " ') do (
			if "%%i"=="Type " set "lz.Info=!lz.Info!%%j"
			if "%%i"=="Offset " set "lz.Info=!lz.Info!, %txt_sfx%"
			if "%%i"=="Method " set "lz.Info=!lz.Info!,%%j"
			if "%%i"=="Solid " if "%%j"==" +" set "lz.Info=!lz.Info!, %txt_solid%"
		)
	)
)

:: 生成压缩档文件列表 
if defined lz.Dir (
	set "lz.Dir.p=!lz.Dir:\=\\!"
	set "lz.Dir.p=!lz.Dir.p: =\ !"
	set "lz.Dir.p=!lz.Dir.p:[=\[!"
	set "lz.Dir.p=!lz.Dir.p:]=\]!"
	set "lz.Dir.p=!lz.Dir.p:.=\.!"
	set "lz.Dir.p=!lz.Dir.p:^=\^!"
	set "lz.Dir.p=!lz.Dir.p:$=\$!"
) else (
	set "lz.Dir.p="
)

for %%z in (
	rar}"^    ...D... "}"^    ..A\.... "
	7z}"^.......... ........ D.... "}"^.......... ........ \..... "
) do for /f "tokens=1-3 delims=}" %%a in ("%%z") do (
	if "%type.editor%"=="%%a" >"%lz.txt%" (
		echo,.
		if defined lz.Dir (
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | find /i " %lz.Dir%\" | findstr /i /v "\<%lz.Dir.p%\\.*\\.*" | findstr /r /i /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | find /i " %lz.Dir%\" | findstr /i /v "\<%lz.Dir.p%\\.*\\.*" | findstr /r /i /c:"%%~c"
		) else (
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | findstr /v "\\" | findstr /r /i /c:"%%~b"
			"!path.editor.%%a!" l %btn.utf.a% "%Arc.path%" | findstr /v "\\" | findstr /r /i /c:"%%~c"
		)
	)
)

:: 分析文件列表行数 
set lz.LineFileStart=1
for /f "tokens=3 delims=:" %%i in ('find /v /c "" "%lz.txt%"') do (
	if %%i LSS 1 ( set "lz.LineFileEnd=1" ) else ( set /a "lz.LineFileEnd=%%i-1" )
)

:Fast1 

:: 动态调整窗口大小，调试时需注释以禁用 
for /f "tokens=1-2" %%a in ('mode') do (
	if /i "%%a"=="行:　" set Window.Lines=%%~b
	if /i "%%a"=="Lines:" set Window.Lines=%%~b
	if /i "%%a"=="列:　　" set /a Window.Columns=%%~b-1
	if /i "%%a"=="Columns:" set /a Window.Columns=%%~b-1
)
set /a "lz.LineViewBlock=Window.Lines-5"

::设定显示行首行数 
if not defined lz.LineViewStart set /a "lz.LineViewStart=lz.LineFileStart"
if %lz.LineViewStart% LSS %lz.LineFileStart% set /a "lz.LineViewStart=lz.LineFileStart"
if %lz.LineViewStart% GTR %lz.LineViewBlock% (
	if %lz.LineViewStart% GTR %lz.LineFileEnd% set /a "lz.LineViewStart-=lz.LineViewBlock"
)

::设定显示行末行数 
set /a "lz.LineViewEnd=lz.LineViewStart+lz.LineViewBlock-1"
if %lz.LineViewEnd% GTR %lz.LineFileEnd% set /a "lz.LineViewEnd=lz.LineFileEnd"

::计算文件项数和显示页数 
set /a "lz.FileTotal=lz.LineFileEnd-lz.LineFileStart+1"
set /a "lz.ViewPageNow=((lz.LineViewStart-lz.LineFileStart)/lz.LineViewBlock)+1"
set /a "lz.ViewPageTotal=(lz.FileTotal-1)/lz.LineViewBlock+1"

:: 读取文本至变量并处理 	
if "%type.editor%"=="7z" (
	for /l %%a in (%lz.LineViewStart%,1,%lz.LineViewEnd%) do call :分析一行内容 %%a 21 52 54
)
if "%type.editor%"=="rar" (
	for /l %%a in (%lz.LineViewStart%,1,%lz.LineViewEnd%) do call :分析一行内容 %%a 8 40 42
)

:Fast2 

::UI--------------------------------------------------

cls

:: 配置第一列栏 

<nul set /p ="  %txt_e.home%  |  "

if "%lz.Menu%"=="basic" (
	<nul set /p =" %txt_e.open% %txt_e.extr% %txt_e.unzip% "
	if defined Arc.Writable (
		<nul set /p =" %txt_e.add% %txt_e.del% %txt_e.rn% "
	) else (
		<nul set /p ="                  "
	)
	<nul set /p =" %txt_e.adv% "
	if 1 LSS %lz.ViewPageNow% (
		<nul set /p =" %txt_e.up% "
	) else (
		<nul set /p ="      "
	)
	if %lz.ViewPageNow% LSS %lz.ViewPageTotal% (
		<nul set /p =" %txt_e.down% "
	) else (
		<nul set /p ="      "
	)
	<nul set /p =" %txt_e.ent% "
	if defined lz.Dir (
		<nul set /p =" %txt_e.back%"
	) else (
		<nul set /p ="      "
	)
)

if "%lz.Menu%"=="advance" (
	<nul set /p =" %txt_e.basic% %txt_e.test% "
	if "%type.editor%"=="rar" <nul set /p =" %txt_e.fix% %txt_e.lock% %txt_e.rem% %txt_e.sfx%"
)
echo,
echo,

:: 配置第三列栏 
for %%i in (7z rar) do if "%type.editor%"=="%%i" (
	if %lz.FileTotal% GTR 0 (
		if "%lz.FileSel%"=="%lz.FileTotal%" (
			echo, !txt_e.bar.%%i:%txt_sym.squ%=%txt_sym.squ.s%!
		) else (
			echo, !txt_e.bar.%%i!
		)
	) else (
		echo, !txt_e.bar.%%i!
	)
)

:: 读取变量内容并输出到屏幕 
for %%a in (%Window.Columns%) do (
	for /l %%i in (%lz.LineViewStart%,1,%lz.LineViewEnd%) do (
		echo,!lz.LineView.%%i:~0,%%a!
	)
)

:: 补充空行 
set /a "lz.ViewEchoEnd=lz.LineViewStart+lz.LineViewBlock-2"
for /l %%i in (!lz.LineFileEnd!,1,!lz.ViewEchoEnd!) do echo,

:: 调试注释，常闭 
::echo, File {%lz.LineFileStart%:%lz.LineFileEnd%} View [%lz.LineViewStart%:%lz.LineViewEnd%]
::echo,!lz.Dir!  !lz.Dir.p!

:: 下方提示栏 
setlocal
set "bar=   %lz.ViewPageNow%/%lz.ViewPageTotal% %txt_pages%  %lz.FileTotal% %txt_items%"
if %lz.FileSel% GTR 0 set "bar=%bar%  %txt_selected% %lz.FileSel% %txt_item%"
if defined lz.Dir set "bar=%bar%  ^> %lz.Dir:\= ^> %"
if not defined lz.Dir set "bar=%bar% %lz.Info%"
call echo,%%bar:~0,%Window.Columns%%%
endlocal


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
set /a lz.ButtonLine=lz.LineViewStart+mouse.y-3
if %lz.LineViewStart% LEQ %lz.ButtonLine% if %lz.ButtonLine% LEQ %lz.LineViewEnd% (
	for /f %%i in ("%lz.ButtonLine%") do (
		if defined lz.LineFile.%%i (
			for %%z in (
				7z:21:52:54:55:57
				rar:8:40:42:43:45
			) do for /f "tokens=1-5 delims=:" %%a in ("%%z") do (
				if "%type.editor%"=="%%a" (
					if %%d LEQ %mouse.x% if %mouse.x% LEQ %%e (
						if defined lz.FileSel.%%i (
							set "lz.FileSel.%%i="
							set /a "lz.FileSel-=1"
						) else (
							set "lz.FileSel.%%i=%%i"
							set /a "lz.FileSel+=1"
						)
						call :分析一行内容  %%i %%b %%c %%d
						goto :Fast2
					)
					if %mouse.x% GEQ %%f (
						call :全不选 
						if "!lz.LineFile.%%i:~%%b,1!"=="D" (
							call :进入  "!lz.LineFile.%%i:~%%d!"
							goto :Menu
						) else (
							set "lz.FileSel.%%i=%%i"
							set /a "lz.FileSel+=1"
							call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
							goto :Fast1
						)
					)
				)
			)
		)
	)
)

:: 界面操作栏坐标判断 
if "%lz.Menu%"=="basic" for %%A in (
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

if "%lz.Menu%"=="advance" for %%A in (
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
	42}43}2}2}s1}
	54}55}2}2}s2}
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
) else if "%key%"=="7" ( set "lz.Menu=advance"
) else if "%key%"=="8" ( set /a "lz.LineViewStart-=%lz.LineViewBlock%"
) else if "%key%"=="9" ( set /a "lz.LineViewStart+=%lz.LineViewBlock%"
) else if "%key%"=="10" ( call :进入 
) else if "%key%"=="11" ( call :进入  ..
) else if "%key%"=="a1" ( set "lz.Menu=basic"
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Sfx
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :全选切换
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :全选切换
) else if "%key%"=="e" ( start /i cmd /c call "%path.jzip.launcher%" & goto :EOF
)

:: 快速刷新 
for %%i in (8 9 s1 s2) do if "%key%"=="%%i" goto :Fast1
if not defined key call :全不选 & goto :Fast1

for %%i in (7 s1) do if "%key%"=="%%i" goto :Fast2

:: Arc.Do 结束 
set Arc.Do=
goto :Menu


:分析一行内容 
for /f "skip=%1 delims=" %%a in (%lz.txt%) do (
	set "lz.LineFile.%1= %%a"
	call set "lz.LineView.%1=%%lz.LineFile.%1!:%lz.Dir%\=%%"
	if "!lz.LineFile.%1:~%2,1!"=="D" set "lz.LineView.%1=!lz.LineView.%1:~0,%3!  <!lz.LineView.%1:~%4!>"
	if defined lz.FileSel.%1 (
		set "lz.LineView.%1=!lz.LineView.%1:~0,%3!  %txt_sym.squ.s% !lz.LineView.%1:~%4!"
	) else (
		set "lz.LineView.%1=!lz.LineView.%1:~0,%3!  %txt_sym.squ% !lz.LineView.%1:~%4!"
	)
	goto :EOF
)
goto :EOF


:进入 
if "%~1"=="" (
	%InputBox-r% lz.Dir "\%lz.Dir%" "%txt_e.type.enterfold%"
) else if "%~1"==".." (
	for /f "delims=" %%i in ("!lz.Dir!") do (
		set "lz.Dir=%%~i"
		if not "%%~nxi"=="" (
			set "lz.Dir=!lz.Dir:%%~nxi=!"
		)
	)
) else if not "%~1"=="" (
	set "lz.Dir=%~1"
	)

if not defined lz.Dir goto :EOF

:enter.loop
if "!lz.Dir:~0,1!"=="\" set "lz.Dir=!lz.Dir:~1!" & goto :enter.loop
if "!lz.Dir:~-1!"=="\" set "lz.Dir=!lz.Dir:~0,-1!" & goto :enter.loop

set "lz.LineViewStart="
call :全不选 
goto :EOF


:全选切换 
if "%lz.FileSel%"=="%lz.FileTotal%" ( call :全不选 ) else ( call :全选 )
goto :EOF

:全选 
for /l %%a in (%lz.LineFileStart%,1,%lz.LineFileEnd%) do set "lz.FileSel.%%a=%%a"
set "lz.FileSel=%lz.FileTotal%"
goto :EOF

:全不选 
for /f "tokens=1 delims==" %%a in ('2^>nul set "lz.FileSel."') do set "%%a="
set "lz.FileSel=0"
goto :EOF



