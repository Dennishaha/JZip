
:: 导入 
if /i "%~1"=="-import" (
	set MsgBox=call "%~0" MsgBox
	set MsgBox-s=call "%~0" MsgBox-s
	set InputBox=call "%~0" InputBox
	set InputBox-r=call "%~0" InputBox-r
	goto :EOF
)

:: 调用 
set msgbox.restr=

if /i "%~1"=="MsgBox" set msgbox.t1=""""

if /i "%~1"=="InputBox-r" (
	set "msgbox.restr=%~3"
	call :replace msgbox.restr
	shift /3
)

for %%i in (MsgBox-s InputBox InputBox-r) do if /i "%~1"=="%%i" (
	set msgbox.t1=""
)

:cycle
if /i "%~1"=="MsgBox" (
	if not "%~2"=="" (
		set "msgbox.t1=!msgbox.t1!&""%~2""&vbCrLf"
		shift /2
		goto :cycle
	)
)

for %%i in (MsgBox-s InputBox InputBox-r) do if /i "%~1"=="%%i" (
	if not "%~3"=="" (
		set "msgbox.t2=%~3"

		if "!msgbox.t2: =!"=="" (
			set "msgbox.t1=!msgbox.t1!&vbCrLf"
		) else (
			call :replace msgbox.t2
			set "msgbox.t1=!msgbox.t1!&"!msgbox.t2!"&vbCrLf"
		)
		shift /3
		goto :cycle
	)
)

call :%*
goto :EOF


::执行 
:MsgBox
mshta vbscript:execute^("msgbox(%msgbox.t1%,64,""%txt_tips%"")(close)"^)

goto :EOF


:MsgBox-s
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:`?`="%,1+64,"%txt_tips%"))(close)"') do (
	set "%~1=%%a"
)
goto :EOF


:InputBox
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox(%msgbox.t1:`?`="%,"%txt_tips%"))(close)"') do (
	set "%~1=%%~a"
)
goto :EOF


:InputBox-r
if not defined msgbox.restr goto :InputBox
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox(%msgbox.t1:`?`="%,"%txt_tips%","%msgbox.restr:`?`="%"))(close)"') do (
	set "%~1=%%~a"
)
goto :EOF


::字符串替换调用 
:replace
if defined %~1 (
	set "%~1=!%~1:(=^(!"
	set "%~1=!%~1:)=^)!"
	set "%~1=!%~1:&=`?`&Chr(38)&`?`!"
	set "%~1=!%~1: =`?`&Chr(32)&`?`!"
	set "%~1=!%~1:,=`?`&Chr(44)&`?`!"
)
goto :EOF
