
:: 检测目前状态 
reg query "HKCR\JFsoft.Jzip" >nul 2>nul && (
	set "stat.FileAssoc=%txt_sym.cir.s%"
) || (
	set "stat.FileAssoc=%txt_sym.cir%"
)
if “%~1”==“” exit /b
if “%~1”==“-info” exit /b

:: 若没有管理员权限 
net session >nul 2>nul || (
	call %sudo% "%path.jzip.launcher%" -setting assoc %1
	if "!sudoback!"=="1" (exit /b) else (exit)
)

:: 被调用 
if "%~1"=="-on" if "!stat.FileAssoc!"=="%txt_sym.cir%" call :on
if "%~1"=="-off" if "!stat.FileAssoc!"=="%txt_sym.cir.s%" call :off
if /i "%~1"=="-reon" (
	if "%FileAssoc%"=="y" call :on
)
if "%~1"=="-switch" (
	if "%stat.FileAssoc%"=="%txt_sym.cir.s%" call :off reg
	if "%stat.FileAssoc%"=="%txt_sym.cir%" call :on reg
)
goto :EOF


:on
for %%a in (%jzip.spt.assoc%) do 1>nul assoc .%%a=JFsoft.Jzip
>nul ftype JFsoft.Jzip="%path.jzip.launcher%" list "%%1"

if "%~1"=="reg" (
	reg add "HKCU\Software\JFsoft.Jzip" /v "FileAssoc" /d "y" /f >nul
)
goto :EOF


:off
for %%a in (%jzip.spt.open%) do 1>nul assoc .%%a=
>nul ftype JFsoft.Jzip=
reg delete "HKCR\JFsoft.Jzip" /f >nul

if "%~1"=="reg" (
	reg add "HKCU\Software\JFsoft.Jzip" /v "FileAssoc" /d "" /f >nul
)
goto :EOF





