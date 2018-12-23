:refresh

dir "%appdata%\JFsoft\Jzip" /a:d /b 1>nul 2>nul || md "%appdata%\JFsoft\Jzip"

set InfoOut=%appdata%\JFsoft\Jzip\Setting.txt
1>"%InfoOut%" echo.
for %%a in (界面颜色,右键扩展,查看器扩展,dir.jzip.temp) do (
	1>>"%InfoOut%" echo.%%a;!%%a!
)

goto :EOF