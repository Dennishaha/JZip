
if not defined path.File (
	echo.
	echo. ������Ҫ��ӵ��ļ�^(��^)��
	echo.
	echo. ע��ʹ�� �ո� ����������Ӷ���
	echo.     �ļ���·����� \* �����ݻ�Ŀ¼��
	echo.
	set "path.File=" & set /p "path.File="
	if not defined path.File goto :EOF
)

call :GetFile_Single %path.File%

:Archive_Setting
call :Archive_info "%path.Archive%"
if "%ArchiveOrder%"=="add-7z" goto :Add_Process
for %%a in (��ʵ�ļ�,ѹ������) do if "!%%a!"=="y" (set "ui.%%a=��") else (set "ui.%%a=��")
cls
echo.
echo.  ��ӵ�ѹ����
echo.
echo.
if "%ArchiveOrder%"=="add" echo.            [R] ѹ����  %path.Archive:~0,50%
if "%ArchiveOrder%"=="list" echo.                ѹ����  %path.Archive:~0,50%
echo.                        %path.Archive:~50%
echo.
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten=��7z ��rar ��zip ��tar ��bz2 ��gz ��xz ��wim ��cab"
	for %%A in (��/7z,��/rar,��/zip,��/tar,��/bz2,��/gz,��/xz,��/wim,��/cab) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%~b" echo.                ��ʽ    !ui.Arc.exten:%%~a=��!
	)
	echo.
)
for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if "%Archive.exten%"==".%%a" (
	for %%A in (
		0/"������ �洢"
		1/"������ ���"
		2/"������ �ܿ�"
		3/"������ Ĭ��"
		4/"������ �ܺ�"	
		5/"������ ���"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%ѹ������%"=="%%~a" echo.            [E] ѹ��Ч��           %%~b
	)
) 
for %%a in (tar,wim) do if /i "%Archive.exten%"==".%%a" (
	echo.                ѹ��Ч��           ������ �洢
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" (
	echo.            [A] ��ʵ�ļ�           %ui.��ʵ�ļ�%
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" (
	if "%�־�ѹ��%"=="" echo.            [S] �־�               ��
	if not "%�־�ѹ��%"=="" echo.            [S] �־�               �� %�־�ѹ��%
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.
	for %%A in (
		""/"�� "
		a32/"�� ��׼����"
		a64/"�� ��׼���棨64λ��"
		b32/"�� ����̨����"
		b64/"�� ����̨���棨64λ��"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%�Խ�ѹ%"=="%%~a" echo.            [F] �������ͷų���     %%~b
	)
)
for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.
	echo.            [Q] ����               %ui.ѹ������% %ѹ������%
)
if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" (
	echo.
	for %%A in (
		"4"/"��","5"/"��"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if not defined ѹ���汾.rar set "ѹ���汾.rar=5"
		if "!ѹ���汾.rar!"=="%%~a" echo.            [D] �������ڰ汾       %%~b
	)
	for %%A in (
		""/"��","3"/"�� Ĭ��","6"/"�� ǿ"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%ѹ���ָ���¼%"=="%%~a" echo.            [C] �ָ���¼           %%~b
	)
)
echo.
echo.
echo.            [�س�] ȷ��   [0] ����
echo.
%key.request%
if /i "%key%"=="" goto :Add_Process
if "%ArchiveOrder%"=="add" (
	for %%A in (1/7z,2/rar,3/zip,4/tar,5/bz2,6/gz,7/xz,8/wim,9/cab) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if /i "%key%"=="%%a" set "Archive.exten=.%%b" & call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ����ʽ�л�
	)
)
if /i "%key%"=="R" if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Set_Zip.cmd" :Ŀ��·��
if /i "%key%"=="E" for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ������
if /i "%key%"=="A" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :��ʵ�ļ�
if /i "%key%"=="S"  for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :�־�ѹ��
if /i "%key%"=="F" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :�Խ�ѹ
if /i "%key%"=="Q" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ������
if /i "%key%"=="D" if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ���汾.rar
if /i "%key%"=="C" if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ���ָ���¼
if /i "%key%"=="0" set "key=" & goto :EOF
goto :Archive_Setting


:Add_Process
cls
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
		a32/Default/7z/Zip,
		a64/Default64/""/Zip64,
		b32/WinCon/7zCon/"",
		b64/WinCon64/""/,
	) do for /f "tokens=1-4 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".rar" if "%�Խ�ѹ%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx""
		if "%Archive.exten%"==".7z" if "%�Խ�ѹ%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx""
		if "%Archive.exten%"==".zip" if "%�Խ�ѹ%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%d.sfx""
		)
	)
)

if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.ѹ������% %btn.ѹ������% %btn.��ʵ�ļ�% %btn.�־�ѹ��% %btn.ѹ���汾.rar% -ep1 %btn.ѹ���ָ���¼% %btn.�Խ�ѹ% -w"%dir.jzip.temp%" "%path.Archive%" %path.File% %iferror%

if "%File.Single%"=="n" for %%a in (.bz2 .gz .xz) do if "%Archive.exten%"=="%%a" (
	"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%File.name%.tar" %path.File% %iferror%
	set "path.Archive=%dir.File%\%File.name%.tar%Archive.exten%"
	set "path.File=%dir.jzip.temp%\%File.name%.tar"
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.ѹ������% %btn.ѹ������% %btn.�־�ѹ��% -w"%dir.jzip.temp%" %btn.�Խ�ѹ% "%path.Archive%" %path.File% %iferror%

if "%type.editor%"=="cab" "%path.editor.cab%" -r %btn.ѹ������% n "%path.Archive%" %path.File% %iferror%


if "%ArchiveOrder%"=="add" (
	echo.------------------------------------------------------------------------------
	echo.
	echo.     ����·����
	echo.       %path.Archive:~0,66%
	echo.       %path.Archive:~66%
	echo.                                    [�س�] ��
	pause >nul
)
set "path.File=" & goto :EOF



:GetFile_Single
if "%~2"=="" (
	dir "%~1" /a:d /b 1>nul 2>nul && set "File.Single=n" || set "File.Single=y"
) else (
	set "File.Single=n"
)
goto :EOF

:Archive_info
for /f "usebackq delims==" %%a in ('"%~1"') do (
	set "dir.File=%%~dpa" & set "dir.File=!dir.File:~0,-1!"
	set "File.name=%%~na"
	set "File.exten=%%~xa"
	
	dir "!path.raw.1!" /a:-d /b 1>nul 2>nul && (
		if not defined �Խ�ѹ set "path.Archive=%%~dpa%%~na!Archive.exten!"
		if defined �Խ�ѹ set "path.Archive=%%~dpa%%~na.exe"
	)
	dir "%~1" /a:d /b 1>nul 2>nul && (
		if not defined �Խ�ѹ set "path.Archive=%~1!Archive.exten!"
		if defined �Խ�ѹ set "path.Archive=%~1.exe"
	)

	title !path.Archive! %title%
)

for %%a in (7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" set "type.editor=7z"
if /i "%Archive.exten%"==".rar" set "type.editor=rar"
if /i "%Archive.exten%"==".cab" set "type.editor=cab"
goto :EOF