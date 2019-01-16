::检测目前状态
reg query "HKEY_CLASSES_ROOT\JFsoft.Jzip" >nul 2>nul && set "tips.FileAssoc=●" || set "tips.FileAssoc=○"

::被调用
if "%1"=="-on" call :on
if "%1"=="-off" call :off
if /i "%1"=="-reon" (
	if "%文件关联%"=="y" call :on
)
if "%1"=="-switch" (
	if "%tips.FileAssoc%"=="●" call :off reg
	if "%tips.FileAssoc%"=="○" call :on reg
)
goto :EOF


:on
1>"%dir.jzip.temp%\Assoc.cmd" (
	echo.for %%^%%a in ^(%jzip.spt.open%^) do 1^>nul assoc .%%^%%a=JFsoft.Jzip
	echo.1^>nul ftype JFsoft.Jzip="%path.jzip.launcher%" %%^%%1
)
if "%1"=="reg" 1>>"%dir.jzip.temp%\Assoc.cmd" (
	echo.reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /v "文件关联" /d "y" /f ^>nul
)
goto :Assoc


:off
1>"%dir.jzip.temp%\Assoc.cmd" (
	echo.for %%^%%a in ^(%jzip.spt.open%^) do 1^>nul assoc .%%^%%a=
	echo.1^>nul ftype JFsoft.Jzip=
	echo.reg delete "HKEY_CLASSES_ROOT\JFsoft.Jzip" /f ^>nul
)
if "%1"=="reg" 1>>"%dir.jzip.temp%\Assoc.cmd" (
	echo.reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /v "文件关联" /d "" /f ^>nul
)
goto :Assoc


:Assoc
net session >nul 2>nul && call "%dir.jzip.temp%\Assoc.cmd"
net session >nul 2>nul || (
	1> "%dir.jzip.temp%\getadmin.vbs" (
		echo.Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/q /c call ""%dir.jzip.temp%\Assoc.cmd""", "", "runas", 1
	) && cscript //nologo "%dir.jzip.temp%\getadmin.vbs" && del /q /f /s "%dir.jzip.temp%\getadmin.vbs" >nul
	cls & ping localhost -n 2 >nul
)
del /q /f /s "%dir.jzip.temp%\Assoc.cmd" >nul
goto :EOF


