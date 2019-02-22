
:: �����ж� 
if defined ArchiveOrder call :Archive_Setting
goto :EOF

:Archive_Setting
if defined �Խ�ѹ ( set "Archive.exten.out=.exe" ) else ( set "Archive.exten.out=%Archive.exten%" )

:: ѹ����������ļ������ظ��ж� 
if "%path.raw.1%"=="%Archive.dir%%Archive.name%%Archive.exten.out%" set "Archive.name=%Archive.name% (1)"

set "ui.Archive.ne=%Archive.name%%Archive.exten.out%"
title %txt_aa.addto% %ui.Archive.ne% %title%

::����ѹ��ʱǰ��ѹ��ִ�� 
if "%ArchiveOrder%"=="add-7z" goto :Add_Process

::UI--------------------------------------------------

cls
echo,
echo,   %txt_aa.addtozip%
echo,                                                       [ %txt_aa.setpath% ] [ %txt_aa.scan% ]
echo,
echo,	%txt_aa.zipname%	%ui.Archive.ne:~0,40%
echo,			%ui.Archive.ne:~40,80%
echo,
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten= 7z  rar  zip  tar  bz2  gz  xz  wim  cab "
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if "%Archive.exten%"==".%%a" echo,	%txt_aa.type%	!ui.Arc.exten: %%a =[%%a]!
	)
) else echo,
echo,

if not defined Add-Level set "Add-Level=3"
for %%A in (
	0/"^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	1/"^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	2/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!^!txt_sym.cir^!"
	3/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!^!txt_sym.cir^!"
	4/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir^!"	
	5/"^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!^!txt_sym.cir.s^!"
) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%%~a"=="!Add-Level!" for %%i in (rar 7z zip bz2 gz xz cab) do if "%Archive.exten%"==".%%i" (
		echo,	%txt_aa.eff%		%%~b !txt_aa.eff.%%~a!
	)
	if "%%~a"=="0" for %%i in (tar wim) do if "%Archive.exten%"==".%%i" (
		echo,	%txt_aa.eff%		%%~b !txt_aa.eff.%%~a!
	)
)

if "%ArchiveOrder%"=="add" (
	echo,"rar 7z xz" | find "%Archive.exten:~1%" >nul && (
		if "%Add-Solid%"=="y" echo,	%txt_aa.solid%		%txt_sym.cir.s%
		if not "%Add-Solid%"=="y" echo,	%txt_aa.solid%		%txt_sym.cir%
	) || echo,
) else echo,

if "%ArchiveOrder%"=="add" (
	echo,"rar 7z zip tar bz2 gz xz wim" | find "%Archive.exten:~1%" >nul && (
		if not defined �־�ѹ�� echo,	%txt_aa.split%		%txt_sym.cir%
		if defined �־�ѹ�� echo,	%txt_aa.split%		%txt_sym.cir.s% %�־�ѹ��%
	) || echo,
) else echo,

echo,
if "%ArchiveOrder%"=="add" (
	echo,"rar 7z" | find "%Archive.exten:~1%" >nul && (
		for %%A in (
			""/^!txt_sym.cir^!
			y/"^!txt_sym.cir.s^! %txt_aa.sfx.origin%"
			a32/"^!txt_sym.cir.s^! %txt_aa.sfx.a%"
			a64/"^!txt_sym.cir.s^! %txt_aa.sfx.a%%txt_aa.sfx.64%"
			b32/"^!txt_sym.cir.s^! %txt_aa.sfx.b%"
			b64/"^!txt_sym.cir.s^! %txt_aa.sfx.b%%txt_aa.sfx.64%"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%�Խ�ѹ%"=="%%~a" echo,	%txt_aa.sfxmode%		%%~b
		)
	) || echo,
) else echo,

echo,
echo,"rar 7z zip" | find "%Archive.exten:~1%" >nul && (
	for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Archive.exten%"==".%%a" (
		if not defined ѹ������ echo,	%txt_aa.encry%		%txt_sym.cir%
		if defined ѹ������ echo,	%txt_aa.encry%		%txt_sym.cir.s% %ѹ������%
	)
) || echo,

echo,
if "%ArchiveOrder%"=="add" (
	if /i "%Archive.exten%"==".rar" (
		if not defined ѹ���汾.rar set "ѹ���汾.rar=5"
		for %%A in (
			4/^!txt_sym.cir.s^!,5/^!txt_sym.cir^!
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "!ѹ���汾.rar!"=="%%~a" echo,	%txt_aa.compati%		%%~b
		)
		for %%A in (
			""/^!txt_sym.cir^!,3/"^!txt_sym.cir.s^! 3%%",6/"^!txt_sym.cir.s^! 6%%",9/"^!txt_sym.cir.s^! 9%%"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%ѹ���ָ���¼%"=="%%~a" echo,	%txt_aa.record%		%%~b
		)
	) else (echo, & echo,)
)
echo,
echo,
%echo%,						%txt_b7.top%%txt_b7.top%
%echo%,						%txt_b7.confirm%%txt_b7.cancel%
%echo%,						%txt_b7.bot%%txt_b7.bot%

::UI--------------------------------------------------
::�����ж� 
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

if "%ArchiveOrder%"=="add" (
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if /i "%key%"=="%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :ѹ����ʽ�л� %%a
	)
)

if "%key%"=="a" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Add_Set.cmd" :����·��
) else if "%key%"=="b" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Add_Set.cmd" :���
) else if "%key%"=="c" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Add_Set.cmd" :��������
) else if "%key:~0,1%"=="d" ( for %%a in (rar 7z zip bz2 gz xz cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :Level %key:~1%
) else if "%key%"=="e" ( if "%ArchiveOrder%"=="add" for %%a in (rar 7z xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :��ʵ�ļ�
) else if "%key:~0,1%"=="f" ( for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :�־�ѹ�� %key:~1%
) else if "%key:~0,1%"=="g" ( if "%ArchiveOrder%"=="add" for %%a in (rar 7z) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :�Խ�ѹ  %key:~1%
) else if "%key:~0,1%"=="h" ( for %%a in (rar 7z zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Add_Set.cmd" :ѹ������ %key:~1%
) else if "%key%"=="i" ( if "%ArchiveOrder%"=="add" if /i "%Archive.exten%"==".rar" call "%dir.jzip%\Parts\Add_Set.cmd" :ѹ���汾.rar
) else if "%key:~0,1%"=="j" ( if "%ArchiveOrder%"=="add" if /i "%Archive.exten%"==".rar" call "%dir.jzip%\Parts\Add_Set.cmd" :ѹ���ָ���¼ %key:~1%
) else if "%key%"=="next"  ( goto :Add_Process
) else if "%key%"=="back" ( set "path.File=" & goto :EOF
)
goto :Archive_Setting


:Add_Process
cls

:: �½�ѹ��ʱ 
if not "%ArchiveOrder%"=="list" (

	:: ���ñ༭�� 
	for %%i in (7z zip tar bz2 gz xz wim) do if /i "%Archive.exten%"==".%%i" set "type.editor=7z"
	if /i "%Archive.exten%"==".rar" set "type.editor=rar"
	if /i "%Archive.exten%"==".cab" set "type.editor=cab"

	:: ����ѹ��·�� 
	set "path.Archive=%Archive.dir%%Archive.name%!Archive.exten.out!"
)

::����ѹ������ 
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
if defined Add-Solid set "btn.��ʵ�ļ�=-s"
if defined ѹ������ set "btn.ѹ������=-p%ѹ������%"
if defined �־�ѹ�� set "btn.�־�ѹ��= -v%�־�ѹ��%"
if defined ѹ���汾.rar set "btn.ѹ���汾.rar=-ma%ѹ���汾.rar%"
if defined ѹ���ָ���¼ set "btn.ѹ���ָ���¼=-rr%ѹ���ָ���¼%"
if defined �Խ�ѹ (
	for %%A in (
		a32/Default/7z
		a64/Default64/""
		b32/WinCon/7zCon
		b64/WinCon64/""
	) do for /f "tokens=1-3 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".rar" if "%�Խ�ѹ%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx""
		if "%Archive.exten%"==".7z" if "%�Խ�ѹ%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx""
		)
	)
)

if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.ѹ������% %btn.ѹ������% %btn.��ʵ�ļ�% %btn.�־�ѹ��% %btn.ѹ���汾.rar% -ep1 %btn.ѹ���ָ���¼% %btn.�Խ�ѹ% -w"%dir.jzip.temp%" "%path.Archive%" %path.File% %iferror%

if "%File.Single%"=="n" for %%a in (bz2 gz xz) do if "%Archive.exten%"==".%%a" (
	"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%Archive.name%.tar" %path.File% %iferror%
	set "path.Archive=%Archive.dir%%Archive.name%.tar%Archive.exten%"
	set "path.File=%dir.jzip.temp%\%Archive.name%.tar"
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.ѹ������% %btn.ѹ������% %btn.�־�ѹ��% -w"%dir.jzip.temp%" %btn.�Խ�ѹ% "%path.Archive%" %path.File% %iferror%

if "%type.editor%"=="cab" "%path.editor.cab%" -r %btn.ѹ������% n "%path.Archive%" %path.File% %iferror%

set "path.File="
goto :EOF

