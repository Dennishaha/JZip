
::ѡ���ļ����
for %%i in (Open UnPart Delete ReName) do if /i "%~1"=="%%i" (
	for /f "tokens=2 delims==" %%a in ('2^>nul set "listzip.LineFileSel."') do (
		if "%type.editor%"=="7z" set "listzip.File.%%a=!listzip.LineFile.%%a:~53!"
		if "%type.editor%"=="rar" set "listzip.File.%%a=!listzip.LineFile.%%a:~41!"
		call :%* "!listzip.File.%%a!"
	)
)

::���ýӿ�
>nul 2>nul set "listzip.LineFileSel." || if not "%~1"=="" call :%*
goto :EOF


::���ļ�
:Open
if "%~1"=="" (
	call :InputBox Archive.file "������򿪵��ļ�����"
	if not defined Archive.file goto :EOF
	echo.%Archive.file% | findstr "* ?" >nul && (call :msgbox "ͨ��������á�" & goto :EOF)
) else (
	set "Archive.file=%~1"
)

cls
set "key1="
if /i "%Archive.file:~-4%"==".exe" call :msgbox2 key1 "Ӧ�ó������п�����Ҫ�丽�����ļ�����ȡȫ���ļ���"
if "%key1%"=="1" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" "%Archive.file%" %iferror%
)
echo.%Archive.file.dir%
start /i "" "%dir.jzip.temp%\%random1%\%Archive.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


::��ȡ�ļ�
:UnPart
if "%~1"=="" (
	call :InputBox Archive.file "�����Ҫȡ�����ļ�/�У�" "����ʹ��ͨ�����" "��ȡ���ļ���������ʱ�ļ��С�"
	if not defined Archive.file goto :EOF
) else (
	set "Archive.file=%~1"
)

if "%type.editor%"=="rar"  "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


::��ѹ�ļ�
:Unzip
if "%~1"=="/all" (
	set "dir.release=%dir.Archive%\%Archive.name%_unzip"
) else (
	call "%dir.jzip%\Parts\Select_Folder.cmd"
	if not defined key goto :EOF
	dir /a:d /b "!key!" && set "dir.release=!key!" || goto :EOF
)
cls
if not defined listzip.Dir (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" %iferror%
)
if defined listzip.Dir (
	if "%type.editor%"=="rar" "%path.editor.rar%" x  "%path.Archive%" "%listzip.Dir%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\"  "%path.Archive%" "%listzip.Dir%" %iferror%
)
goto :EOF


::ɾ���ļ�
:Delete
if "%~1"=="" (
	call :InputBox Archive.file "�����Ҫɾ�����ļ�/�У�" "����ʹ��ͨ�����"
	if not defined Archive.file goto :EOF
	set "ui.Archive.file=!Archive.file!"
) else (
	set "Archive.file=%~1"
	call set "ui.Archive.file=%%Archive.file:%listzip.Dir%\=%%"
)

call :msgbox2 key1 "ȷʵҪɾ����!ui.Archive.file: =��!����"
if "%key1%"=="1" (
	cls
	for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" %iferror%
	if not exist "%path.Archive%" mshta "vbscript:msgbox("ѹ���ļ���ɾ����",64,"��ʾ")(window.close)" & exit
)
goto :EOF


::�������ļ�
:ReName
if "%~1"=="" (
	call :InputBox Archive.file "�����Ҫ���������ļ�/�У�" "����ʹ��ͨ�����"
	if not defined Archive.file goto :EOF
	set "ui.Archive.file=!Archive.file!"
) else (
	set "Archive.file=%~1"
	call set "ui.Archive.file=%%Archive.file:%listzip.Dir%\=%%"
)

call :InputBox Archive.file.rn "�������!ui.Archive.file: =��!���������֣�" "����ʹ��ͨ�����"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%" %iferror%
	pause
)
if not defined Archive.file.rn goto :EOF

for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" "%Archive.file.rn%" %iferror%
goto :EOF


::ѹ�������
:Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%path.Archive%" %iferror%
pause
goto :EOF


::ѹ�����޸�
:Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%path.Archive%" %iferror%
pause
goto :EOF


::ѹ����ע��
:Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%path.Archive%" %iferror%
pause
goto :EOF


::ѹ��������
:Lock
call :msgbox2 key "����ѹ���ļ��󲻿��޸ģ�ȷ��������"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%" %iferror%
	pause
)
goto :EOF



::�������
:InputBox
set "%~1="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("%~2"&vbCrLf&vbCrLf&"%~3"&vbCrLf&"%~4","��ʾ"))(window.close)" ') do (
	if not defined listzip.Dir set "%~1=%%~a"
	if defined listzip.Dir set "%~1=!listzip.Dir!\%%~a"
)
goto :EOF

:msgbox
mshta vbscript:execute^("msgbox(""%~1"",64,""��ʾ"")(window.close)"^)
goto :EOF

:msgbox2
set "%~1="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox("%~2",1+64,"��ʾ"))(window.close)" ') do (
	set "%~1=%%a"
)
goto :EOF

