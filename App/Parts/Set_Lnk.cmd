
::������
if /i "%1"=="-info" call :Lnk %1 all 
for %%A in (-on,-off) do if /i "%1"=="%%A" call :Lnk %1 %2
if /i "%1"=="-reon" (
	call :Lnk -on Programs
	if "%����ݾ�%"=="y" call :Lnk -on Desktop
	if "%�Ҽ��ݾ�%"=="y" call :Lnk -on SendTo
)
if /i "%1"=="-switch" (
	for %%A in (
		"��"/"-off"/"Desktop"/"����ݾ�"/""
		"��"/"-off"/"SendTo"/"�Ҽ��ݾ�"/""
		"��"/"-on"/"Desktop"/"����ݾ�"/"y"
		"��"/"-on"/"SendTo"/"�Ҽ��ݾ�"/"y"
	) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
		if /i "!tips.Lnk.%2!"=="%%~a" (
			if /i "%~2"=="%%~c" (
				call :Lnk %%~b %2
				set "%%~d=%%~e"
			)
		)
	)
	for %%a in (����ݾ�,�Ҽ��ݾ�) do (
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul
	)
)
goto :EOF

:Lnk
if /i not "%2"=="all" call :Lnk2 %1 %2
if /i "%2"=="all" for %%a in (Desktop,Programs,SendTo) do call :Lnk2 %1 %%a
goto :EOF

:Lnk2
for %%A in (
	"Desktop"/"Jzip ѹ��.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"Programs"/"Jzip ѹ��.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SendTo"/"Jzip - ��.lnk"/"%path.jzip.launcher%"/"list"/"view.ico"
	"SendTo"/"Jzip - ��ѹ���ļ���.lnk"/"%path.jzip.launcher%"/"unzip"/"unzip.ico"
	"SendTo"/"Jzip - ���ӵ�ѹ���ļ�.lnk"/"%path.jzip.launcher%"/"add"/"add.ico"
	"SendTo"/"Jzip - ���ӵ� .7z.lnk"/"%path.jzip.launcher%"/"add-7z"/"add.ico"
) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
	if /i "%1"=="-on" if /i "%2"=="%%~a" (
		1>"%dir.jzip.temp%\ink.vbs" (
			echo.Set WshShell = WScript.CreateObject^("WScript.Shell"^)
			echo.Set Ink = WshShell.CreateShortcut^(WshShell.SpecialFolders^("%%~a"^) ^& "\%%~b"^)
			echo.Ink.TargetPath = "%%~c"
			echo.Ink.Arguments = "%%~d"
			echo.Ink.WindowStyle = "1"
			echo.Ink.IconLocation = "%dir.jzip%\Components\Icon\%%~e"
			echo.Ink.Description = ""
			echo.Ink.WorkingDirectory = WshShell.SpecialFolders^("Desktop"^)
			echo.Ink.Save
		)
		cscript //nologo "%dir.jzip.temp%\ink.vbs"
	)
	if /i "%1"=="-off" if /i "%2"=="%%~a" (
		1>"%dir.jzip.temp%\ink.vbs" (
			echo.Set WshShell = WScript.CreateObject^("WScript.Shell"^)
			echo.Set fso = CreateObject^("Scripting.FileSystemObject"^)
			echo.fso.DeleteFile^(WshShell.SpecialFolders^("%%~a"^) ^& "\%%~b"^)
		)
		cscript //nologo "%dir.jzip.temp%\ink.vbs"
	)
	if /i "%1"=="-info" if /i "%2"=="%%~a" (
		1>"%dir.jzip.temp%\ink.vbs" (
			echo.Set WshShell = WScript.CreateObject^("WScript.Shell"^)
			echo.WSH.echo WshShell.SpecialFolders^("%%~a"^)
		)
		for /f "delims=" %%x in ('cscript //nologo "%dir.jzip.temp%\ink.vbs"') do (
			dir "%%~x\%%~b" /a:-d /b 1>nul 2>nul && set "tips.Lnk.%%~a=��" || set "tips.Lnk.%%~a=��"
		)
	)
)
goto :EOF
