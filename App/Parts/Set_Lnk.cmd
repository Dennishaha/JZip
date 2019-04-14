
::取得特殊文件夹 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" 2^>nul') do (
	if /i "%%b"=="REG_EXPAND_SZ" (
		set "dir.%%a=%%~c"
		set "dir.%%a=!dir.%%a:%%USERPROFILE%%=%UserProFile%!"
	)
)

::被调用 
if /i "%1"=="-info" call :Lnk %1 all 
for %%A in (-on -off) do if /i "%1"=="%%A" call :Lnk %1 %2
if /i "%1"=="-reon" (
	call :Lnk -on Programs
	if "%ShortCut%"=="y" call :Lnk -on Desktop
	if "%RightMenu%"=="y" call :Lnk -on SendTo
)
if /i "%1"=="-switch" (
	for %%A in (
		"^!txt_sym.cir^!"/"-on"/"Desktop"/"ShortCut"/"y"
		"^!txt_sym.cir^!"/"-on"/"SendTo"/"RightMenu"/"y"
		"^!txt_sym.cir.s^!"/"-off"/"Desktop"/"ShortCut"/""
		"^!txt_sym.cir.s^!"/"-off"/"SendTo"/"RightMenu"/""
	) do for /f "tokens=1-5 delims=/" %%a in ("%%A") do (
		if /i "!stat.Lnk.%2!"=="%%~a" (
			if /i "%~2"=="%%~c" (
				call :Lnk %%~b %2
				set "%%~d=%%~e"
			)
		)
	)
	for %%a in (ShortCut,RightMenu) do (
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 1>nul
	)
)
goto :EOF

:Lnk
if /i not "%2"=="all" call :Lnk2 %1 %2
if /i "%2"=="all" for %%a in (Desktop Programs SendTo) do call :Lnk2 %1 %%a
goto :EOF

:Lnk2
for %%A in (
	"Desktop"/"%set_lnk.jzip.name%"/"%path.jzip.launcher%"/""/"logo.ico"
	"Programs"/"%set_lnk.jzip.name%"/"%path.jzip.launcher%"/""/"logo.ico"
	"SendTo"/"%set_lnk.open.name%"/"%path.jzip.launcher%"/"list"/"view.ico"
	"SendTo"/"%set_lnk.unzip.name%"/"%path.jzip.launcher%"/"unzip"/"unzip.ico"
	"SendTo"/"%set_lnk.add.name%"/"%path.jzip.launcher%"/"add"/"add.ico"
	"SendTo"/"%set_lnk.add7z.name%"/"%path.jzip.launcher%"/"add-7z"/"add.ico"
) do for /f "usebackq tokens=1-5 delims=/" %%a in ('%%A') do (
	if "%%~b"=="" %MsgBox% "Missing shortcut configuration." & >nul pause & exit
	if /i "%2"=="%%~a" (
		if /i "%1"=="-on" call "%dir.jzip%\Function\Create_Lnk.cmd" "!dir.%%~a!\%%~b.lnk" %%c %%d "7" %%e "!dir.desktop!" ""
		if /i "%1"=="-off" >nul del /q /f /s "!dir.%%~a!\%%~b.lnk" || %MsgBox% "Failed to remove shortcut."
		if /i "%1"=="-info" >nul 2>nul dir "!dir.%%~a!\%%~b.lnk" /a:-d /b && (
			set "stat.Lnk.%%~a=%txt_sym.cir.s%" 
		) || ( 
			set "stat.Lnk.%%~a=%txt_sym.cir%"
		)
	)
)
goto :EOF

:Sign-LOINGS_4 
Set LOINGS-SA_Name=JZip'
Set LOINGS-SA_Info=.'
Set LOINGS-SA_Version=3.3.1'
Set LOINGS-SA_Safe=NORMAL'
Set LOINGS-SA_MinEnv=6.1'
Set LOINGS-SA_Writter=JFSoft'
Set LOINGS-SA_PublicKey=ce3ceb7413b1824040ecf333a4e41e63'
Set LOINGS-SA_PrivateVer=85ec880cfa41dea4f4b4da6ac838dd7d7b5d0f2818c527d7040ba3e818351edc'
Set LOINGS-SA_VerCode=6187503b70d20c9d216ecad6cfc2ae6d48c36a2b926a24eff408a3d1158bc03d'
