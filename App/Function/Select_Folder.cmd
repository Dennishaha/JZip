
<!-- :
if "%~1"=="" echo; Missing parameters %%1. & pause & goto :EOF
set "%~1="
for /f "delims=" %%a in ('mshta "%~f0"') do set "%~1=%%~a"
if not defined %~1 goto :EOF

:: GUID 文件夹排除 
if "!%~1:~0,3!"=="::{" (
	%msgbox% "%txt_s.fold_invalid%"
	set "%~1="
)
goto :EOF
-->

<script>
var Shell = new ActiveXObject("Shell.Application");
var Folder = Shell.BrowseForFolder(0, "", 0); //起始目录为：桌面 
new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(Folder ? Folder.Self.Path : "")[close()];
</script>
