@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion

color %������ɫ%

:menu
cls
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" "!path.editor.%%a!" l "%path.Archive%" %ViewExten%

echo.������������������������������������������������������������������������������
for %%a in (rar,7z,zip,tar,wim) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
if "%ui.Archive.writeable%"=="y" (
	echo. [1]�� [2]��ȡ [3]��ѹ�� [4]��� [5]ɾ�� [6]�߼� [0]����
) else (
	echo. [1]�� [2]��ȡ [3]��ѹ�� [6]�߼� [0]����
)

%choice% /c:1234560 /n
set "next=%errorlevel%"
if "%next%"=="1"  call "%dir.jzip%\Parts\Arc_View.cmd"
if "%next%"=="2"  call "%dir.jzip%\Parts\Arc_UnPart.cmd"
if "%next%"=="3"  call "%dir.jzip%\Parts\Arc_Unzip.cmd"
if "%next%"=="4" for %%a in (rar,7z,zip,tar,wim) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Arc_Add.cmd"
if "%next%"=="5" for %%a in (rar,7z,zip,tar,wim) do if /i "%Archive.exten%"==".%%a" call :Arc_Delete
if "%next%"=="6" call :menu-more
if "%next%"=="7" set "next=" & goto :EOF
goto :menu

:menu-more
echo.
if "%type.editor%"=="7z" echo. -- [Q]���� [0] ����
if "%type.editor%"=="rar" echo. -- [Q]���� [W]�޸� [E]���� [R]���ע�� [T]�Խ�ѹת�� [0]����

%choice% /c:qwert0 /n
set "next=%errorlevel%"
if "%next%"=="1" call :Arc_Check & goto :EOF
if "%next%"=="2" if "%type.editor%"=="rar" call :Arc_Repair & goto :EOF
if "%next%"=="3" if "%type.editor%"=="rar" call :Arc_Lock & goto :EOF
if "%next%"=="4" if "%type.editor%"=="rar" call :Arc_Note & goto :EOF
if "%next%"=="5" if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd" & goto :EOF
if "%next%"=="6" set "next=" & goto :EOF
goto :menu-more


:Arc_Delete
echo.
echo. �����Ҫɾ�����ļ�(��)��
echo.
echo.  ע��ʹ�� �ո� ����������Ӷ���
echo.     ͨ��� * ? �������
echo.
set Archive.file=&set /p Archive.file=
if not defined Archive.file goto :EOF
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w%dir.jzip.temp% "%path.Archive%" %Archive.file%
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
echo.
echo.  ����ѹ���ļ��������޸ģ�ȷ������?
echo.            [Y] ȷ��    [0] ����
echo.
set next=&set /p next=
if /i "%next%"=="y" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w%dir.jzip.temp% "%path.Archive%"
	pause
)
goto :EOF