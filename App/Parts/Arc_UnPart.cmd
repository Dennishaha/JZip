echo.
echo. �����Ҫȡ�����ļ�(��)��
echo.
echo. ע��ʹ�� �ո� ����������Ӷ���
echo.    ͨ��� * ? �������
echo.    ��ȡ���ļ���������ʱ�ļ��С�
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF

set "random1=%random%%random%"

if "%type.editor%"=="rar"  "%path.editor.rar%" x "%path.Archive%" "%Archive.file%" %dir.jzip.temp%\%random1%\ %iferror%
if "%type.editor%"=="7z"  "%path.editor.7z%" x -o%dir.jzip.temp%\%random1% "%path.Archive%" "%Archive.file%" %iferror%

start "" "%dir.jzip.temp%\%random1%"
