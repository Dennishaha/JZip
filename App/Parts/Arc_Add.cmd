
:: �����ж�
if defined ArchiveOrder call :Archive_Setting
goto :EOF

:Archive_Setting
if defined �Խ�ѹ ( set "Archive.exten.out=.exe" ) else ( set "Archive.exten.out=%Archive.exten%" )

:: ѹ����������ļ������ظ��ж�
if "%path.raw.1%"=="%Archive.dir%%Archive.name%%Archive.exten.out%" set "Archive.name=%Archive.name% (1)"

set "ui.Archive.ne=%Archive.name%%Archive.exten.out%"
title ��ӵ� %ui.Archive.ne% %title%

::����ѹ��ʱǰ��ѹ��ִ��
if "%ArchiveOrder%"=="add-7z" goto :Add_Process

for %%a in (��ʵ�ļ� ѹ������) do if "!%%a!"=="y" ( set "ui.%%a=��" ) else ( set "ui.%%a=��" )

::UI--------------------------------------------------

cls
echo.
echo.   ����ļ���ѹ����
echo.                                                       [ ����·�� ] [ ��� ]
echo.
echo.              ѹ��������  %ui.Archive.ne:~0,40%
echo.                          %ui.Archive.ne:~40,80%
echo.
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten= 7z  rar  zip  tar  bz2  gz  xz  wim  cab "
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if "%Archive.exten%"==".%%a" echo.              ��ʽ    !ui.Arc.exten: %%a =[%%a]!
	)
) else echo.
echo.

if not defined ѹ������ set "ѹ������=3"
for %%A in (
	0/"������ �洢"
	1/"������ ���"
	2/"������ �ܿ�"
	3/"������ Ĭ��"
	4/"������ �ܺ�"	
	5/"������ ���"
) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%%~a"=="!ѹ������!" for %%a in (rar 7z zip bz2 gz xz cab) do if "%Archive.exten%"==".%%a" (
		echo.              ѹ��Ч��           %%~b
	)
	if "%%~a"=="0" for %%a in (tar wim) do if "%Archive.exten%"==".%%a" (
		echo.              ѹ��Ч��           %%~b
	)
)

if "%ArchiveOrder%"=="add" (
	for %%a in (rar 7z xz) do if /i "%Archive.exten%"==".%%a" (
		echo.              ��ʵ�ļ�           %ui.��ʵ�ļ�%
	)
	echo."rar 7z xz" | findstr "%Archive.exten%" >nul || echo.
) else echo.

if "%ArchiveOrder%"=="add" (
	for %%a in (rar 7z zip tar bz2 gz xz wim) do if /i "%Archive.exten%"==".%%a" (
		if "%�־�ѹ��%"=="" echo.              �־�               ��
		if not "%�־�ѹ��%"=="" echo.              �־�               �� %�־�ѹ��%
	)
	echo."rar 7z zip tar bz2 gz xz wim" | find "%Archive.exten:~1%" >nul || echo.
) else echo.

echo.
if "%ArchiveOrder%"=="add" (
	for %%a in (rar 7z) do if /i "%Archive.exten%"==".%%a" (
		for %%A in (
			""/��
			y/"�� ԭ���Խ�ѹģ��"
			a32/"�� ��׼����"
			a64/"�� ��׼���棨64λ��"
			b32/"�� ����̨����"
			b64/"�� ����̨���棨64λ��"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%�Խ�ѹ%"=="%%~a" echo.              �������ͷų���     %%~b
		)
	)
	echo."rar 7z" | find "%Archive.exten:~1%" >nul || echo.
) else echo.

echo.
for %%a in (rar 7z zip) do if /i "%Archive.exten%"==".%%a" (
	echo.              ����               %ui.ѹ������% %ѹ������%
)
echo."rar 7z zip" | find "%Archive.exten:~1%" >nul || echo.

echo.
if "%ArchiveOrder%"=="add" (
	if /i "%Archive.exten%"==".rar" (
		if not defined ѹ���汾.rar set "ѹ���汾.rar=5"
		for %%A in (
			"4"/"��","5"/"��"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "!ѹ���汾.rar!"=="%%~a" echo.              �������ڰ汾       %%~b
		)
		for %%A in (
			""/"��","3"/"�� Ĭ��","6"/"�� ǿ"
		) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%ѹ���ָ���¼%"=="%%~a" echo.              �ָ���¼           %%~b
		)
	)
	echo."rar" | find "%Archive.exten:~1%" >nul || (echo. & echo.)
)
echo.
echo.
echo.                                                 ��-----------�� ��-----------��
echo.                                                 ��    ȷ��   �� ��    ȡ��   ��
echo.                                                 ��-----------�� ��-----------��

::UI--------------------------------------------------
::�����ж�
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	22}25}7}7}7z}
	26}30}7}7}rar}
	31}35}7}7}zip}
	36}40}7}7}tar}
	41}45}7}7}bz2}
	46}49}7}7}gz}
	50}53}7}7}xz}
	54}58}7}7}wim}
	59}63}7}7}cab}

	55}66}2}2}a}
	68}75}2}2}b}
	14}71}4}5}c}
	33}42}9}9}d}
	33}34}10}10}e}
	33}34}11}11}f}
	33}50}13}13}g}
	33}34}15}15}h}
	33}34}17}17}i}
	33}39}18}18}j}

	50}61}21}23}next}
	64}75}21}23}back}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%a if %mouse.x% LEQ %%b if %mouse.y% GEQ %%c if %mouse.y% LEQ %%d set "key=%%e"
)

if "%ArchiveOrder%"=="add" (
	for %%a in (7z rar zip tar bz2 gz xz wim cab) do (
		if /i "%key%"=="%%a" set "Archive.exten=.%%a" & call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :ѹ����ʽ�л�
	)
)

if "%key%"=="a" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :����·��
) else if "%key%"=="b" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :���
) else if "%key%"=="c" ( if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :��������
) else if "%key%"=="d" ( for %%a in (rar 7z zip bz2 gz xz cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :ѹ������
) else if "%key%"=="e" ( if "%ArchiveOrder%"=="add" for %%a in (rar 7z xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :��ʵ�ļ�
) else if "%key%"=="f" ( for %%a in (rar 7z zip tar bz2 gz xz wim) do if "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :�־�ѹ��
) else if "%key%"=="g" ( if "%ArchiveOrder%"=="add" for %%a in (rar 7z) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :�Խ�ѹ
) else if "%key%"=="h" ( for %%a in (rar 7z zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :ѹ������
) else if "%key%"=="i" ( if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :ѹ���汾.rar
) else if "%key%"=="j" ( if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add_Set.cmd" :ѹ���ָ���¼
) else if "%key%"=="next"  ( goto :Add_Process
) else if "%key%"=="back" ( goto :EOF
)
goto :Archive_Setting


:Add_Process
cls

:: �½�ѹ��ʱ�����ñ༭��
if not "%ArchiveOrder%"=="list" (

	for %%i in (7z zip tar bz2 gz xz wim) do if /i "%Archive.exten%"==".%%i" set "type.editor=7z"
	if /i "%Archive.exten%"==".rar" set "type.editor=rar"
	if /i "%Archive.exten%"==".cab" set "type.editor=cab"
)

::����ѹ������
if defined ѹ������ (
	for %%A in (
		0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21
	) do (
		for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
		if "%type.editor%"=="rar" if "%ѹ������%"=="%%a" set "btn.ѹ������=-m%%b"
		if "%type.editor%"=="7z" if "%ѹ������%"=="%%a" set "btn.ѹ������=-mx=%%c"
		if "%type.editor%"=="cab" if "%ѹ������%"=="%%a" set "btn.ѹ������=-m %%d"
	)
)
if "%ѹ������%"=="y" set "btn.ѹ������=-p%ѹ������%"
if "%��ʵ�ļ�%"=="y" set "btn.��ʵ�ļ�=-s"
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

:: �½�ѹ��ʱ������ѹ��·��
if not "%ArchiveOrder%"=="list" (
	if defined �Խ�ѹ set "Archive.exten=.exe"
	set "path.Archive=%Archive.dir%%Archive.name%!Archive.exten!"
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

