
::��ʼ�����趨 
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

:: UTF-8 ����ҳ��� 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
	for %%z in (
		65001}rar}-scf
		65001}7z}-sccutf-8
	) do for /f "tokens=1-3 delims=}" %%a in ("%%z") do (
		if "%%i"==" %%a" if "%type.editor%"=="%%b" set "btn.utf8=%%c"
	)
)

:: ѹ���ļ������Լ�� 
for %%a in (rar 7z cab) do if "%type.editor%"=="%%a" >nul "!path.editor.%%a!" l "%path.Archive%" %iferror%

:Menu

:: ����ѹ��������������ѹ���ļ���Ŀ¼ʱ  
if not defined listzip.Dir (
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

:: ����ѹ�����ļ��б� 
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

:: �����ļ��б����� 
set listzip.LineFileStart=1
for /f "tokens=3 delims=:" %%i in ('find /v /c "" "%listzip.txt%"') do (
	if %%i LSS 1 ( set "listzip.LineFileEnd=1" ) else ( set /a "listzip.LineFileEnd=%%i-1" )
)

:Menu-fast

:: ��̬�������ڴ�С������ʱ��ע���Խ��� 
for /f "tokens=1-2" %%a in ('mode') do (
	if /i "%%a"=="��:��" set Window.Lines=%%~b
	if /i "%%a"=="Lines:" set Window.Lines=%%~b
	if /i "%%a"=="��:����" set /a Window.Columns=%%~b-1
	if /i "%%a"=="Columns:" set /a Window.Columns=%%~b-1
)
set /a "listzip.LineViewBlock=Window.Lines-5"

::�趨��ʾ�������� 
if not defined listzip.LineViewStart set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% LSS %listzip.LineFileStart% set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% GTR %listzip.LineViewBlock% (
	if %listzip.LineViewStart% GTR %listzip.LineFileEnd% set /a "listzip.LineViewStart-=listzip.LineViewBlock"
)

::�趨��ʾ��ĩ���� 
set /a "listzip.LineViewEnd=listzip.LineViewStart+listzip.LineViewBlock-1"
if %listzip.LineViewEnd% GTR %listzip.LineFileEnd% set /a "listzip.LineViewEnd=listzip.LineFileEnd"

::�����ļ���������ʾҳ�� 
set /a "listzip.LineFileTotal=listzip.LineFileEnd-listzip.LineFileStart+1"
set /a "listzip.ViewPageNow=((listzip.LineViewStart-listzip.LineFileStart)/listzip.LineViewBlock)+1"
set /a "listzip.ViewPageTotal=(listzip.LineFileTotal-1)/listzip.LineViewBlock+1"

:: ��ȡ�ı������������� 	
if "%type.editor%"=="7z" (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :����һ������ %%a 20 51 53
)
if "%type.editor%"=="rar" (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :����һ������ %%a 7 39 41
)

::UI--------------------------------------------------

cls

::��ʾѹ��������ѡ�� 

<nul set /p ="  %txt_e.home%  |  "

if "%listzip.Menu%"=="basic" (
	<nul set /p =" %txt_e.open% %txt_e.extr% %txt_e.unzip% "
	if defined ui.Archive.writeable (
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

for %%i in (7z rar) do if "%type.editor%"=="%%i" (
	if defined listzip.LineFileSel ( echo=!txt_e.bar.%%i:%txt_sym.squ%=%txt_sym.squ.s%! ) else (echo=!txt_e.bar.%%i! )
)

:: ��ȡ�������ݲ��������Ļ 
for %%a in (%Window.Columns%) do (
	for /l %%i in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		echo,!listzip.LineView.%%i:~0,%%a!
	)
)

::������� 
set /a "listzip.ViewEchoEnd=listzip.LineViewStart+listzip.LineViewBlock-2"
for /l %%i in (!listzip.LineFileEnd!,1,!listzip.ViewEchoEnd!) do echo,

::����ע�ͣ����� 
::echo, File {%listzip.LineFileStart%:%listzip.LineFileEnd%} View [%listzip.LineViewStart%:%listzip.LineViewEnd%]
::echo,!listzip.Dir!  !listzip.Dir.p!

::�·���ʾ�� 
<nul set /p ="  %listzip.ViewPageNow%/%listzip.ViewPageTotal% %txt_pages%  "
if "%listzip.Dir%"=="" echo,%listzip.LineFileTotal% %txt_items% %listzip.Info%
if not "%listzip.Dir%"=="" echo,%listzip.LineFileTotal% %txt_items%  %listzip.Dir:\= ^> %

::UI--------------------------------------------------
::�����ж� 
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

::ѹ�����ļ��б������ж� 
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
						if defined listzip.LineFileSel.%%i (set "listzip.LineFileSel.%%i=") else (set "listzip.LineFileSel.%%i=%%i")
						set "listzip.LineFileSel="
						goto :Menu-fast
					)
					if %mouse.x% GEQ %%d (
						call :ȫ��ѡ 
						if "!listzip.LineFile.%%i:~%%e,1!"=="D" (
							call :���� "!listzip.LineFile.%%i:~%%b!"
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

::��������������ж� 
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

if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Extr
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Unzip
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Add
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Expan.cmd" ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance" & goto :Menu-fast
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%" & goto :Menu
) else if "%key%"=="10" ( call :���� 
) else if "%key%"=="11" ( call :����  ..
) else if "%key%"=="a1" ( set "listzip.Menu=basic" & goto :Menu-fast
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd"
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :ȫѡ�л� & goto :Menu-fast
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :ȫѡ�л� & goto :Menu-fast
) else if "%key%"=="e" ( start /i cmd /c call "%path.jzip.launcher%" & goto :EOF
)
call :ȫ��ѡ 
goto :Menu


:����һ������ 
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


:���� 
if "%~1"=="" (
	%InputBox% listzip.Dir "%txt_e.type.enterfold%"
	if not defined listzip.Dir goto :EOF
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


:ȫѡ�л� 
if defined listzip.LineFileSel ( call :ȫ��ѡ ) else ( call :ȫѡ )
goto :EOF

:ȫѡ 
for /l %%a in (%listzip.LineFileStart%,1,%listzip.LineFileEnd%) do set "listzip.LineFileSel.%%a=%%a"
set "listzip.LineFileSel=all"
goto :EOF

:ȫ��ѡ 
for /f "tokens=1 delims==" %%a in ('2^>nul set "listzip.LineFileSel."') do set "%%a="
set "listzip.LineFileSel="
goto :EOF



