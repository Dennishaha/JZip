
:: 调用
if /i "%~1"=="MsgBox" set "ui.msgbox="""""
for %%i in (MsgBox-s InputBox) do if /i "%~1"=="%%i" set "ui.msgbox="""

:cycle
if /i "%~1"=="MsgBox" (
	if not "%~2"=="" (
		set "ui.msgbox=!ui.msgbox!&""%~2""&vbCrLf"
		shift /2
		goto :cycle
	)
)

for %%i in (MsgBox-s InputBox) do if /i "%~1"=="%%i" (
	if not "%~3"=="" (
		set "ui.msgbox.t=%~3"
		set "ui.msgbox.t=!ui.msgbox.t:&=?&Chr(38)&?!"
		set "ui.msgbox.t=!ui.msgbox.t: =?&Chr(32)&?!"
		set "ui.msgbox.t=!ui.msgbox.t:,=?&Chr(44)&?!"

		set "ui.msgbox=!ui.msgbox!&"!ui.msgbox.t!"&vbCrLf"
		shift /3
		goto :cycle
	)
)
call :%*
goto :EOF


:MsgBox
mshta vbscript:execute^("msgbox(%ui.msgbox%,64,""提示"")(window.close)"^)
goto :EOF


:MsgBox-s
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox(%ui.msgbox:?="%,1+64,"提示"))(window.close)" ') do (
	set "%~1=%%a"
)
goto :EOF


:InputBox
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox(%ui.msgbox:?="%,"提示"))(window.close)" ') do (
	set "%~1=%%~a"
)
goto :EOF