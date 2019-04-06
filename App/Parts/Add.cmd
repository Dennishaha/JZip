
:: µ÷ÓÃÅÐ¶Ï 
if not defined Arc.Order goto :EOF

:: ´Ó×¢²á±í¶ÁÈ¡ Ñ¹Ëõ/GUID ÅäÖÃ 
if /i "%Arc.Order%"=="add" (
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record" 2^>nul') do (
		if /i "%%b"=="REG_SZ" set "%%a=%%c"
	)
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" 2^>nul') do (
		if /i "%%b"=="REG_SZ" set "%%a=%%c" & set "%%a=!%%a:~0,-1!"
	)
	reg delete "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" /f >nul 2>nul && set "Arc.Do=go"
)

echo;"%jzip.spt.add%" | find "%Arc.exten:~1%" >nul || set "Arc.exten=.7z"

:Archive_Setting

:: ×Ô½âÑ¹À©Õ¹ÃûÅÐ¶Ï 
if defined ×Ô½âÑ¹ ( set "Arc.exten.out=.exe" ) else ( set "Arc.exten.out=%Arc.exten%" )

:: Ñ¹ËõµµÓëÌí¼ÓÎÄ¼þÃû³ÆÖØ¸´ÅÐ¶Ï 
if "%path.raw.1%"=="%Arc.dir%\%Arc.name%%Arc.exten.out%" set "Arc.name=%Arc.name% (1)"

set "Arc.neo=%Arc.name%%Arc.exten.out%"
if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
	set "Arc.neo=%Arc.name%.tar%Arc.exten.out%"
)

title %txt_aa.addto% %Arc.dir%\%Arc.neo% %title%

:: Âú×ãÖ´ÐÐÌõ¼þ×ªµ½Ö´ÐÐ 
if /i "%Arc.Order%"=="add-7z" goto :Add_Process
if defined Arc.Do goto :Add_Process

::UI--------------------------------------------------

cls
echo;
echo;   %txt_aa.addtozip%
echo;                                                       [ %txt_aa.setpath% ] [ %txt_aa.scan% ]
echo;
echo;	%txt_aa.zipname%	%Arc.neo:~0,40%
echo;			%Arc.neo:~40,80%
echo;
if /i "%Arc.Order%"=="add" (
	set "ui.Arc.exten= 7z  rar  zip  tar  bz2  gz  xz  wim  cab "
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if "%Arc.exten%"==".%%a" echo;	%txt_aa.type%	!ui.Arc.exten: %%a =[%%a]!
	)
) else echo;
echo;

if not defined Add-Level set "Add-Level=3"
for %%A in (
	0/"^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	1/"^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	2/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	3/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!"
	4/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!"	
	5/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!"
) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%%~a"=="!Add-Level!" for %%i in (rar 7z zip bz2 gz xz cab) do if "%Arc.exten%"==".%%i" (
		echo;	%txt_aa.eff%		%%~b !txt_aa.eff.%%~a!
	)
	if "%%~a"=="0" for %%i in (tar wim) do if "%Arc.exten%"==".%%i" (
		echo;	%txt_aa.eff%		%%~b !txt_aa.eff.%%~a!
	)
)

if /i "%Arc.Order%"=="add" (
	echo;"rar 7z xz" | find "%Arc.exten:~1%" >nul && (
		if "%Add-Solid%"=="y" echo;	%txt_aa.solid%		%txt_sym.cir.s%
		if not "%Add-Solid%"=="y" echo;	%txt_aa.solid%		%txt_sym.cir%
	) || echo;
) else echo;

if /i "%Arc.Order%"=="add" (
	echo;"rar 7z zip tar bz2 gz xz wim" | find "%Arc.exten:~1%" >nul && (
		if not defined ·Ö¾íÑ¹Ëõ echo;	%txt_aa.split%		%txt_sym.cir%
		if defined ·Ö¾íÑ¹Ëõ echo;	%txt_aa.split%		%txt_sym.cir.s% %·Ö¾íÑ¹Ëõ%
	) || echo;
) else echo;

echo;
if /i "%Arc.Order%"=="add" (
	echo;"rar 7z" | find "%Arc.exten:~1%" >nul && (
		for %%A in (
			""/^!txt_sym.cir^!
			y/"^!txt_sym.cir.s^! %txt_aa.sfx.origin%"
			a32/"^!txt_sym.cir.s^! %txt_aa.sfx.a%"
			a64/"^!txt_sym.cir.s^! %txt_aa.sfx.a%%txt_aa.sfx.64%"
			b32/"^!txt_sym.cir.s^! %txt_aa.sfx.b%"
			b64/"^!txt_sym.cir.s^! %txt_aa.sfx.b%%txt_aa.sfx.64%"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%×Ô½âÑ¹%"=="%%~a" echo;	%txt_aa.sfxmode%		%%~b
		)
	) || echo;
) else echo;

echo;
echo;"rar 7z zip" | find "%Arc.exten:~1%" >nul && (
	for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%a" (
		if not defined Ñ¹ËõÃÜÂë echo;	%txt_aa.encry%		%txt_sym.cir%
		if defined Ñ¹ËõÃÜÂë echo;	%txt_aa.encry%		%txt_sym.cir.s% %Ñ¹ËõÃÜÂë%
	)
) || echo;

echo;
if /i "%Arc.Order%"=="add" (
	if /i "%Arc.exten%"==".rar" (
		if not defined Ñ¹Ëõ°æ±¾.rar set "Ñ¹Ëõ°æ±¾.rar=5"
		for %%A in (
			4/^!txt_sym.cir.s^!,5/^!txt_sym.cir^!
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "!Ñ¹Ëõ°æ±¾.rar!"=="%%~a" echo;	%txt_aa.compati%		%%~b
		)
		for %%A in (
			""/^!txt_sym.cir^!,3/"^!txt_sym.cir.s^! 3%%",6/"^!txt_sym.cir.s^! 6%%",9/"^!txt_sym.cir.s^! 9%%"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%Ñ¹Ëõ»Ö¸´¼ÇÂ¼%"=="%%~a" echo;	%txt_aa.record%		%%~b
		)
	) else (echo; & echo;)
)
echo;
echo;
%echo%;						%txt_b7.top%%txt_b7.top%
%echo%;						%txt_b7.confirm%%txt_b7.cancel%
%echo%;						%txt_b7.bot%%txt_b7.bot%

::UI--------------------------------------------------
::×ø±êÅÐ¶Ï 
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	24}27}7}7}7z}
	28}32}7}7}rar}
	33}37}7}7}zip}
	38}42}7}7}tar}
	43}47}7}7}bz2}
	48}51}7}7}gz}
	52}55}7}7}xz}
	56}60}7}7}wim}
	61}65}7}7}cab}

	55}66}2}2}a}
	68}75}2}2}b}
	14}71}4}5}c}

	28}48}9}9}d0}
	32}33}9}9}d1}
	34}35}9}9}d2}
	36}37}9}9}d3}
	38}39}9}9}d4}
	40}41}9}9}d5}

	32}33}10}10}e}
	32}33}11}11}f}
	34}50}11}11}fs}
	32}33}13}13}g}
	34}50}13}13}gs}
	32}33}15}15}h}
	34}50}15}15}hs}
	32}33}17}17}i}
	32}33}18}18}j}
	34}40}18}18}js}

	49}60}21}23}next}
	63}74}21}23}back}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

if not defined key goto :Archive_Setting

if /i "%Arc.Order%"=="add" (
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if /i "%key%"=="%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :Ñ¹Ëõ¸ñÊ½ÇÐ»» %%a
	)
)

if "%key%"=="a" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Parts\Arc_Set.cmd" :¸ü¸ÄÂ·¾¶
) else if "%key%"=="b" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Parts\Arc_Set.cmd" :ä¯ÀÀ
) else if "%key%"=="c" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Parts\Arc_Set.cmd" :¸ü¸ÄÃû³Æ
) else if "%key:~0,1%"=="d" ( for %%a in (rar 7z zip bz2 gz xz cab) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :Level %key:~1%
) else if "%key%"=="e" ( if /i "%Arc.Order%"=="add" for %%a in (rar 7z xz) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :¹ÌÊµÎÄ¼þ
) else if "%key:~0,1%"=="f" ( for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :·Ö¾íÑ¹Ëõ %key:~1%
) else if "%key:~0,1%"=="g" ( if /i "%Arc.Order%"=="add" for %%a in (rar 7z) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :×Ô½âÑ¹  %key:~1%
) else if "%key:~0,1%"=="h" ( for %%a in (rar 7z zip) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Set.cmd" :Ñ¹Ëõ¼ÓÃÜ %key:~1%
) else if "%key%"=="i" ( if /i "%Arc.Order%"=="add" if /i "%Arc.exten%"==".rar" call "%dir.jzip%\Parts\Arc_Set.cmd" :Ñ¹Ëõ°æ±¾.rar
) else if "%key:~0,1%"=="j" ( if /i "%Arc.Order%"=="add" if /i "%Arc.exten%"==".rar" call "%dir.jzip%\Parts\Arc_Set.cmd" :Ñ¹Ëõ»Ö¸´¼ÇÂ¼ %key:~1%
) else if "%key%"=="next"  ( goto :Add_Process
) else if "%key%"=="back" ( set "path.File=" & goto :EOF
)
goto :Archive_Setting


:Add_Process
cls

:: ÐÂ½¨Ñ¹ËõÊ± 
if /i not "%Arc.Order%"=="list" (

	:: ÅäÖÃ±à¼­Æ÷ 
	for %%i in (7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%i" set "type.editor=7z"
	if /i "%Arc.exten%"==".rar" set "type.editor=rar"
	if /i "%Arc.exten%"==".cab" set "type.editor=cab"

	:: ÅäÖÃÑ¹ËõÂ·¾¶ 
	set "Arc.path=%Arc.dir%\%Arc.name%%Arc.exten.out%"
)

:: ±£´æÑ¹ËõÅäÖÃµ½×¢²á±í 
if /i "%Arc.Order%"=="add" (
	for %%a in (Arc.exten Add-Level Add-Solid) do (
		reg add "HKCU\Software\JFsoft.Jzip\Record" /t REG_SZ /v "%%a" /d "!%%a!" /f >nul %iferror%
	)
)

:: ÅÐ¶Ï´´½¨ÎÄ¼þÊÇ·ñÐè¹ÜÀíÔ±È¨ÏÞ 
net session >nul 2>nul || >nul 2>nul (
	>"%Arc.dir%\%Arc.Guid%.tmp" echo; && (
		del /q "%Arc.dir%\%Arc.Guid%.tmp"
	) || (
		:: ±£´æ GUID ÅäÖÃµ½×¢²á±í 
		if /i "%Arc.Order%"=="add" (
			for %%a in ( Ñ¹ËõÃÜÂë ·Ö¾íÑ¹Ëõ Ñ¹Ëõ°æ±¾.rar Ñ¹Ëõ»Ö¸´¼ÇÂ¼ ×Ô½âÑ¹ Arc.dir Arc.name ) do (
				reg add "HKCU\Software\JFsoft.Jzip\Record\@\%Arc.Guid%" /t REG_SZ /v "%%a" /d "!%%a!;" /f >nul %iferror%
			)
		)
		%sudo% "%path.jzip.launcher%" %Arc.Order% %path.File% //%Arc.Guid%
		exit 0
	)
)

::ÅäÖÃÑ¹Ëõ²ÎÊý 
if defined Add-Level (
	for %%A in (
		0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21
	) do (
		for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
		if "%type.editor%"=="rar" if "%Add-Level%"=="%%a" set "btn.Ñ¹Ëõ¼¶±ð=-m%%b"
		if "%type.editor%"=="7z" if "%Add-Level%"=="%%a" set "btn.Ñ¹Ëõ¼¶±ð=-mx=%%c"
		if "%type.editor%"=="cab" if "%Add-Level%"=="%%a" set "btn.Ñ¹Ëõ¼¶±ð=-m %%d"
	)
)
if defined Add-Solid set "btn.¹ÌÊµÎÄ¼þ=-s"
if defined Ñ¹ËõÃÜÂë set "btn.Ñ¹ËõÃÜÂë=-p%Ñ¹ËõÃÜÂë%"
if defined ·Ö¾íÑ¹Ëõ set "btn.·Ö¾íÑ¹Ëõ= -v%·Ö¾íÑ¹Ëõ%"
if defined Ñ¹Ëõ°æ±¾.rar set "btn.Ñ¹Ëõ°æ±¾.rar=-ma%Ñ¹Ëõ°æ±¾.rar%"
if defined Ñ¹Ëõ»Ö¸´¼ÇÂ¼ set "btn.Ñ¹Ëõ»Ö¸´¼ÇÂ¼=-rr%Ñ¹Ëõ»Ö¸´¼ÇÂ¼%"
if defined ×Ô½âÑ¹ (
	for %%A in (
		a32/Default/7z
		a64/Default64/""
		b32/WinCon/7zCon
		b64/WinCon64/""
	) do for /f "tokens=1-3 delims=/" %%a in ("%%A") do (
		if "%Arc.exten%"==".rar" if "%×Ô½âÑ¹%"=="%%a" set btn.×Ô½âÑ¹=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx"
		if "%Arc.exten%"==".7z" if "%×Ô½âÑ¹%"=="%%a" set btn.×Ô½âÑ¹=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx"
		)
	)
)

:: RAR 
if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.Ñ¹ËõÃÜÂë% %btn.Ñ¹Ëõ¼¶±ð% %btn.¹ÌÊµÎÄ¼þ% %btn.·Ö¾íÑ¹Ëõ% %btn.Ñ¹Ëõ°æ±¾.rar% -ep1 %btn.Ñ¹Ëõ»Ö¸´¼ÇÂ¼% %btn.×Ô½âÑ¹% -w"%dir.jzip.temp%" "%Arc.path%" %path.File% %iferror%

:: 7Z 
if "%type.editor%"=="7z" (
	if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
		"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar" %path.File% %iferror%
		set "Arc.path=%Arc.dir%\%Arc.name%.tar%Arc.exten%"
		set "path.File=%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar"
	)
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.Ñ¹ËõÃÜÂë% %btn.Ñ¹Ëõ¼¶±ð% %btn.·Ö¾íÑ¹Ëõ% -w"%dir.jzip.temp%" %btn.×Ô½âÑ¹% "%Arc.path%" %path.File% %iferror%

if "%type.editor%"=="7z" (
	if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
		del /q /f /s "%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar" >nul
	)
)

:: CAB 
if "%type.editor%"=="cab" "%path.editor.cab%" -r %btn.Ñ¹Ëõ¼¶±ð% n "%Arc.path%" %path.File% %iferror%

set "path.File="
goto :EOF

