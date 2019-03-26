
(
	if not "!txt_edcode.%errorlevel%!"=="" (
		%msgbox% "!txt_edcode.%errorlevel%!"
	) else (
		%msgbox% "%txt_edcode% %errorlevel%"
	)
	exit /b %errorlevel%
)