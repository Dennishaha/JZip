set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("请键入要取出的文件/夹："&vbCrLf&vbCrLf&"使用空格区分项以添加多个项，可用通配符*?。"&vbCrLf&"提取的文件将置于临时文件夹。","提示"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF

if "%type.editor%"=="rar"  "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%"
