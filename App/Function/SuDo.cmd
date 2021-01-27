

:: 导入 
@if /i "%~1"=="-import" (
	set sudo=call "%~0"
	goto :EOF
)

:: 调用 
@(
	setlocal enabledelayedexpansion
	set params=%*
	if defined params (
		set "params=!params:"=""!"
		set "params=!params:?=&!"
	)

	:: 当前权限判断
	@net session >nul 2>nul && (
		!params!
	) || (
		::取得管理员权限 
		mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%ComSpec%","/c call !params!","","runas",1^)^(window.close^)
	)
)

@endlocal & exit /b %errorlevel%


:: 以管理员身份运行命令
:: 
:: 用法
:: %sudo% command
:: %sudo% command1 ? command2