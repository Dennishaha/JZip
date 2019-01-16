
::检测目前状态
reg QUERY "HKCU\Console" /t REG_DWORD /v QuickEdit | findstr "0x1" >nul && set "tips.FastEdit=●" || set "tips.FastEdit=○"

::被调用
if "%1"=="-on" call :on
if "%1"=="-off" call :off
if "%1"=="-switch" (
	if "%tips.FastEdit%"=="●" call :off
	if "%tips.FastEdit%"=="○" call :on
	start /i cmd /c "%path.jzip.launcher%" -setting
	exit
)
goto :EOF

:on
reg add "HKCU\Console" /t REG_DWORD /v QuickEdit /d 0x0000001 /f
goto :EOF

:off
reg add "HKCU\Console" /t REG_DWORD /v QuickEdit /d 0x0000000 /f
goto :EOF