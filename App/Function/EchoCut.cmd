@echo off
setlocal disableDelayedExpansion

if "%~1"=="" exit /b
if "%~2"=="" exit /b
if "%~3"=="" exit /b

set "in=%~1"
set "out=%in%"
set "lim=%~3"

if /i %lim% leq 0 exit /b

:loop
call :strLen out len
if /i %len% gtr %lim% (
	set "out=%out:~3%"
	goto :loop
)

:loop2
call :strLen out len
if /i %len% lss %lim% (
	set "out=%out%  "
	goto :loop2
)

if /i %len% gtr %lim% set "out=%out:~0,-1%"

::echo;len=%len%
::echo;%out%

endlocal & set "%~2=%out%"
exit /b


:strLen  strVar  [rtnVar]
setlocal
set "len=0" & for /f "delims=:" %%N in ('"(cmd /v:on /c echo(!%~1!&echo()|findstr /o ^^"') do set /a "len=%%N-3"
endlocal & set "%~2=%len%"
exit /b

