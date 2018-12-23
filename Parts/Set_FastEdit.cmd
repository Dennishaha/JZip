
::检测目前状态
reg QUERY "HKEY_CURRENT_USER\Console" /t REG_DWORD /v QuickEdit | findstr "0x1" >nul && set "tips.FastEdit=●" || set "tips.FastEdit=○"

::被调用
if "%1"=="-on" call :on
if "%1"=="-off" call :off
if "%1"=="-switch" if "%tips.FastEdit%"=="●" (call :off & goto :next) else (call :on & goto :next)
goto :EOF

:on
reg add "HKEY_CURRENT_USER\Console" /t REG_DWORD /v QuickEdit /d 0x0000001 /f
goto :EOF

:off
reg add "HKEY_CURRENT_USER\Console" /t REG_DWORD /v QuickEdit /d 0x0000000 /f
goto :EOF

:next
start /i cmd /c "%path.jzip.launcher%" -setting
Exit