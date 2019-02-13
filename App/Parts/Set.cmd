
:more
title JFsoft Zip 压缩
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_Assoc.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
cls
echo.
echo.  《 设置
echo.
echo.
echo.                    %tips.FileAssoc% 压缩文件关联
echo.                    %tips.Lnk.SendTo% 右键菜单扩展
echo.                    %tips.Lnk.Desktop% 在桌面建立捷径
echo.
echo.                    设定颜色 ^>       %ui.word%(%ui.paper%)
echo.
echo.                    工作目录
echo.                      %dir.jzip.temp%
%echo%.                    ┌───┐┌───┐┌───┐┌───┐
%echo%.                    │ 打开 ││ 清除 ││自定义││ 默认 │
%echo%.                    └───┘└───┘└───┘└───┘
echo.
echo.                    版本 %jzip.ver%
%echo%.                    ┌────┐┌────┐
%echo%.                    │检查更新││前往官网│ 卸载
%echo%.                    └────┘└────┘
echo.
echo.
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	2}9}0}2}1}
	20}21}4}4}2}
	20}21}5}5}3}
	20}21}6}6}4}
	20}47}8}8}c}
	21}28}12}14}w1}
	31}38}12}14}w2}
	41}48}12}14}w3}
	51}58}12}14}w4}
	21}30}17}19}ver}
	33}42}17}19}web}
	45}48}18}18}rid}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"== "1" ( goto :EOF
) else if "%key%"== "2" ( call "%dir.jzip%\Parts\Set_Assoc.cmd" -switch
) else if "%key%"== "3" ( call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
) else if "%key%"== "4" ( call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
) else if "%key%"== "c" ( call "%dir.jzip%\Parts\Set_UI.cmd"
) else if "%key%"== "w1" ( start "" "%dir.jzip.temp%"
) else if "%key%"== "w2" ( call :清除Temp
) else if "%key%"== "w3" ( call :自定义Temp
) else if "%key%"== "w4" ( call :默认Temp
) else if "%key%"== "ver" ( call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
) else if "%key%"== "web" ( explorer "https://github.com/dennishaha/Jzip"
) else if "%key%"== "rid" ( call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
)
goto :more


:清除Temp
if defined dir.jzip.temp >nul (
	rd /q /s "%dir.jzip.temp%"
	md "%dir.jzip.temp%"
) && (
	call "%dir.jzip%\Function\VbsBox" msgbox "临时文件清除完成。"
) || (
	call "%dir.jzip%\Function\VbsBox" msgbox "清除临时文件出现问题，请稍后重试。"
)
goto :EOF


:自定义Temp
call "%dir.jzip%\Function\Select_Folder.cmd" key
if not defined key goto :EOF
dir /a /b "!key!" | findstr .* >nul && (
	call "%dir.jzip%\Function\VbsBox" msgbox "请选择个空的文件夹，再试一次。"
	goto :临时文件夹
)
dir /a /b "!key!" | findstr .* >nul || (
	set "dir.jzip.temp=!key!"
	reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
)
goto :EOF


:默认Temp
set "dir.jzip.temp=%temp%\JFsoft.Jzip"
md %dir.jzip.temp% >nul 2>nul
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
goto :EOF


