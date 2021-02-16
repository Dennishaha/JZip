
@echo off
setlocal EnableDelayedExpansion EnableDelayedExpansion
color %Color%
title %Arc.path% %title%

:: �����ж� 
if not defined Arc.Order goto :EOF

:: Ԥ���ñ��� 
set Add-Solid=y

:: ��ע����ȡ ѹ��/GUID ���� 
if /i "%Arc.Order%"=="add" (
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Recent" 2^>nul') do (
		if /i "%%b"=="REG_SZ" set "%%a=%%c"
	)
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip\Recent\@\%Arc.Guid%" 2^>nul') do (
		if /i "%%b"=="REG_SZ" set "%%a=%%c" & set "%%a=!%%a:~0,-1!"
	)
	reg delete "HKCU\Software\JFsoft.Jzip\Recent\@\%Arc.Guid%" /f >nul 2>nul && set "Arc.Do=go"
)

echo;"%jzip.spt.add%" | find "%Arc.exten:~1%" >nul || set "Arc.exten=.7z"

:AddSet 

:: �Խ�ѹ��չ���ж� 
if defined �Խ�ѹ ( set "Arc.exten.out=.exe" ) else ( set "Arc.exten.out=%Arc.exten%" )

:: ѹ����������ļ������ظ��ж� 
if "%path.raw.1%"=="%Arc.dir%\%Arc.name%%Arc.exten.out%" set "Arc.name=%Arc.name% (1)"

set "Arc.neo=%Arc.name%%Arc.exten.out%"
if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
	set "Arc.neo=%Arc.name%.tar%Arc.exten.out%"
)

title %txt_aa.addto% %Arc.dir%\%Arc.neo% %title%

:: ����ִ������ת��ִ�� 
if /i "%Arc.Order%"=="add-7z" goto :Add-Process
if defined Arc.Do goto :Add-Process

(%echocut% "!Arc.neo!" ui.Arc.neo 48) >nul 2>nul

:AddSet-Fast 
::UI--------------------------------------------------

cls
echo;
echo;   %txt_aa.addtozip%
echo;
echo;                                                       [ %txt_aa.setpath% ] [ %txt_aa.scan% ]
echo;
echo;	%txt_aa.zipname%	%ui.Arc.neo%
echo;
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
	echo;"7z rar" | find "%Arc.exten:~1%" >nul && (
		if "%Add-Solid%"=="y" echo;	%txt_aa.solid%		%txt_sym.cir.s%
		if not "%Add-Solid%"=="y" echo;	%txt_aa.solid%		%txt_sym.cir%
	) || echo;
) else echo;

if /i "%Arc.Order%"=="add" (
	echo;"rar 7z zip tar bz2 gz xz wim" | find "%Arc.exten:~1%" >nul && (
		if not defined �־�ѹ�� echo;	%txt_aa.split%		%txt_sym.cir%
		if defined �־�ѹ�� echo;	%txt_aa.split%		%txt_sym.cir.s% !�־�ѹ��!
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
			if "!�Խ�ѹ!"=="%%~a" echo;	%txt_aa.sfxmode%		%%~b
		)
	) || echo;
) else echo;

echo;
echo;"rar 7z zip" | find "%Arc.exten:~1%" >nul && (
	for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%a" (
		if not defined ѹ������ echo;	%txt_aa.encry%		%txt_sym.cir%
		if defined ѹ������ echo;	%txt_aa.encry%		%txt_sym.cir.s% %ѹ������%
	)
) || echo;

echo;
if /i "%Arc.Order%"=="add" (
	if /i "%Arc.exten%"==".rar" (
		if not defined ѹ���汾.rar set "ѹ���汾.rar=5"
		for %%A in (
			4/^!txt_sym.cir.s^!,5/^!txt_sym.cir^!
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "!ѹ���汾.rar!"=="%%~a" echo;	%txt_aa.compati%		%%~b
		)
		for %%A in (
			""/^!txt_sym.cir^!,3/"^!txt_sym.cir.s^! 3%%",6/"^!txt_sym.cir.s^! 6%%",9/"^!txt_sym.cir.s^! 9%%"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "!ѹ���ָ���¼!"=="%%~a" echo;	%txt_aa.record%		%%~b
		)
	) else (echo; & echo;)
)
echo;
echo;
echo;
%echo%;						%txt_b7.top%%txt_b7.top%
%echo%;						%txt_b7.confirm%%txt_b7.cancel%
%echo%;						%txt_b7.bot%%txt_b7.bot%

::UI--------------------------------------------------
::�����ж� 
%tcurs% /crv 0
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	24}27}8}8}.7z}
	28}32}8}8}.rar}
	33}37}8}8}.zip}
	38}42}8}8}.tar}
	43}47}8}8}.bz2}
	48}51}8}8}.gz}
	52}55}8}8}.xz}
	56}60}8}8}.wim}
	61}65}8}8}.cab}

	55}66}3}3}a}
	68}75}3}3}b}
	14}71}5}6}c}

	28}48}10}10}d0}
	32}33}10}10}d1}
	34}35}10}10}d2}
	36}37}10}10}d3}
	38}39}10}10}d4}
	40}41}10}10}d5}

	32}33}11}11}e}
	32}33}12}12}f}
	34}50}12}12}fs}
	32}33}14}14}g}
	34}50}14}14}gs}
	32}33}16}16}h}
	34}50}16}16}hs}
	32}33}18}18}i}
	32}33}19}19}j}
	34}40}19}19}js}

	49}60}22}24}next}
	63}74}22}24}back}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

if not defined key goto :AddSet-Fast

if /i "%Arc.Order%"=="add" (
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if /i "%key%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :ѹ����ʽ�л� %%a
	)
)

if "%key%"=="a" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Part\Arc_Set.cmd" :����·��
) else if "%key%"=="b" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Part\Arc_Set.cmd" :���
) else if "%key%"=="c" ( if /i "%Arc.Order%"=="add" call "%dir.jzip%\Part\Arc_Set.cmd" :��������
) else if "%key:~0,1%"=="d" ( for %%a in (rar 7z zip bz2 gz xz cab) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :Level %key:~1%
) else if "%key%"=="e" ( if /i "%Arc.Order%"=="add" for %%a in (7z rar) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :��ʵ�ļ�
) else if "%key:~0,1%"=="f" ( for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :�־�ѹ�� %key:~1%
) else if "%key:~0,1%"=="g" ( if /i "%Arc.Order%"=="add" for %%a in (rar 7z) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :�Խ�ѹ  %key:~1%
) else if "%key:~0,1%"=="h" ( for %%a in (rar 7z zip) do if /i "%Arc.exten%"==".%%a" call "%dir.jzip%\Part\Arc_Set.cmd" :ѹ������ %key:~1%
) else if "%key%"=="i" ( if /i "%Arc.Order%"=="add" if /i "%Arc.exten%"==".rar" call "%dir.jzip%\Part\Arc_Set.cmd" :ѹ���汾.rar
) else if "%key:~0,1%"=="j" ( if /i "%Arc.Order%"=="add" if /i "%Arc.exten%"==".rar" call "%dir.jzip%\Part\Arc_Set.cmd" :ѹ���ָ���¼ %key:~1%
) else if "%key%"=="next"  ( goto :Add-Process
) else if "%key%"=="back" ( set "path.File=" & goto :EOF
)

:: ����ˢ�� 
for %%i in (d e f h i j) do if "%key:~0,1%"=="%%i" goto :AddSet-Fast
goto :AddSet


:Add-Process
cls

:: �½�ѹ��ʱ 
if /i not "%Arc.Order%"=="list" (

	:: ���ñ༭�� 
	for %%i in (7z zip tar bz2 gz xz wim) do if /i "%Arc.exten%"==".%%i" set "type.editor=7z"
	if /i "%Arc.exten%"==".rar" set "type.editor=rar"
	if /i "%Arc.exten%"==".cab" set "type.editor=cab"

	:: ����ѹ��·�� 
	set "Arc.path=%Arc.dir%\%Arc.name%%Arc.exten.out%"
)

:: ����ѹ�����õ�ע��� 
if /i "%Arc.Order%"=="add" (
	for %%a in (Arc.exten Add-Level Add-Solid) do (
		reg add "HKCU\Software\JFsoft.Jzip\Recent" /t REG_SZ /v "%%a" /d "!%%a!" /f >nul %iferror%
	)
)

:: �жϴ����ļ��Ƿ������ԱȨ�� 
net session >nul 2>nul || >nul 2>nul (
	>"%Arc.dir%\%Arc.Guid%.tmp" echo; && (
		del /q "%Arc.dir%\%Arc.Guid%.tmp"
	) || (
		:: ���� GUID ���õ�ע��� 
		if /i "%Arc.Order%"=="add" (
			for %%a in ( ѹ������ �־�ѹ�� ѹ���汾.rar ѹ���ָ���¼ �Խ�ѹ Arc.dir Arc.name ) do (
				reg add "HKCU\Software\JFsoft.Jzip\Recent\@\%Arc.Guid%" /t REG_SZ /v "%%a" /d "!%%a!;" /f >nul %iferror%
			)
		)
		%sudo% "%path.jzip.launcher%" %Arc.Order% %path.File% //%Arc.Guid%
		if "!sudoback!"=="1" (
			set "Arc.Order=add"
			goto :AddSet
		) else (exit)
	)
)

:: ����ѹ��Ч�� 
if defined Add-Level (
	for %%A in (
		0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21
	) do (
		for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
		if "%type.editor%"=="rar" if "%Add-Level%"=="%%a" set "btn.ѹ������=-m%%b"
		if "%type.editor%"=="7z" if "%Add-Level%"=="%%a" set "btn.ѹ������=-mx=%%c"
		if "%type.editor%"=="cab" if "%Add-Level%"=="%%a" set "btn.ѹ������=-m %%d"
	)
)

:: ���ù�ʵѹ�� 
for %%A in (
	7z/.7z/y/-ms=on
	7z/.7z/""/-ms=off
	7z/.xz/y/-ms=on
	7z/.xz/""/-ms=off
	rar/.rar/y/-s
	rar/.rar/""/""
) do (
	for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
		if "%type.editor%"=="%%a" (
			if "%Arc.exten%"=="%%b" (
				if /i "%Add-Solid%"=="%%~c" (
					set "btn.��ʵ�ļ�=%%~d"
				)
			)
		)
	)				
)

if defined ѹ������ set "btn.ѹ������=-p!ѹ������!"
if defined �־�ѹ�� set "btn.�־�ѹ��= -v!�־�ѹ��!"
if defined ѹ���汾.rar set "btn.ѹ���汾.rar=-ma!ѹ���汾.rar!"
if defined ѹ���ָ���¼ set "btn.ѹ���ָ���¼=-rr!ѹ���ָ���¼!"
if defined �Խ�ѹ (
	for %%A in (
		a32/Default/7z
		a64/Default64/""
		b32/WinCon/7zCon
		b64/WinCon64/""
	) do for /f "tokens=1-3 delims=/" %%a in ("%%A") do (
		if "%Arc.exten%"==".rar" if "!�Խ�ѹ!"=="%%a" set btn.�Խ�ѹ=-sfx"%dir.jzip%\Bin\Sfx\%%b.sfx"
		if "%Arc.exten%"==".7z" if "!�Խ�ѹ!"=="%%a" set btn.�Խ�ѹ=-sfx"%dir.jzip%\Bin\Sfx\%%c.sfx"
		)
	)
)

:: RAR 
if "%type.editor%"=="rar" "%path.editor.rar%" a !btn.ѹ������! !btn.ѹ������! !btn.��ʵ�ļ�! !btn.�־�ѹ��! !btn.ѹ���汾.rar! -ep1 !btn.ѹ���ָ���¼! !btn.�Խ�ѹ! -w"%dir.jzip.temp%" "%Arc.path%" %path.File% %iferror%

:: 7Z 
if "%type.editor%"=="7z" (
	if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
		"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar" %path.File% %iferror%
		cls
		set "Arc.path=%Arc.dir%\%Arc.name%.tar%Arc.exten%"
		set "path.File=%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar"
	)
)

if "%type.editor%"=="7z" "%path.editor.7z%" a !btn.ѹ������! !btn.ѹ������! !btn.��ʵ�ļ�! !btn.�־�ѹ��! -w"%dir.jzip.temp%" !btn.�Խ�ѹ! "%Arc.path%" %path.File% %iferror%

if "%type.editor%"=="7z" (
	if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Arc.exten%"==".%%a" (
		del /q /f /s "%dir.jzip.temp%\%Arc.Guid%\%Arc.name%.tar" >nul
	)
)

:: CAB 
if "%type.editor%"=="cab" "%path.editor.cab%" -r !btn.ѹ������! n "%Arc.path%" %path.File% %iferror%

set "path.File="

:: ��ӵ���ʷ��¼ 
call "%dir.jzip%\Part\Main.cmd" :History-add "%Arc.path%"
 
goto :EOF

