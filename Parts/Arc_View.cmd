echo.
echo. �����Ҫ�򿪵ĵ����ļ���
echo.
echo. ע��ͨ��������á�
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF

echo.%Archive.file%|findstr *>nul&&(echo.��Ǹ��ͨ��������á�& pause>nul& goto :EOF)

set "random1=%random%%random%"
set "Archive.file=%Archive.file:"=%"

if "%Archive.file:~-4%"==".exe" (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" %iferror%
) else (
	if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
	if "%type.editor%"=="7z" "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" "%Archive.file%" %iferror%
)

start "" "%dir.jzip.temp%\%random1%\%Archive.file%"
goto :EOF