color %������ɫ%

:menu
cls
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" "!path.editor.%%a!" l "%path.Archive%" %ViewExten%

echo.������������������������������������������������������������������������������
for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
if "%ui.Archive.writeable%"=="y" (
	echo. [1]�� [2]��ȡ [3]��ѹ�� [4]��� [5]ɾ�� [6]������ [7]�߼� [0]����
) else (
	echo. [1]�� [2]��ȡ [3]��ѹ�� [7]�߼� [0]����
)

%choice% /c:12345670 /n
set "key=%errorlevel%"
if "%key%"=="1" call "%dir.jzip%\Parts\Arc_View.cmd"
if "%key%"=="2" call "%dir.jzip%\Parts\Arc_UnPart.cmd"
if "%key%"=="3" call "%dir.jzip%\Parts\Arc_UnZip.cmd"
if "%key%"=="4" if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Add.cmd"
if "%key%"=="5" if "%ui.Archive.writeable%"=="y" call :Arc_Delete
if "%key%"=="6" if "%ui.Archive.writeable%"=="y" call :Arc_ReName
if "%key%"=="7" call :menu-more
if "%key%"=="8" set "key=" & goto :EOF
goto :menu

:menu-more
echo.
if "%type.editor%"=="7z" echo. -- [Q]���� [0] ����
if "%type.editor%"=="rar" echo. -- [Q]���� [W]�޸� [E]���� [R]���ע�� [T]�Խ�ѹת�� [0]����

%choice% /c:qwert0 /n
set "key=%errorlevel%"
if "%key%"=="1" call :Arc_Check & goto :EOF
if "%key%"=="2" if "%type.editor%"=="rar" call :Arc_Repair & goto :EOF
if "%key%"=="3" if "%type.editor%"=="rar" call :Arc_Lock & goto :EOF
if "%key%"=="4" if "%type.editor%"=="rar" call :Arc_Note & goto :EOF
if "%key%"=="5" if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd" & goto :EOF
if "%key%"=="6" set "key=" & goto :EOF
goto :menu-more


:Arc_Delete
echo.
echo. �����Ҫɾ�����ļ�(��)��
echo.
echo.  ע��ʹ�� �ո� ����������Ӷ���
echo.     ͨ��� * ? �������
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file%
goto :EOF

:Arc_ReName
echo.
echo. �����Ҫ���������ļ�(��)��
echo.
echo.  ע��ʹ�� �ո� ����������Ӷ���
echo.     ͨ��� * ? �������
echo.
set Archive.file=&set /p Archive.file=
if not defined Archive.file goto :EOF
echo.
echo. ���ļ�����
echo.
set "Archive.file.rn=" & set /p "Archive.file.rn="
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
echo.
echo.  ����ѹ���ļ��������޸ģ�ȷ������?
echo.            [Y] ȷ��    [0] ����
echo.
set "key=" & set /p "key="
if /i "%key%"=="y" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%"
	pause
)
goto :EOF