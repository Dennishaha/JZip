
:: 导入
if /i "%~1"=="import" (
	set "MsgBox=call "%~0" MsgBox"
	set "MsgBox-s=call "%~0" MsgBox-s"
	set "InputBox=call "%~0" InputBox"
	goto :EOF
)

:: 调用
if /i "%~1"=="MsgBox" set "msgbox.t1="""""
for %%i in (MsgBox-s InputBox) do if /i "%~1"=="%%i" (
	set "msgbox.t1="""
	set "%~2="
)

:cycle
if /i "%~1"=="MsgBox" (
	if not "%~2"=="" (
		set "msgbox.t1=!msgbox.t1!&""%~2""&vbCrLf"
		shift /2
		goto :cycle
	)
)

for %%i in (MsgBox-s InputBox) do if /i "%~1"=="%%i" (
	if not "%~3"=="" (
		set "msgbox.t2=%~3"

		if "!msgbox.t2: =!"=="" (
			set "msgbox.t1=!msgbox.t1!&vbCrLf"
		) else (
			
			set "msgbox.t2=!msgbox.t2:&=`?`&Chr(38)&`?`!"
			set "msgbox.t2=!msgbox.t2: =`?`&Chr(32)&`?`!"
			set "msgbox.t2=!msgbox.t2:,=`?`&Chr(44)&`?`!"

			set "msgbox.t1=!msgbox.t1!&"!msgbox.t2!"&vbCrLf"
		)
		shift /3
		goto :cycle
	)
)
call :%*
goto :EOF


:MsgBox
mshta vbscript:execute^("msgbox(%msgbox.t1%,64,""%txt_tips%"")(close)"^)
goto :EOF


:MsgBox-s
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%msgbox.t1:`?`="%,1+64,"%txt_tips%"))(close)" ') do (
	set "%~1=%%a"
)
goto :EOF


:InputBox
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox(%msgbox.t1:`?`="%,"%txt_tips%"))(close)" ') do (
	set "%~1=%%~a"
)
goto :EOF