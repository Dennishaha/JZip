
if not defined path.File (
	echo.
	echo. ������Ҫ��ӵ��ļ�^(��^)��
	echo.
	echo. ע��ʹ�� �ո� ����������Ӷ���
	echo.     �ļ���·����� \* �����ݻ�Ŀ¼��
	echo.
	set path.File=&set /p path.File=
	if not defined path.File goto :EOF
)

call :GetFile_Single %path.File%

:Archive_Setting
call :GetFile_Info %path.Archive%
for %%a in (7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" set "type.editor=7z"
for %%a in (rar) do if /i "%Archive.exten%"==".%%a" set "type.editor=rar"
for %%a in (cab) do if /i "%Archive.exten%"==".%%a" set "type.editor=cab"
if "!�Խ�ѹ!"=="y" (set "path.Archive=!dir.File!\!File.name!.exe") else (set "path.Archive=!dir.File!\!File.name!!Archive.exten!")
if "%ArchiveOrder%"=="add-7z" goto :Add_Process
for %%a in (��ʵ�ļ�,ѹ������,�Խ�ѹ) do if "!%%a!"=="y" (set "ui.%%a=��") else (set "ui.%%a=��")
cls
echo. ��ӵ�ѹ����
echo.
echo.
echo.
if "%ArchiveOrder%"=="add" echo.            [R] ѹ������%path.Archive:~0,50%
if "%ArchiveOrder%"=="list" echo.                ѹ������%path.Archive:~0,50%
echo.                        %path.Archive:~50%
echo.
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten=��rar ��7z ��zip ��tar ��bz2 ��gz ��xz ��wim ��cab"
	for %%A in (��:rar,��:7z,��:zip,��:tar,��:bz2,��:gz,��:xz,��:wim,��:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%b" echo.                ��ʽ��  !ui.Arc.exten:%%a=��!
	)
	echo.
	echo.
)
for %%i in (rar,7z,zip,bz2,gz,xz,cab) do if "%Archive.exten%"==".%%i" (
	for %%A in (0:"������ �洢",1:"������ ���",2:"������ �ܿ�",3:"������ ��׼",4:"������ �ܺ�",5:"������ ���") do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%ѹ������%"=="%%~a" echo.            [E] ѹ��Ч�ʣ�         %%~b
	)
) 
for %%a in (tar,wim) do if /i "%Archive.exten%"==".%%a" (
	echo.                ѹ��Ч�ʣ�         ������ �洢
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" (
	echo.            [A] ��ʵ�ļ���         %ui.��ʵ�ļ�%
)
echo.
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" (
	if "%�־�ѹ��%"=="" echo.            [S] �־�ѹ��,��С��    ���־�
	if not "%�־�ѹ��%"=="" echo.            [S] �־�ѹ��,��С��    %�־�ѹ��%
)
if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" (
	echo.            [D] RARѹ��,�汾��     %ѹ���汾.rar%
	echo.
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.            [F] �������ͷų���   %ui.�Խ�ѹ%
	if "%�Խ�ѹ%"=="y" for %%A in (a32:"��׼����",a64:"��׼���棨64λ��",b32:"����̨����",b64:"����̨���棨64λ��") do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
			if "%�Խ�ѹģ��%"=="%%~a" echo.            [G]  L ģ�飺          %%~b
	)
	echo.
)
for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.            [Q] ���ܣ�             %ui.ѹ������% %ѹ������%
)
echo.
echo.
if "%ArchiveOrder%"=="add" for %%A in (1:rar,2:7z,3:zip,4:tar,5:bz2,6:gz,7:xz,8:wim,9:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%b"  echo.            [%%a] ȷ��   [0] ����
)
if "%ArchiveOrder%"=="list" echo.            [1] ȷ��   [0] ����
%choice% /c:123456789reasdfgq0 /n
set "next=%errorlevel%"
if "%ArchiveOrder%"=="add" (
	for %%A in (1:rar,2:7z,3:zip,4:tar,5:bz2,6:gz,7:xz,8:wim,9:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%next%"=="%%a" if "%Archive.exten%"==".%%b" (goto :Add_Process) else (set "Archive.exten=.%%b" & call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ����ʽ�л�)
	)
)
if "%ArchiveOrder%"=="list" if "%next%"=="1" goto :Add_Process

if "%next%"=="10" if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Set_Zip.cmd" :Ŀ��·��
if "%next%"=="11" for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ������
if "%next%"=="12" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :��ʵ�ļ�
if "%next%"=="13"  for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :�־�ѹ��
if "%next%"=="14" if "%ArchiveOrder%"=="add" for %%a in (rar) do if "%Archive.exten%"=="%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ���汾.rar
if "%next%"=="15" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :�Խ�ѹ
if "%next%"=="16" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :�Խ�ѹģ��
if "%next%"=="17" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :ѹ������
if "%next%"=="18" set "next=" & goto :EOF
goto :Archive_Setting


:Add_Process
cls
::����ѹ������
for %%A in (0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21) do (
	for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
	if "%type.editor%"=="rar" if "%ѹ������%"=="%%a" set "btn.ѹ������=%%b"
	if "%type.editor%"=="7z" if "%ѹ������%"=="%%a" set "btn.ѹ������=%%c"
	if "%type.editor%"=="cab" if "%ѹ������%"=="%%a" set "btn.ѹ������=%%d"
)

if "%ѹ������%"=="y" set "btn.ѹ������=-p%ѹ������%"
if "%��ʵ�ļ�%"=="y" set "btn.��ʵ�ļ�=-s"
if defined �־�ѹ�� set "btn.�־�ѹ��= -v%�־�ѹ��%"
if "%�Խ�ѹ%"=="y" (
	for %%A in (
		a32/Default/7z/Zip,
		a64/Default64//Zip64,
		b32/WinCon/7zCon/,
		b64/WinCon64//,
	) do for /f "tokens=1-4 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".rar" if "%�Խ�ѹģ��%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx""
		if "%Archive.exten%"==".7z" if "%�Խ�ѹģ��%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx""
		if "%Archive.exten%"==".zip" if "%�Խ�ѹģ��%"=="%%a" set "btn.�Խ�ѹ=-sfx"%dir.jzip%\Components\Sfx\%%d.sfx""
		)
	)
)

if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.ѹ������% -m%btn.ѹ������% %btn.��ʵ�ļ�% %btn.�־�ѹ��% -ma%ѹ���汾.rar% -ep1 %btn.�Խ�ѹ% -w"%dir.jzip.temp%" "%path.Archive%" %path.File%

if "%File.Single%"=="n" for %%a in (.bz2 .gz .xz) do if "%Archive.exten%"=="%%a" (
	"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%File.name%.tar" %path.File%
	set "path.Archive=%dir.File%\%File.name%.tar%Archive.exten%"
	set "path.File=%dir.jzip.temp%\%File.name%.tar"
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.ѹ������% -mx=%btn.ѹ������% %btn.�־�ѹ��% -w"%dir.jzip.temp%" %btn.�Խ�ѹ% "%path.Archive%" %path.File%

if "%type.editor%"=="cab" "%path.editor.cab%" -r -m %btn.ѹ������% n "%path.Archive%" %path.File%


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

:GetFile_Info
for /f "usebackq delims==" %%a in ('"%~1"') do (
	set "dir.File=%%~dpa" & set "dir.File=!dir.File:~0,-1!"
	set "File.name=%%~na"
	set "File.exten=%%~xa"
)
goto :EOF