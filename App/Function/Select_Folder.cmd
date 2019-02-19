<!-- :
if "%~1"=="" echo, Missing parameters %%1. & pause & goto :EOF
set "%~1="
for /f "delims=" %%a in ('mshta "%~f0"') do set "%~1=%%~a"
goto :EOF
-->

<script>
var Shell = new ActiveXObject("Shell.Application");
var Folder = Shell.BrowseForFolder(0, "", 0); //起始目录为：桌面
new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(Folder ? Folder.Self.Path : "")[window.close()];
</script>
