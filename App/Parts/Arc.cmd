@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul
color %������ɫ%

::��ʼ�����趨
set /a Window.Wide=110, Window.Height=35
mode %Window.Wide%, %Window.Height%
for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
for /f "delims=" %%a in ('cscript //nologo "%dir.jzip%\Parts\Create_GUID.vbs"') do set "random1=%%a"
set "listzip.txt=%dir.jzip.temp%\%random1%.tmp"
set "listzip.Dir="
set "listzip.Menu=basic"

:Menu
cls

:: ��̬�������ڴ�С������ʱ��ע���Խ���
for /f "tokens=1-2 delims= " %%i in ('mode') do (
	if "%%i"=="��:��" set "Window.Height=%%~j"
	if "%%i"=="��:����" set "Window.Wide=%%~j"
)
set /a "listzip.LineViewBlock=Window.Height-5"

:: ����ѹ�����ļ��б�
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" "!path.editor.%%a!" l "%path.Archive%" | find /v "" >"%listzip.txt%" %iferror%

:: �ҵ��г�ѹ�������ݵ�λ��
set /a listzip.LineFileStart=0, listzip.LineFileEnd=0
for /f "tokens=1 delims=:" %%i in ('findstr /n "^-----------" "%listzip.txt%"') do (
	if "!listzip.LineFileStart!"=="0" (set "listzip.LineFileStart=%%i" ) else ( set listzip.LineFileEnd=%%i )
)
set /a "listzip.LineFileEnd-=2","listzip.LineTitle=listzip.LineFileStart-2"

::�趨��ʾ��������
if not defined listzip.LineViewStart set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% LSS %listzip.LineFileStart% set /a "listzip.LineViewStart=listzip.LineFileStart"
if %listzip.LineViewStart% GTR %listzip.LineFileEnd% set /a "listzip.LineViewStart-=listzip.LineViewBlock"

::�趨��ʾ��ĩ����
set /a "listzip.LineViewEnd=listzip.LineViewStart+listzip.LineViewBlock-1"
if %listzip.LineViewEnd% GTR %listzip.LineFileEnd% set /a "listzip.LineViewEnd=listzip.LineFileEnd"

::�����ļ���������ʾҳ��
set /a "listzip.LineFileTotal=listzip.LineFileEnd-listzip.LineFileStart+1"
set /a "listzip.ViewPageNow=((listzip.LineViewStart-listzip.LineFileStart)/listzip.LineViewBlock)+1"
set /a "listzip.ViewPageTotal=(listzip.LineFileTotal-1)/listzip.LineViewBlock+1"

::����ѹ��������
if "%type.editor%"=="rar" (
	set /a "listzip.LineFileInfo=listzip.LineFileStart-4"
	call :����һ������ !listzip.LineFileInfo!
	call set "listzip.Info=%%listzip.LineFile.!listzip.LineFileInfo!:~3%%"
)

if "%type.editor%"=="7z" (
	set "listzip.Info="
	for /f "tokens=1-2 delims==" %%i in ('findstr "^Type ^Offset ^Method ^Solid " "%listzip.txt%"') do (
		if "%%i"=="Type " set "listzip.Info=!listzip.Info!%%j"
		if "%%i"=="Offset " set "listzip.Info=!listzip.Info!, �Խ�ѹ"
		if "%%i"=="Method " set "listzip.Info=!listzip.Info!,%%j"
		if "%%i"=="Solid " if "%%j"==" +" set "listzip.Info=!listzip.Info!, ��ʵ"
	)
)

::UI--------------------------------------------------

::��ʾѹ��������ѡ��
if "%listzip.Menu%"=="basic" (
	if "%ui.Archive.writeable%"=="y" echo.  ��ҳ ��  �� ��ȡ ��ѹ�� ��� ɾ�� ������ �߼� ��ҳ ��ҳ
	if "%ui.Archive.writeable%"==""  echo.  ��ҳ ��  �� ��ȡ ��ѹ��                  �߼� ��ҳ ��ҳ
)
if "%listzip.Menu%"=="advance" (
	if "%type.editor%"=="7z"  echo.  ��ҳ ��  ���� ����
	if "%type.editor%"=="rar" echo.  ��ҳ ��  ���� ���� �޸� ���� ���ע�� �Խ�ѹת��
)
::echo. File {%listzip.LineFileStart%:%listzip.LineFileEnd%} View [%listzip.LineViewStart%:%listzip.LineViewEnd%]
echo.
call :���һ������ %listzip.LineTitle%

:: if �ж��ų���ѹ���������ѹ�������ݵ���Ļ����������
if %listzip.LineFileStart% LEQ %listzip.LineFileEnd% (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do call :����һ������ %%a
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		for %%d in (%Window.Wide%) do echo,!listzip.LineFile.%%a:~0,%%d!
	)
)

::�������
set /a "listzip.ViewEchoEnd=listzip.LineViewStart+listzip.LineViewBlock"
set /a "listzip.ViewEchoSpace=listzip.ViewEchoEnd-listzip.LineFileEnd-2"
if %listzip.LineViewEnd% LSS %listzip.ViewEchoEnd% (
	for /l %%a in (0,1,!listzip.ViewEchoSpace!) do echo.
)

::�·���ʾ
echo.  %listzip.ViewPageNow%/%listzip.ViewPageTotal% ҳ  %listzip.LineFileTotal% ����Ŀ %listzip.Info%

::UI--------------------------------------------------
::�����ж�
%tmouse% /d 0 -1 1
%tmouse.process%
::ping localhost -n 2 >nul

set /a listzip.ButtonLine=3
if defined mouse.x if defined mouse.y (
	for /l %%a in (%listzip.LineViewStart%,1,%listzip.LineViewEnd%) do (
		if defined listzip.LineFile.%%a (
			if %mouse.y% EQU !listzip.ButtonLine! (
				if "%type.editor%"=="rar" if %mouse.x% GEQ 41 call "%dir.jzip%\Parts\Arc_Open.cmd" "!listzip.LineFile.%%a:~41!"
				if "%type.editor%"=="7z" if %mouse.x% GEQ 53 call "%dir.jzip%\Parts\Arc_Open.cmd" "!listzip.LineFile.%%a:~53!"
			)
		)
		set /a "listzip.ButtonLine+=1"
	)
)

for %%A in (
	basic}1}5}0}0}10}
	basic}10}13}0}0}1}
	basic}15}18}0}0}2}
	basic}20}25}0}0}3}
	basic}27}30}0}0}4}
	basic}32}35}0}0}5}
	basic}37}42}0}0}6}
	basic}44}47}0}0}7}
	basic}49}52}0}0}8}
	basic}54}57}0}0}9}
	advance}1}5}0}0}10}
	advance}10}13}0}0}11}
	advance}15}18}0}0}12}
	advance}20}23}0}0}13}
	advance}25}28}0}0}14}
	advance}30}37}0}0}15}
	advance}39}48}0}0}16}
) do for /f "tokens=1-6 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y if "%listzip.Menu%"=="%%a" (
		if %mouse.x% GEQ %%b if %mouse.x% LEQ %%c if %mouse.y% GEQ %%d if %mouse.y% LEQ %%e set "key=%%f"
	)
)

if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Open.cmd"
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_UnPart.cmd"
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_UnZip.cmd"
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Add.cmd"
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call :Arc_Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call :Arc_ReName
) else if "%key%"=="7" ( set "listzip.Menu=advance"
) else if "%key%"=="8" ( set /a "listzip.LineViewStart-=%listzip.LineViewBlock%"
) else if "%key%"=="9" ( set /a "listzip.LineViewStart+=%listzip.LineViewBlock%"
) else if "%key%"=="10" ( start /i "" "%path.jzip.launcher%" & goto :EOF
) else if "%key%"=="11" ( set "listzip.Menu=basic"
) else if "%key%"=="12" ( call :Arc_Check
) else if "%key%"=="13" ( if "%type.editor%"=="rar" call :Arc_Repair
) else if "%key%"=="14" ( if "%type.editor%"=="rar" call :Arc_Lock
) else if "%key%"=="15" ( if "%type.editor%"=="rar" call :Arc_Note
) else if "%key%"=="16" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd"
)
goto :Menu


:����һ������
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do set "listzip.LineFile.%1=%%a" & goto :EOF
goto :EOF


:���һ������
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do echo,%%a & goto :EOF
goto :EOF


:Arc_Delete
set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("�����Ҫɾ�����ļ�/�У�"&vbCrLf&vbCrLf&"ʹ�ÿո�����������Ӷ�������ͨ���*?��","��ʾ"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file%
goto :EOF

:Arc_ReName
set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("�����Ҫ���������ļ�/�У�"&vbCrLf&vbCrLf&"ʹ�ÿո�����������Ӷ�������ͨ���*?��","��ʾ"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF
set "Archive.file.rn="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("������ļ�/�е������֣�"&vbCrLf&vbCrLf&"ʹ�ÿո�����������Ӷ�������ͨ���*?��","��ʾ"))(window.close)"') do (
	set "Archive.file.rn=%%a"
)
if not defined Archive.file.rn goto :EOF
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file% %Archive.file.rn%
goto :EOF

:Arc_Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%path.Archive%"
pause
goto :EOF

:Arc_Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%path.Archive%"
pause
goto :EOF

:Arc_Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%path.Archive%"
pause
goto :EOF

:Arc_Lock
set "key="
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox("����ѹ���ļ��󲻿��޸ģ�ȷ������?",1+64,"��ʾ"))(window.close)"') do set "key=%%a"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%"
	pause
)
goto :EOF

