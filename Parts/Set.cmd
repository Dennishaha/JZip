
:more
title JFsoft Zip %jzip.ver% %processor_architecture%
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_FastEdit.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
call :查看器扩展 -info
cls
echo.
echo.  ^<  Jzip 设置                                                       [K] 卸载
echo.———————————————————————————————————————
echo.
echo.                [1] 右键菜单关联          %tips.Lnk.SendTo%
echo.                [2] 在桌面建立捷径        %tips.Lnk.Desktop%
echo.
echo.                [3] 界面颜色设定 ^>        %ui.word%(%ui.paper%)
echo.                [4] 快速编辑模式          %tips.FastEdit%
echo.                [5] 文件查看器扩展        %ui.查看器扩展%
echo.
echo.                    临时文件夹
echo.                    %dir.jzip.temp%
echo.                    [6]打开 [7]自定义 [8]恢复默认
echo.
echo.                [A] 检查更新
echo.                [B] 前往 Jzip 官方网站
echo.                [C] 关于 Jzip
echo.
echo.                [0] 基本选项
echo.
echo. 键入并回车以选择...
echo.-----------------------
%choice% /c:12345678abck0 /n
set "next=%errorlevel%"
if "%next%"=="1" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
if "%next%"=="2" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
if "%next%"=="3" call "%dir.jzip%\Parts\Set_UI.cmd"
if "%next%"=="4" call "%dir.jzip%\Parts\Set_FastEdit.cmd" -switch
if "%next%"=="5" call :查看器扩展 -switch
if "%next%"=="6" start "" "%dir.jzip.temp%"
if "%next%"=="7" call :临时文件夹
if "%next%"=="8" call :临时文件夹 default
if "%next%"=="9" call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
if "%next%"=="10" explorer "http://jfsoft.cc/jzip"
if "%next%"=="11" call :About_Jzip
if "%next%"=="12" call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
if "%next%"=="13" set "next=" & goto :EOF
goto :more

:临时文件夹
if "%~1"=="" set dir.jzip.temp.new=&set /p dir.jzip.temp.new=请键入新路径：
if "%~1"=="default" set dir.jzip.temp.new=%temp%\JFsoft\Jzip
del /q /f /s "%dir.jzip.temp%"& rd /q /s "%dir.jzip.temp%"
if not exist "%dir.jzip.temp.new%" md "%dir.jzip.temp.new%"
if exist "%dir.jzip.temp.new%" (set dir.jzip.temp=%dir.jzip.temp.new%) else (echo.抱歉，暂时无法设置该目录。&pause)
call "%dir.jzip%\Parts\Set_Refresh.cmd"
goto :EOF

:查看器扩展
if "%1"=="-info" if "%查看器扩展%"=="y" (set "ui.查看器扩展=●") else (set "ui.查看器扩展=○")
if "%1"=="-switch" (
	if "%查看器扩展%"=="" set "查看器扩展=y"
	if "%查看器扩展%"=="y" set "查看器扩展="
	call "%dir.jzip%\Parts\Set_Refresh.cmd"
	start "" cmd /c ""%path.jzip.launcher%" -setting" & Exit
)
goto :EOF

:About_Jzip
cls
more /e <"%dir.jzip%\Components\About.txt"
pause
goto :EOF
