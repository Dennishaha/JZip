::检测目前状态
ftype JFsoft.Jzip | findstr "^JFsoft.Jzip" >nul 2>nul && set "tips.FileAssoc=●" || set "tips.FileAssoc=○"

::被调用
if "%1"=="-on" call :on
if "%1"=="-off" call :off
if /i "%1"=="-reon" (
	if "%文件关联%"=="y" call :on
)
if "%1"=="-switch" (
	if "%tips.FileAssoc%"=="●" call :off
	if "%tips.FileAssoc%"=="○" call :on
)
goto :EOF


:on
net session >nul 2>nul && (
	for %%a in (%jzip.spt.open%) do 1>nul assoc .%%a=JFsoft.Jzip
	1>nul ftype JFsoft.Jzip="%path.jzip.launcher%" %%1
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /v "文件关联" /d "y" /f >nul
)
net session >nul 2>nul || (
	1> "%dir.jzip.temp%\getadmin.vbs" (
		echo.Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/q /c for %%a in (%jzip.spt.open%) do assoc .%%a=JFsoft.Jzip& ftype JFsoft.Jzip=""%path.jzip.launcher%"" %%1& reg add ""HKEY_CURRENT_USER\Software\JFsoft.Jzip"" /v ""文件关联"" /d ""y"" /f ", "", "runas", 1
		echo.Set fso = CreateObject^("Scripting.FileSystemObject"^) : fso.DeleteFile^(WScript.ScriptFullName^)
		)
	) && "%dir.jzip.temp%\getadmin.vbs"
)
goto :EOF


:off
net session >nul 2>nul && (
	for %%a in (%jzip.spt.open%) do 1>nul assoc .%%a=
	1>nul ftype JFsoft.Jzip=
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /v "文件关联" /d "" /f >nul
)
net session >nul 2>nul || (
	1> "%dir.jzip.temp%\getadmin.vbs" (
		echo.Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/q /c for %%a in (%jzip.spt.open%) do assoc .%%a=& ftype JFsoft.Jzip=& reg add ""HKEY_CURRENT_USER\Software\JFsoft.Jzip"" /v ""文件关联"" /d """" /f ", "", "runas", 1
		echo.Set fso = CreateObject^("Scripting.FileSystemObject"^) : fso.DeleteFile^(WScript.ScriptFullName^)
		)
	) && "%dir.jzip.temp%\getadmin.vbs"
)
goto :EOF

