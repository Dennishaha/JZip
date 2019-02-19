
if not "!txt_edcode.%errorlevel%!"=="" (
	call "%dir.jzip%\Function\VbsBox" msgbox "!txt_edcode.%errorlevel%!"
) else (
	call "%dir.jzip%\Function\VbsBox" msgbox "%txt_edcode% %errorlevel%"
)
goto :EOF