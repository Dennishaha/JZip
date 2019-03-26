
@(
	setlocal enabledelayedexpansion
	set "echo.tmp=%*"
	set "echo.tmp=!echo.tmp:%txt_tabs.1%=%txt_tabs.1.r%!"
	set "echo.tmp=!echo.tmp:%txt_tabs.2%=%txt_tabs.2.r%!"
	set "echo.tmp=!echo.tmp:%txt_tabs.3%=%txt_tabs.3.r%!"
	set "echo.tmp=!echo.tmp:%txt_tabs.4%=%txt_tabs.4.r%!"
	set "echo.tmp=!echo.tmp:%txt_tabs.5%=%txt_tabs.5.r%!"
	set "echo.tmp=!echo.tmp:%txt_tabs.6%=%txt_tabs.6.r%!"
	echo!echo.tmp!
	endlocal
)