<!-- :
@echo off
set "key="
for /f "delims=" %%a in ('mshta "%~f0"') do set "key=%%~a"
goto :EOF
-->

<script>
var Shell = new ActiveXObject("Shell.Application");
var Folder = Shell.BrowseForFolder(0, "��ѡ���ļ���", 0); //��ʼĿ¼Ϊ������
if (Folder != null) {
	Folder = Folder.items();
	Folder = Folder.item();
	Folder = Folder.Path;
	new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(Folder)[window.close()];
} else {
	new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write("")[window.close()];
}
</script>
