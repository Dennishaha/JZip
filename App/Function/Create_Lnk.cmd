
:CreateLnk
1>"%dir.jzip.temp%\ink.vbs" (
	echo;Set WshShell = WScript.CreateObject^("WScript.Shell"^)
	echo;Set Ink = WshShell.CreateShortcut^("%~1"^)
	echo;Ink.TargetPath = "%~2"
	echo;Ink.Arguments = "%~3"
	echo;Ink.WindowStyle = "%~4"
	echo;Ink.IconLocation = "%dir.jzip%\Bin\Icon\%~5"
	echo;Ink.WorkingDirectory = "%~6"
	echo;Ink.Description = "%~7"
	echo;Ink.Save
)
cscript //nologo "%dir.jzip.temp%\ink.vbs"
goto :EOF

:: �÷���%~0 "�����ļ���" "�ݾ�·��" "Ŀ��·��" "����" "���ڴ�С" "ͼ��·��" "����Ŀ¼" "����"