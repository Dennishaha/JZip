set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("�����Ҫȡ�����ļ�/�У�"&vbCrLf&vbCrLf&"ʹ�ÿո�����������Ӷ�������ͨ���*?��"&vbCrLf&"��ȡ���ļ���������ʱ�ļ��С�","��ʾ"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF

if "%type.editor%"=="rar"  "%path.editor.rar%" x -y "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% -y "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%"
