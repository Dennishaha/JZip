echo.
echo. 请键入要取出的文件(夹)：
echo.
echo. 注：使用 空格 区分项以添加多个项。
echo.    通配符 * ? 代表多个项。
echo.    提取的文件将置于临时文件夹。
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF

set "random1=%random%%random%"

if "%type.editor%"=="rar"  "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%"
