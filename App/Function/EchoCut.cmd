@echo off
setlocal disableDelayedExpansion

if "%~1"=="" exit /b
if "%~2"=="" exit /b
if "%~3"=="" exit /b

set "in=%~1"
set "out=%in%"
set "lim=%~3"

set "cuted="
set "space="

:: 参数处理 
if /i "%lim:~0,3%"=="equ" (
	set "lim=%lim:~3%"
	set "space=y"
)

if /i %lim% leq 0 exit /b

:cut 
call :strLen out len
if /i %len% gtr %lim% (
	set "out=%out:~3%"
	set "cuted=y"
	goto :cut
)

if "%space%"=="y" call :space

if /i %len% gtr %lim% set "out=%out:~0,-1%"

if "%cuted%"=="y" set "out=..%out:~2%"

endlocal & set "%~2=%out%"
exit /b


:space 
call :strLen out len
if /i %len% lss %lim% (
	set "out=%out%  "
	goto :space
)
exit /b


:: 获取文本字节大小 
:strLen  strVar  [rtnVar] 
set "len=0" & for /f "delims=:" %%N in ('"(cmd /v:on /c echo(!%~1!&echo()|findstr /o ^^"') do set /a "len=%%N-3"
set "%~2=%len%"
exit /b

