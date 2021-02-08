

:: 导入 
@if /i "%~1"=="-import" (
	set sudo=call "%~0"
	goto :EOF
)

:: 调用 
@(
	set params=%*
	if defined params (
		set "params=!params:'=''!"
		set "params=!params:"="""!"
		set "params=!params:?=&!"
	)

	:: 当前权限判断
	@net session >nul 2>nul && (
		!params!
	) || (
		:: 取得管理员权限 
		powershell -noprofile -command "&{ start-process %ComSpec% -ArgumentList '/c call !params!' -verb RunAs}" 2>&1 | findstr "." && set "sudoback=1" || set "sudoback=0"
	) >nul 2>nul
)

set params=
exit /b

:: 以管理员身份运行命令
:: 
:: 用法
:: %sudo% command
:: %sudo% command1 ? command2