
::ÊÊÓÃÓÚ Windows
set "dir.Desktop=%Userprofile%\Desktop"
set "dir.SMP=%appdata%\Microsoft\Windows\Start Menu\Programs"
set "dir.SendTo=%appdata%\Microsoft\Windows\SendTo"
::ÊÊÓÃÓÚ Windows NT5
ver|findstr /i /c:" 5." 1>nul 2>nul && (
	set "dir.SMP=%Userprofile%\Start Menu\Programs"
	set "dir.SendTo=%Userprofile%\SendTo"
)

::±»µ÷ÓÃ
if /i "%1"=="-info" call :Lnk %1 all 
for %%A in (-on,-off) do if /i "%1"=="%%A" call :Lnk %1 %2
if /i "%1"=="-reon" (
	call :Lnk -on SMP
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
			call :Lnk %%~b %2
			if /i "%~2"=="%%~c" set "%%~d=%%~e"
		)
	)
	for %%a in (×ÀÃæ½Ý¾¶,ÓÒ¼ü½Ý¾¶) do (
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul
	)
)
goto :EOF

:Lnk
if /i not "%2"=="all" call :Lnk2 %1 %2
if /i "%2"=="all" for %%a in (Desktop,SMP,SendTo) do call :Lnk2 %1 %%a
goto :EOF

:Lnk2
for %%A in (
	"Desktop"/"%dir.Desktop%\Jzip Ñ¹Ëõ.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SMP"/"%dir.SMP%\Jzip Ñ¹Ëõ.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SendTo"/"%dir.SendTo%\Jzip - ´ò¿ª.lnk"/"%path.jzip.launcher%"/"list"/"view.ico"
	"SendTo"/"%dir.SendTo%\Jzip - ½âÑ¹µ½ÎÄ¼þ¼Ð.lnk"/"%path.jzip.launcher%"/"unzip"/"unzip.ico"
	"SendTo"/"%dir.SendTo%\Jzip - Ìí¼Óµ½Ñ¹ËõÎÄ¼þ.lnk"/"%path.jzip.launcher%"/"add"/"add.ico"
	"SendTo"/"%dir.SendTo%\Jzip - Ìí¼Óµ½ .7z.lnk"/"%path.jzip.launcher%"/"add-7z"/"add.ico"
) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
	if /i "%1"=="-on" if /i "%2"=="%%~a" (
		1>"%dir.jzip.temp%\ink.vbs" echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)
		1>>"%dir.jzip.temp%\ink.vbs" echo strDesktop = WshShell.SpecialFolders^("Desktop"^)
		1>>"%dir.jzip.temp%\ink.vbs" echo Set Ink = WshShell.CreateShortcut^("%%~b"^)
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.TargetPath = "%%~c"
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.Arguments = "%%~d"
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.WindowStyle = "1"
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.IconLocation = "%dir.jzip%\Components\Icon\%%~e"
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.Description = ""
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.WorkingDirectory = strDesktop
		1>>"%dir.jzip.temp%\ink.vbs" echo Ink.Save
		wscript -e:vbs "%dir.jzip.temp%\ink.vbs"
	)
	if /i "%1"=="-off" if /i "%2"=="%%~a" (
		del /q /f /s "%%~b" 1>nul 2>nul
	)
	if /i "%1"=="-info" if /i "%2"=="%%~a" (
		dir "%%~b" /a:-d /b 1>nul 2>nul && set "tips.Lnk.%%~a=¡ñ" || set "tips.Lnk.%%~a=¡ð"
	)
)
goto :EOF
