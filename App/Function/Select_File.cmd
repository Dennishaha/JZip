<!-- :
if "%~1"=="" echo, Missing parameters %%1. & pause & goto :EOF
set "%~1="
for /f "delims=" %%a in ('mshta "%~f0"') do set "%~1=%%~a"
goto :EOF
-->

<input type=file id=f />
<script>
f.click();
new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(f.value)[close()];
</script>