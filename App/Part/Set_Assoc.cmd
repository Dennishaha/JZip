
:: ���Ŀǰ״̬ 
reg query "HKCR\JFsoft.Jzip" >nul 2>nul && (
	set "stat.FileAssoc=%txt_sym.cir.s%"
) || (
	set "stat.FileAssoc=%txt_sym.cir%"
)

:: ���账��ĵ��� 
if "%~1"=="" exit /b
if /i "%~1"=="-info" exit /b
if /i "%~1"=="-off" if not "!stat.FileAssoc!"=="%txt_sym.cir.s%" exit /b
if /i "%~1"=="-reon" if /i not "%FileAssoc%"=="y" exit /b


:: ������ԱȨ��δ��� 
net session >nul 2>nul || (
	call %sudo% "%path.jzip.launcher%" -setting assoc %1
	if "!sudoback!"=="1" (exit /b) else (exit)
)

:: ������ 
if /i "%~1"=="-on" if "!stat.FileAssoc!"=="%txt_sym.cir%" call :on
if /i "%~1"=="-off" if "!stat.FileAssoc!"=="%txt_sym.cir.s%" call :off
if /i "%~1"=="-reon" if /i "%FileAssoc%"=="y" call :on 
if /i "%~1"=="-switch" (
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
	reg add "HKCU\Software\JFsoft.Jzip" /v "FileAssoc" /d "n" /f >nul
)
goto :EOF

