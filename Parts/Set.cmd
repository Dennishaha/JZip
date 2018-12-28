
:more
title JFsoft Zip 压缩
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_FastEdit.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
call :查看器扩展 -info
cls
echo.
echo.  ^<  Jzip 设置                                                       [K] 卸载
echo.———————————————————————————————————————
echo.
echo.                [1] %tips.Lnk.SendTo% 右键菜单关联          
echo.                [2] %tips.Lnk.Desktop% 在桌面建立捷径        
echo.
echo.                [3]    界面颜色设定 ^>   %ui.word%(%ui.paper%)
echo.                [4] %tips.FastEdit% 快速编辑模式          
echo.                [5] %ui.查看器扩展% 文件查看器扩展        
echo.
echo.                    临时文件夹
echo.                    %dir.jzip.temp%
echo.                    [6]打开 [7]自定义 [8]恢复默认
echo.
echo.                [A] 检查更新
echo.                [B] 前往 Jzip 官网
echo.                [C] 关于 Jzip %jzip.ver%
echo.
echo.                [0] 基本选项
echo.
echo. 键入并回车以选择...
echo.-----------------------
%choice% /c:12345678abck0 /n
set "key=%errorlevel%"
if "%key%"=="1" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
if "%key%"=="2" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
if "%key%"=="3" call "%dir.jzip%\Parts\Set_UI.cmd"
if "%key%"=="4" call "%dir.jzip%\Parts\Set_FastEdit.cmd" -switch
if "%key%"=="5" call :查看器扩展 -switch
if "%key%"=="6" start "" "%dir.jzip.temp%"
if "%key%"=="7" call :临时文件夹
if "%key%"=="8" call :临时文件夹 default
if "%key%"=="9" call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
if "%key%"=="10" explorer "http://jfsoft.cc/jzip"
if "%key%"=="11" call :About_Jzip
if "%key%"=="12" call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
if "%key%"=="13" set "key=" & goto :EOF
goto :more

:临时文件夹
if "%~1"=="default" set dir.jzip.temp.new=%temp%\JFsoft\Jzip
if "%~1"=="" set dir.jzip.temp.new=&set /p dir.jzip.temp.new=请键入新路径：
md "%dir.jzip.temp.new%" && (
	set dir.jzip.temp=%dir.jzip.temp.new%
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f 1>nul
	rd /q /s "%dir.jzip.temp%"
) || (
	pause 1>nul
)
goto :EOF

:查看器扩展
if "%1"=="-info" if "%查看器扩展%"=="y" (set "ui.查看器扩展=●") else (set "ui.查看器扩展=○")
if "%1"=="-switch" (
	if "%查看器扩展%"=="" set "查看器扩展=y"
	if "%查看器扩展%"=="y" set "查看器扩展="
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "查看器扩展" /d "!查看器扩展!" /f 1>nul
	start "" cmd /c ""%path.jzip.launcher%" -setting" & Exit
)
goto :EOF

:About_Jzip
cls
more /e <"%dir.jzip%\Components\About.txt"
pause
goto :EOF
