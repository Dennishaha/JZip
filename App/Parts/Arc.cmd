
:: ��ʼ�����趨 
@echo off
color %Color%
title %Arc.path% %title%

set /a Window.Col=115, Window.Ln=35
mode %Window.Col%, %Window.Ln%
for %%a in (%jzip.spt.write%) do if /i "%Arc.exten%"==".%%a" set "Arc.Writable=y"

:: ��ע����ȡ GUID ���� 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" 2^>nul') do (
	if /i "%%b"=="REG_SZ" set "%%a=%%c" & set "%%a=!%%a:~0,-1!"
)
reg delete "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" /f >nul 2>nul

:: �����趨 
set "lz.txt=%dir.jzip.temp%\%Arc.Guid%.tmp"
md "%lz.txt%" >nul
if not defined lz.Menu set lz.Menu=basic
if not defined lz.FileSel set lz.FileSel=0

:: �趨���뿪�� 
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

:: �趨 Tcol ��ɫ 
for %%z in (
	"tcol.f":"0,1","tcol.b":"1,1"
) do for /f "tokens=1-2 delims=:" %%a in ("%%z") do (
	set "%%~a=!color:~%%~b!"
	for %%i in ("a=10","b=11","c=12","d=13","e=14","f=15") do (
		set "%%~a=!%%~a:%%~i!"
	)
)

:Menu

:: �б�������ļ�
for %%i in (rar 7z) do if "%type.editor%"=="%%i" >"%lz.txt%\lz" "!path.editor.%%i!" l %btn.utf.a% "%Arc.path%" %if.error%

:: ����ѹ��������������ѹ���ļ���Ŀ¼ʱ  
if not defined lz.Dir (
	set "lz.Info="
	if "%type.editor%"=="rar" (
		for /f "tokens=2* delims=:" %%i in ('type "%lz.txt%\lz" ^| findstr /r "^Details:"') do (

			:: ����ѹ���ļ��ж�
			echo."%%i" | find /i "lock" >nul && set Arc.Writable=

			set "lz.Info=%%i"
			set "lz.Info=!lz.Info:solid=%txt_solid%!"
			set "lz.Info=!lz.Info:SFX=%txt_sfx%!"
			set "lz.Info=!lz.Info:lock=%txt_lock%!"
		)
	)
	if "%type.editor%"=="7z" (
		for /f "tokens=1-2* delims==" %%i in ('type "%lz.txt%\lz" ^| findstr /r "^Type ^Offset ^Method ^Solid "') do (
			if "%%i"=="Type " set "lz.Info=!lz.Info!%%j"
			if "%%i"=="Offset " set "lz.Info=!lz.Info!, %txt_sfx%"
			if "%%i"=="Method " set "lz.Info=!lz.Info!,%%j"
			if "%%i"=="Solid " if "%%j"==" +" set "lz.Info=!lz.Info!, %txt_solid%"
		)
	)
)

:: ����ѹ�����ļ��б� 
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
	if "%type.editor%"=="%%a" >"%lz.txt%\lzs" (
		echo;.
		if defined lz.Dir (
			type "%lz.txt%\lz" | find /i " %lz.Dir%\" | findstr /i /v "\<%lz.Dir.p%\\.*\\.*" | findstr /r /i /c:"%%~b"
			type "%lz.txt%\lz" | find /i " %lz.Dir%\" | findstr /i /v "\<%lz.Dir.p%\\.*\\.*" | findstr /r /i /c:"%%~c"
		) else (
			type "%lz.txt%\lz" | findstr /v "\\" | findstr /r /i /c:"%%~b"
			type "%lz.txt%\lz" | findstr /v "\\" | findstr /r /i /c:"%%~c"
		)
	)
)

:: �����ļ��б����� 
set lz.LnRawStart=1
for /f "tokens=3 delims=:" %%i in ('find /v /c "" "%lz.txt%\lzs"') do (
	if %%i LSS 1 ( set "lz.LnRawEnd=1" ) else ( set /a "lz.LnRawEnd=%%i-1" )
)

:Fast1 

::�趨�ļ��б����� 
set /a "lz.LnViewBlock=Window.Ln-6"

::�趨��ʾ�������� 
if not defined lz.LnViewStart set /a "lz.LnViewStart=lz.LnRawStart"
if %lz.LnViewStart% LSS %lz.LnRawStart% set /a "lz.LnViewStart=lz.LnRawStart"
if %lz.LnViewStart% GTR %lz.LnViewBlock% (
	if %lz.LnViewStart% GTR %lz.LnRawEnd% set /a "lz.LnViewStart-=lz.LnViewBlock"
)

::�趨��ʾ��ĩ���� 
set /a "lz.LnViewEnd=lz.LnViewStart+lz.LnViewBlock-1"
if %lz.LnViewEnd% GTR %lz.LnRawEnd% set /a "lz.LnViewEnd=lz.LnRawEnd"

::�����ļ���������ʾҳ�� 
set /a "lz.FileTotal=lz.LnRawEnd-lz.LnRawStart+1"
set /a "lz.ViewPageNow=((lz.LnViewStart-lz.LnRawStart)/lz.LnViewBlock)+1"
set /a "lz.ViewPageTotal=(lz.FileTotal-1)/lz.LnViewBlock+1"

:: ��ȡ�ı��б������� 
set lz.LnView.c=%lz.LnViewStart%

for %%z in (
	7z}21}52}54}
	rar}8}40}42}
) do for /f "tokens=1-4 delims=}" %%a in ("%%z") do (
	if "%type.editor%"=="%%a" (

		for /f "skip=%lz.LnViewStart% delims=" %%a in ('type "%lz.txt%\lzs"') do (
			for /f %%i in ("!lz.LnView.c!") do (
				set "lz.LnRaw.%%i= %%a"
				call set "lz.LnView.%%i=%%lz.LnRaw.%%i:%lz.Dir%\=%%"
				if "!lz.LnRaw.%%i:~%%b,1!"=="D" (
					set "lz.LnView.%%i=!lz.LnView.%%i:~0,%%c!  // <!lz.LnView.%%i:~%%d!>"
				) else (
					set "lz.LnView.%%i=!lz.LnView.%%i:~0,%%c!  // !lz.LnView.%%i:~%%d!"
				)
				for /f "skip=1 delims=:" %%k in ('^(echo;"!lz.LnView.%%i!"^&echo;^)^|findstr /o ".*"') do set /a lz.ViewLen.%%i=%%k-5

				if "%%i"=="%lz.LnViewEnd%" goto :r.loop.end
				set /a lz.LnView.c+=1
			)
		)
	)
)
:r.loop.end

:Fast2 

:: ˢ�¸�ѡ���ѡ������ɫ 
setlocal
for /l %%i in (%lz.LnViewStart%,1,%lz.LnViewEnd%) do (
	if defined lz.FileSel.%%%i (
		set /a lz.LnScr.%%i=-lz.LnViewStart+%%i+3
		set "tcol.do=!tcol.do! /line 0 !lz.LnScr.%%i! %Window.Col% %tcol.f% %tcol.b% 0"
		set "lz.LnView.%%i=!lz.LnView.%%i://=%txt_sym.squ.s%!"
	) else (
		set "lz.LnView.%%i=!lz.LnView.%%i://=%txt_sym.squ%!"
	)
)

:: ���õײ��� 
set "bar=   %lz.ViewPageNow%/%lz.ViewPageTotal% %txt_pages%  %lz.FileTotal% %txt_items%"
if %lz.FileSel% GTR 0 set "bar=%bar%  %txt_selected% %lz.FileSel% %txt_item%"
if defined lz.Dir set "bar=%bar%  > %lz.Dir:\= > %"
if not defined lz.Dir set "bar=%bar% %lz.Info%"
for /f "skip=1 delims=:" %%k in ('^(echo;"%bar%"^&echo;^)^|findstr /o ".*"') do set /a bar.Len=%%k-5

::UI--------------------------------------------------

cls

:: ���õ�һ���� 

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
echo;
echo;

:: ����������� 
for %%i in (7z rar) do if "%type.editor%"=="%%i" (
	if %lz.FileTotal% GTR 0 (
		if "%lz.FileSel%"=="%lz.FileTotal%" (
			echo; !txt_e.bar.%%i:%txt_sym.squ%=%txt_sym.squ.s%!
		) else (
			echo; !txt_e.bar.%%i!
		)
	) else (
		echo; !txt_e.bar.%%i!
	)
)

:: �ļ��б��������Ļ 
for /l %%i in (%lz.LnViewStart%,1,%lz.LnViewEnd%) do (
	if !lz.ViewLen.%%i! LEQ %Window.Col% (
		echo;!lz.LnView.%%i!
	) else (
		<nul set /p ="!lz.LnView.%%i!"
		for /l %%z in (%Window.Col%,1,!lz.ViewLen.%%i!) do <nul set /p =""
		for /l %%z in (%Window.Col%,1,!lz.ViewLen.%%i!) do <nul set /p ="  "
		for /l %%z in (%Window.Col%,1,!lz.ViewLen.%%i!) do <nul set /p =""
	)
)

:: Ӧ��ѡ������ɫ 
if defined tcol.do %tcol% %tcol.do%


:: ������� 
set /a "lz.ViewEchoEnd=lz.LnViewStart+lz.LnViewBlock-2"
for /l %%i in (!lz.LnRawEnd!,1,!lz.ViewEchoEnd!) do echo;

:: ����ע�ͣ����� 
::echo; File {%lz.LnRawStart%:%lz.LnRawEnd%} View [%lz.LnViewStart%:%lz.LnViewEnd%]
::echo;!lz.Dir!  !lz.Dir.p!

:: ����ײ��� 
echo;
<nul set /p ="!bar!"
for /l %%z in (%Window.Col%,1,!bar.Len!) do <nul set /p =""
for /l %%z in (%Window.Col%,1,!bar.Len!) do <nul set /p ="  "
for /l %%z in (%Window.Col%,1,!bar.Len!) do <nul set /p =""

endlocal

::UI--------------------------------------------------

:: Arc.Do ��Ϊ�ж� 
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

:: �����ж� 
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

:: ���ڴ�С������⣬����ʱ��ע���Խ��� 
for /f "tokens=1-2" %%a in ('mode') do (
	if /i "%%a"=="��:��" if !Window.Ln! NEQ %%~b (set "Window.Ln=%%~b" & set "key=rf")
	if /i "%%a"=="Lines:" if !Window.Ln! NEQ %%~b (set "Window.Ln=%%~b" & set "key=rf")
	if /i "%%a"=="��:����" if !Window.Col! NEQ %%~b (set "Window.Col=%%~b" & set "key=rf")
	if /i "%%a"=="Columns:" if !Window.Col! NEQ %%~b (set "Window.Col=%%~b" & set "key=rf")
)
if "%key%"=="rf" goto :Menu

:: ѹ���б������ж� 
set /a lz.LnTap=lz.LnViewStart+mouse.y-3
if %lz.LnTap% GTR %lz.LnViewEnd% call :ȫ��ѡ 

if %lz.LnViewStart% LEQ %lz.LnTap% if %lz.LnTap% LEQ %lz.LnViewEnd% (
	for /f %%i in ("%lz.LnTap%") do (
		if defined lz.LnView.%%%i (
			for %%z in (
				7z:21:54:56
				rar:8:42:44
			) do for /f "tokens=1-4 delims=:" %%a in ("%%z") do (
				if "%type.editor%"=="%%a" (
					if %mouse.x% LSS %%c call :ȫ��ѡ 
					if %mouse.x% GEQ %%d call :ȫ��ѡ 

					if defined lz.FileSel.%%%i (
						set "lz.FileSel.%%i="
						set /a "lz.FileSel-=1"
					) else (
						set "lz.FileSel.%%i=%%i"
						set /a "lz.FileSel+=1"
					)

					if %%d LSS %mouse.x% if %mouse.x% LSS !lz.ViewLen.%%i! ( 
						if "!lz.LnRaw.%%i:~%%b,1!"=="D" (
							call :����  "!lz.LnRaw.%%i:~%%c!"
							goto :Menu
						) else (
							call "%dir.jzip%\Parts\Arc_Expan.cmd" Open
						)
					)
					goto :Fast2
				)
			)
		)
	)
)

:: ��ť�����ж� 
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
) else if "%key%"=="8" ( set /a "lz.LnViewStart-=%lz.LnViewBlock%"
) else if "%key%"=="9" ( set /a "lz.LnViewStart+=%lz.LnViewBlock%"
) else if "%key%"=="10" ( call :���� 
) else if "%key%"=="11" ( call :����  ..
) else if "%key%"=="a1" ( set "lz.Menu=basic"
) else if "%key%"=="a2" ( call "%dir.jzip%\Parts\Arc_Expan.cmd" Check
) else if "%key%"=="a3" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Repair
) else if "%key%"=="a4" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Lock
) else if "%key%"=="a5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Note
) else if "%key%"=="a6" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Expan.cmd" Sfx
) else if "%key%"=="s1" ( if "%type.editor%"=="rar" call :ȫѡ�л� 
) else if "%key%"=="s2" ( if "%type.editor%"=="7z" call :ȫѡ�л� 
) else if "%key%"=="e" ( start /b /i cmd /c call "%path.jzip.launcher%" & goto :EOF
)

:: Arc.Do ���� 
set Arc.Do=

:: ����ˢ�� 
for %%i in (8 9) do if "%key%"=="%%i" goto :Fast1
if not defined key goto :Fast2
for %%i in (7 a1 s1 s2) do if "%key%"=="%%i" goto :Fast2

goto :Menu


:���� 
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

if "!lz.Dir:~0,1!"=="\" set "lz.Dir=!lz.Dir:~1!"
if "!lz.Dir:~-1!"=="\" set "lz.Dir=!lz.Dir:~0,-1!"

set "lz.LnViewStart="
call :ȫ��ѡ 
goto :EOF


:ȫѡ�л� 
if "%lz.FileSel%"=="%lz.FileTotal%" ( call :ȫ��ѡ ) else ( call :ȫѡ )
goto :EOF

:ȫѡ 
for /l %%a in (%lz.LnRawStart%,1,%lz.LnRawEnd%) do set "lz.FileSel.%%a=%%a"
set "lz.FileSel=%lz.FileTotal%"
goto :EOF

:ȫ��ѡ 
for /f "tokens=1 delims==" %%a in ('2^>nul set "lz.FileSel."') do set "%%a="
set "lz.FileSel=0"
goto :EOF



