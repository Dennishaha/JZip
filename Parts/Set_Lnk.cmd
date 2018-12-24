
::适用于 Windows
set "dir.Desktop=%Userprofile%\Desktop"
set "dir.SMP=%appdata%\Microsoft\Windows\Start Menu\Programs"
set "dir.SendTo=%appdata%\Microsoft\Windows\SendTo"
::适用于 Windows NT5
ver|findstr /i /c:" 5." 1>nul 2>nul && (
	set "dir.SMP=%Userprofile%\Start Menu\Programs"
	set "dir.SendTo=%Userprofile%\SendTo"
)

::被调用
if /i "%1"=="-info" call :Lnk %1 all 
for %%A in (-on,-off) do if /i "%1"=="%%A" call :Lnk %1 %2
if /i "%1"=="-reon" call :Lnk -off all & call :Lnk -on all 
if /i "%1"=="-switch" if "!tips.Lnk.%2!"=="●" (call :Lnk -off %2) else (call :Lnk -on %2)
call "%dir.jzip%\Parts\Set_Refresh.cmd"
goto :EOF

:Lnk
if /i not "%2"=="all" call :Lnk2 %1 %2
if /i "%2"=="all" for %%a in (Desktop,SMP,SendTo) do call :Lnk2 %1 %%a
goto :EOF

:Lnk2
for %%A in (
	"Desktop"/"%dir.Desktop%\Jzip 压缩.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SMP"/"%dir.SMP%\Jzip 压缩.lnk"/"%path.jzip.launcher%"/""/"logo.ico"
	"SendTo"/"%dir.SendTo%\Jzip - 打开.lnk"/"%path.jzip.launcher%"/"list"/"view.ico"
	"SendTo"/"%dir.SendTo%\Jzip - 解压到文件夹.lnk"/"%path.jzip.launcher%"/"unzip"/"unzip.ico"
	"SendTo"/"%dir.SendTo%\Jzip - 添加到压缩文件.lnk"/"%path.jzip.launcher%"/"add"/"add.ico"
	"SendTo"/"%dir.SendTo%\Jzip - 添加到 .7z.lnk"/"%path.jzip.launcher%"/"add-7z"/"add.ico"
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
		dir "%%~b" /a:-d /b 1>nul 2>nul && set "tips.Lnk.%%~a=●" || set "tips.Lnk.%%~a=○"
	)
)
goto :EOF
