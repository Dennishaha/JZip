
::���� 
call :%*
goto :EOF


:ѹ����ʽ�л� 
set "Arc.exten=.%~1"
if /i not "%�Խ�ѹ%"=="" call :�Խ�ѹ -default
goto :EOF


:ѹ������ 
set "key="
if "%~1"=="" (
	if defined ѹ������ ( set "ѹ������=" ) else ( set "key=1" )
) else (
	if defined ѹ������ set "key=1"
)
if "%key%"=="1" %InputBox-r% ѹ������ "%ѹ������%" "%txt_aas.passwd%"
goto :EOF

:Level
for %%i in (0 1 2 3 4 5) do if "%~1"=="%%i" (
	set "Add-Level=%%i"
	goto :EOF
)
goto :EOF


:��ʵ�ļ� 
if /i "%Add-Solid%"=="y" set "Add-Solid=" & goto :EOF
if /i "%Add-Solid%"=="" set "Add-Solid=y" & goto :EOF
set "Add-Solid=" & goto :EOF


:�־�ѹ�� 
set "key="
if "%~1"=="" (
	if defined �־�ѹ�� ( set "�־�ѹ��=" ) else ( set "key=1" )
) else (
	if defined �־�ѹ�� set "key=1"
)
if "%key%"=="1" (
	%InputBox-r% �־�ѹ�� "%�־�ѹ��%" "%txt_aas.split%" " " "%txt_aas.unit%"
	if defined �־�ѹ�� (
		%CapTrans% a �־�ѹ�� 
		for %%i in (b k m g t) do if /i "!�־�ѹ��:~-1!"=="%%i" goto :EOF
		set "�־�ѹ��=!�־�ѹ��!m"

	)
)
goto :EOF


:ѹ���汾.rar 
if /i "%ѹ���汾.rar%"=="5" set "ѹ���汾.rar=4" & goto :EOF
if /i "%ѹ���汾.rar%"=="4" set "ѹ���汾.rar=5" & goto :EOF
set "ѹ���汾.rar=5" & goto :EOF


:ѹ���ָ���¼ 
if "%~1"=="" (
	if defined ѹ���ָ���¼ ( set "ѹ���ָ���¼=" ) else ( set "ѹ���ָ���¼=3" )
) else (
	for %%A in (3/6 6/9 9/3) do (
		for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%ѹ���ָ���¼%"=="%%~a" set "ѹ���ָ���¼=%%~b" & goto :EOF
		)
	)
)
goto :EOF


:�Խ�ѹ 
if "%~1"=="-default" (
	set "�Խ�ѹ="
	for %%i in (rar 7z) do if "%Arc.exten%"==".%%i" set "�Խ�ѹ=a32"
	goto :EOF
)
if "%~1"=="" (
	if defined �Խ�ѹ ( set "�Խ�ѹ=" ) else ( set "�Խ�ѹ=a32" )
) else (
	for %%A in (
		rar/a32/a64,rar/a64/b32,rar/b32/b64,rar/b64/a32,
		7z/a32/b32,7z/b32/a32,
		zip/a32/a64,zip/a64/a32,
	) do (
		for /f "tokens=1,2,3 delims=/" %%a in ("%%A") do (
			if "%Arc.exten%"==".%%~a" if "%�Խ�ѹ%"=="%%~b" set "�Խ�ѹ=%%~c" & goto :EOF
		)
	)
)
goto :EOF


:�������� 
%InputBox-r% key1 "%Arc.name%" "%txt_aas.zipname%"
if not defined key1 goto :EOF
set "Arc.name=%key1%"
for /f "delims=" %%i in ("%Arc.name%") do (
	if "%Arc.exten%"=="%%~xi" set "Arc.name=%%~ni"
)
goto :EOF


:��� 
call "%dir.jzip%\Function\Select_File.cmd" key1
if not defined key1 goto :EOF
for /f "delims=" %%i in ("%key1%") do (
	for %%a in (%jzip.spt.write%) do if /i "%%~xi"==".%%a" (
		if /i "%%~xi"==".exe" (
			"%path.editor.7z%" l "%%~i" | findstr /r /c:"^Type = 7z.*" >nul && ( set "Arc.exten=.7z" & set "�Խ�ѹ=y" )
			"%path.editor.rar%" l "%%~i" | findstr /r /c:"^Details: RAR.*" >nul && ( set "Arc.exten=.rar" & set "�Խ�ѹ=y" )
			if not "!�Խ�ѹ!"=="y" %MsgBox% "%txt_notzip%" " " "%%~i" & goto :EOF
		) else (
			set "Arc.exten=%%~xi"
		)
		set "Arc.dir=%%~dpi"
		set "Arc.name=%%~ni"
		goto :EOF
	)
	for %%a in (%jzip.spt.noadd%) do if /i "%%~xi"==".%%a" (
		%MsgBox% "%txt_cantadd%" " " "%%~i"
		goto :EOF
	)
	%MsgBox% "%txt_notzip%" " " "%%~i"
)
goto :EOF


:����·�� 
call "%dir.jzip%\Function\Select_Folder.cmd" key1
if defined key1 set "Arc.dir=%key1%"
goto :EOF
:Sign-LOINGS_4 
Set LOINGS-SA_Name=JZip'
Set LOINGS-SA_Info=.'
Set LOINGS-SA_Version=3.3.1'
Set LOINGS-SA_Safe=NORMAL'
Set LOINGS-SA_MinEnv=6.1'
Set LOINGS-SA_Writter=JFSoft'
Set LOINGS-SA_PublicKey=ce3ceb7413b1824040ecf333a4e41e63'
Set LOINGS-SA_PrivateVer=1719ab8513b006fdd29fae30e5160817157fd468c609bbde2b2becdb52e755e9'
Set LOINGS-SA_VerCode=7ccff45db2b41668f16576a7fb96da05cd11136dd0954b4c9a89b2ca5d6ef008'
