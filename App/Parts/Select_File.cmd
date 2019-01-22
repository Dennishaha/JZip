<!-- :
@echo off
set "key="
for /f "delims=" %%a in ('mshta "%~f0"') do set "key=%%~a"
goto :EOF
-->

<input type=file id=f />
<script>
f.click();
new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(f.value)[window.close()];
</script>