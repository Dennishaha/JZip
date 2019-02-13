<!-- :
if "%~1"=="" echo,È±ÉÙ²ÎÊý%%1¡£& pause
set "%~1="
for /f "delims=" %%a in ('mshta "%~f0"') do set "%~1=%%~a"
goto :EOF
-->

<input type=file id=f />
<script>
f.click();
new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(f.value)[window.close()];
</script>