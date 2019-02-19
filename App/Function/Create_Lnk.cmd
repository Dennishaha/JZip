
:CreateLnk
1>"%dir.jzip.temp%\ink.vbs" (
	echo.Set WshShell = WScript.CreateObject^("WScript.Shell"^)
	echo.Set Ink = WshShell.CreateShortcut^("%~1"^)
	echo.Ink.TargetPath = "%~2"
	echo.Ink.Arguments = "%~3"
	echo.Ink.WindowStyle = "1"
	echo.Ink.IconLocation = "%dir.jzip%\Components\Icon\%~4"
	echo.Ink.WorkingDirectory = "%~5"
	echo.Ink.Description = "%~6"
	echo.Ink.Save
)
cscript //nologo "%dir.jzip.temp%\ink.vbs"
goto :EOF

:: 用法：%~0 "特殊文件夹" "捷径路径" "目标路径" "参数" "图标路径" "工作目录" "描述"