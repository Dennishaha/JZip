
::����
call :%*
goto :EOF

:ѹ����ʽ�л�
if /i not "%�Խ�ѹ%"=="" call :�Խ�ѹ -default
goto :EOF

:ѹ������
if /i "%ѹ������%"=="y" (
	set "ѹ������="
	set "ѹ������="
	goto :EOF
)
if /i "%ѹ������%"=="" (
	set "ѹ������=y"
	call "%dir.jzip%\Parts\VbsBox" InputBox ѹ������ "�趨ѹ�����룺"
	if not defined ѹ������ set "ѹ������="
	goto :EOF
)
set "ѹ������=" & goto :EOF

:ѹ������
for %%A in (0:1,1:2,2:3,3:4,4:5,5:0) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%ѹ������%"=="%%a" set "ѹ������=%%b" & goto :EOF
	)
)
goto :EOF

:��ʵ�ļ�
if /i "%��ʵ�ļ�%"=="y" set "��ʵ�ļ�=" & goto :EOF
if /i "%��ʵ�ļ�%"=="" set "��ʵ�ļ�=y" & goto :EOF
set "��ʵ�ļ�=" & goto :EOF

:�־�ѹ��
if defined �־�ѹ�� set "�־�ѹ��=" & goto :EOF
call "%dir.jzip%\Parts\VbsBox" InputBox �־�ѹ�� "�趨�־�ѹ����С��" " " "[��С/��λ] k/m/g"
if "%�־�ѹ��%"=="" set "�־�ѹ��=" & goto :EOF
set "�־�ѹ��=%�־�ѹ��%" & goto :EOF

:ѹ���汾.rar
if /i "%ѹ���汾.rar%"=="5" set "ѹ���汾.rar=4" & goto :EOF
if /i "%ѹ���汾.rar%"=="4" set "ѹ���汾.rar=5" & goto :EOF
set "ѹ���汾.rar=5" & goto :EOF

:ѹ���ָ���¼
for %%A in (
	""/3,3/6,6/""
) do (
	for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%ѹ���ָ���¼%"=="%%~a" set "ѹ���ָ���¼=%%~b" & goto :EOF
	)
)
goto :EOF

:�Խ�ѹ
if "%~1"=="-default" (
	set "�Խ�ѹ="
	for %%i in (rar 7z) do if "%Archive.exten%"==".%%i" set "�Խ�ѹ=a32"
	goto :EOF
)
for %%A in (
	rar/""/a32,rar/a32/a64,rar/a64/b32,rar/b32/b64,rar/b64/"",
	7z/""/a32,7z/a32/b32,7z/b32/"",
	zip/""/a32,zip/a32/a64,zip/a64/"",
) do (
	for /f "tokens=1,2,3 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".%%~a" if "%�Խ�ѹ%"=="%%~b" set "�Խ�ѹ=%%~c" & goto :EOF
	)
)
goto :EOF

:��������
call "%dir.jzip%\Parts\VbsBox" InputBox key1 "�趨ѹ�������ƣ�"
if not defined key1 goto :EOF
set "Archive.name=%key1%"
for /f "delims=" %%i in ("%Archive.name%") do (
	if "%Archive.exten%"=="%%~xi" set "Archive.name=%%~ni"
)
goto :EOF

:���
call "%dir.jzip%\Parts\Select_File.cmd" key1
if not defined key1 goto :EOF
for /f "delims=" %%i in ("%key1%") do (
	for %%a in (%jzip.spt.write%) do if /i "%%~xi"==".%%a" (
		if /i "%%~xi"==".exe" (
			"%path.editor.7z%" l "%%~i" | findstr /r /c:"^Type = 7z.*" >nul && ( set "Archive.exten=.7z" & set "�Խ�ѹ=y" )
			"%path.editor.rar%" l "%%~i" | findstr /r /c:"^����: RAR.*" >nul && ( set "Archive.exten=.rar" & set "�Խ�ѹ=y" )
			if not "!�Խ�ѹ!"=="y" call "%dir.jzip%\Parts\VbsBox" MsgBox "�������ѹ���ļ���" " " "%%~i" & goto :EOF
		) else (
			set "Archive.exten=%%~xi"
		)
		set "Archive.dir=%%~dpi"
		set "Archive.name=%%~ni"
		goto :EOF
	)
	for %%a in (%jzip.spt.write.noadd%) do if /i "%%~xi"==".%%a" (
		call "%dir.jzip%\Parts\VbsBox" MsgBox "������ӵ�����ѹ���ļ���" " " "%%~i" & goto :EOF
	)
	call "%dir.jzip%\Parts\VbsBox" MsgBox "�������ѹ���ļ���" " " "%%~i"
)
goto :EOF

:����·��
call "%dir.jzip%\Parts\Select_Folder.cmd" key1
if not defined key1 goto :EOF
set "Archive.dir=%key1%"
goto :EOF
