
if "%ArchiveOrder%"=="list" (
	call :Set_Unzip 
	if "%dir.typein%"=="" set "dir.release=%dir.Archive%"
	if "%dir.typein%"=="1" set "dir.release=%dir.Archive%\%Archive.name%"
	if "%dir.typein%"=="0" goto :EOF
)

if "%dir.typein%"=="" set "dir.release=%dir.Archive%"

if exist "%dir.release%" set "dir.release=%dir.Archive%\%Archive.name%_folder"

if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%dir.release%\" %iferror%
if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" %iferror%

echo.------------------------------------------------------------------------------
echo.
echo.    ����·����
echo.     %dir.release%\
echo.
echo.                                    [�س�] ��
pause>nul
goto :EOF

:Set_Unzip
echo.
echo. [�س�] ��ѹ�� %dir.Archive%\
echo.    [1] ��ѹ�� %dir.Archive%\%Archive.name%\
echo.
echo. ���߼����Զ���·����ѹ   [0] ����
echo.
set dir.typein=&set /p dir.typein=
goto :EOF
