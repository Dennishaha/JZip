
:: Ԥ�������
set "Archive.file="

:: �ļ���ѡ����

for %%i in (Unzip) do if /i "%~1"=="%%i" (
	if "%~2"=="" (
		call "%dir.jzip%\Parts\Select_Folder.cmd" dir.release
		if not defined dir.release goto :EOF
		dir /a:d /b "!dir.release!" || goto :EOF
	)
	if "%~2"=="/all" (
		set "dir.release=%dir.Archive%\%Archive.name%"
		:dir.release_cycle
		dir "!dir.release!" /a /b >nul 2>nul && (
			set "dir.release=!dir.release! (1)"
			goto :dir.release_cycle
		)
	)
)

:: �����򿪼��
for %%i in (Open) do if /i "%~1"=="%%i" (
	if not "%~2"=="" (
		set "Archive.file=%~2"
		call :%*
		goto :EOF
	)
)

:: ��ѡ���
>nul 2>nul set "listzip.LineFileSel." || for %%i in (
	Open\"������򿪵��ļ�����"
	UnPart\"�����Ҫȡ�����ļ�/�У�"\"����ʹ��ͨ�����"\"��ȡ���ļ���������ʱ�ļ��С�"
	Unzip
	Delete\"�����Ҫɾ�����ļ�/�У�"\"����ʹ��ͨ�����"
	ReName\"�����Ҫ���������ļ�/�У�"\"����ʹ��ͨ�����"
) do for /f "usebackq tokens=1-4 delims=\" %%a in ('%%i') do (
	if /i "%~1"=="%%~a" (
		if /i not "%%~b"=="" (
			call "%dir.jzip%\Parts\VbsBox" InputBox Archive.file "%%~b" "��" "%%~c" "%%~d"
			if not defined Archive.file goto :EOF
			set "ui.Archive.file=!Archive.file!"
			if defined listzip.Dir set "Archive.file=!listzip.Dir!\!Archive.file!"
		)
		call :%*
		goto :EOF
	)
)

:: ������
>nul 2>nul set "listzip.LineFileSel." && (
	for %%i in (Open UnPart UnZip Delete ReName) do if /i "%~1"=="%%i" (
		for /f "tokens=2 delims==" %%a in ('2^>nul set "listzip.LineFileSel."') do (
			if "%type.editor%"=="7z" set "listzip.File.%%a=!listzip.LineFile.%%a:~53!"
			if "%type.editor%"=="rar" set "listzip.File.%%a=!listzip.LineFile.%%a:~41!"
			set "Archive.file=!listzip.File.%%a!"
			call set "ui.Archive.file=%%Archive.file:%listzip.Dir%\=%%"
			call :%*
		)
	goto :EOF
	)
)

:: ����ѡ����
for %%i in (Add Check ReName Repair Note Lock) do if /i "%~1"=="%%i" (
	call :%*
	goto :EOF
)
goto :EOF


::����ļ�
:Add
call "%dir.jzip%\Parts\Select_File.cmd" key
set "path.File=!key!"
if not defined path.File goto :EOF

for %%a in (rar,7z) do if "%type.editor%"=="%%a" (
	if defined listzip.Dir (
		for /f "delims=" %%i in ('cscript //nologo "%dir.jzip%\Parts\Create_GUID.vbs"') do (
			>nul md "%dir.jzip.temp%\%%i\%listzip.Dir%"
			xcopy "!path.File!" "%dir.jzip.temp%\%%i\%listzip.Dir%" /e /q /h /k
			"!path.editor.%%a!" a -w"%dir.jzip.temp%" "%path.Archive%" "%dir.jzip.temp%\%%i\%listzip.Dir%" %iferror%
			>nul rd /s /q "%dir.jzip.temp%\%%i"
		)
	) else (
		"!path.editor.%%a!" a -w"%dir.jzip.temp%" "%path.Archive%" "!path.File!" %iferror%
	)
)
goto :EOF


::���ļ�
:Open
cls
set "key1="
if /i "%Archive.file:~-4%"==".exe" call "%dir.jzip%\Parts\VbsBox" MsgBox-s key1 "Ӧ�ó������п�����Ҫ�丽�����ļ�����ȡȫ���ļ���"
if "%key1%"=="1" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" "%Archive.file%" %iferror%
)
start /i "" "%dir.jzip.temp%\%random1%\%Archive.file%"
if errorlevel 1 start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


::��ȡ�ļ�
:UnPart
cls
if "%type.editor%"=="rar"  "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o"%dir.jzip.temp%\%random1%" -y "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%\%listzip.Dir%"
goto :EOF


::��ѹ�ļ�
:Unzip
cls
if not defined Archive.file (
	set "Archive.file=*"
)
if defined listzip.Dir (
	for /f "delims=" %%i in ('cscript //nologo "%dir.jzip%\Parts\Create_GUID.vbs"') do (
		>nul md "%dir.jzip.temp%\%%i"
		if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" "%dir.jzip.temp%\%%i\" %iferror%
		if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.jzip.temp%\%%i\" "%path.Archive%" "%Archive.file%" %iferror%
		xcopy "%dir.jzip.temp%\%%i\%listzip.Dir%" "%dir.release%" /e /q /h /k
		>nul rd /s /q "%dir.jzip.temp%\%%i"
	)
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" "%dir.release%\" %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" "%Archive.file%" %iferror%
)
pause
goto :EOF


::ɾ���ļ�
:Delete
call "%dir.jzip%\Parts\VbsBox" MsgBox-s key1 "ȷʵҪɾ�� %ui.Archive.file% ��"
if "%key1%"=="1" (
	cls
	for %%a in (rar,7z) do if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" "%Archive.file%" %iferror%
	if not exist "%path.Archive%" mshta "vbscript:msgbox("ѹ���ļ���ɾ����",64,"��ʾ")(window.close)" & exit
)
goto :EOF


::�������ļ�
:ReName
call "%dir.jzip%\Parts\VbsBox" InputBox Archive.file.rn "����� %ui.Archive.file% �������֣�" "����ʹ��ͨ�����"
if not defined Archive.file.rn goto :EOF
if defined listzip.Dir set "Archive.file.rn=!listzip.Dir!\!Archive.file.rn!"

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
call "%dir.jzip%\Parts\VbsBox" MsgBox-s key "����ѹ���ļ��󲻿��޸ģ�ȷ��������"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%" %iferror%
	pause
)
goto :EOF

