::È¡µÃÌØÊâÎÄ¼þ¼Ð
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" 2^>nul') do (
	if /i "%%b"=="REG_EXPAND_SZ" (
		set "dir.%%a=%%~c"
		set "dir.%%a=!dir.%%a:%%USERPROFILE%%=%UserProFile%!"
	)
)

::±»µ÷ÓÃ
if /i "%1"=="-info" call :Lnk %1 all 
for %%A in (-on,-off) do if /i "%1"=="%%A" call :Lnk %1 %2
if /i "%1"=="-reon" (
	call :Lnk -on Programs
	if "%×ÀÃæ½Ý¾¶%"=="y" call :Lnk -on Desktop
	if "%ÓÒ¼ü½Ý¾¶%"=="y" call :Lnk -on SendTo
)
if /i "%1"=="-switch" (
	for %%A in (
		"¡ñ"/"-off"/"Desktop"/"×ÀÃæ½Ý¾¶"/""
		"¡ñ"/"-off"/"SendTo"/"ÓÒ¼ü½Ý¾¶"/""
		"¡ð"/"-on"/"Desktop"/"×ÀÃæ½Ý¾¶"/"y"
		"¡ð"/"-on"/"SendTo"/"ÓÒ¼ü½Ý¾¶"/"y"
	) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
		if /i "!tips.Lnk.%2!"=="%%~a" (
			if /i "%~2"=="%%~c" (
				call :Lnk %%~b %2
				set "%%~d=%%~e"
			)
		)
	)
	for %%a in (×ÀÃæ½Ý¾¶,ÓÒ¼ü½Ý¾¶) do (
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
	"Desktop"/"Jzip Ñ¹Ëõ.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"Programs"/"Jzip Ñ¹Ëõ.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SendTo"/"Jzip - ´ò¿ª.lnk"/"%path.jzip.launcher%"/"list"/"view.ico"
	"SendTo"/"Jzip - ½âÑ¹µ½ÎÄ¼þ¼Ð.lnk"/"%path.jzip.launcher%"/"unzip"/"unzip.ico"
	"SendTo"/"Jzip - Ìí¼Óµ½Ñ¹ËõÎÄ¼þ.lnk"/"%path.jzip.launcher%"/"add"/"add.ico"
	"SendTo"/"Jzip - Ìí¼Óµ½ .7z.lnk"/"%path.jzip.launcher%"/"add-7z"/"add.ico"
) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
	if /i "%2"=="%%~a" (
		if /i "%1"=="-on" call :CreateLnk %%a %%b %%c %%d %%e
		if /i "%1"=="-off" del /q /f /s "!dir.%%~a!\%%~b" >nul 2>nul
		if /i "%1"=="-info" dir "!dir.%%~a!\%%~b" /a:-d /b >nul 2>nul && set "tips.Lnk.%%~a=¡ñ" || set "tips.Lnk.%%~a=¡ð"
	)
)
goto :EOF

:CreateLnk
1>"%dir.jzip.temp%\ink.vbs" (
	echo.Set WshShell = WScript.CreateObject^("WScript.Shell"^)
	echo.Set Ink = WshShell.CreateShortcut^("!dir.%~1!\%~2"^)
	echo.Ink.TargetPath = "%~3"
	echo.Ink.Arguments = "%~4"
	echo.Ink.WindowStyle = "1"
	echo.Ink.IconLocation = "%dir.jzip%\Components\Icon\%~5"
	echo.Ink.Description = ""
	echo.Ink.WorkingDirectory = "!dir.Desktop!"
	echo.Ink.Save
)
cscript //nologo "%dir.jzip.temp%\ink.vbs"
goto :EOF
