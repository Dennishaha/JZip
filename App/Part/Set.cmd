
:more
title %txt_title%
call "%dir.jzip%\Part\Set_Lnk.cmd" -info
call "%dir.jzip%\Part\Set_Assoc.cmd" -info
call "%dir.jzip%\Part\Set_UI.cmd" -info

cls
echo;
echo;  %txt_sym.back% %txt_setting%
echo;
echo;
echo;		%stat.FileAssoc% %txt_assoc%
echo;		%stat.Lnk.SendTo% %txt_rightmenu%
echo;		%stat.Lnk.Desktop% %txt_shortcut%
echo;
echo;		%txt_colorset%  ^>	%stat.color.wd% (%stat.color.bg%)
echo;
echo;		%txt_uiratio%   	%stat.uiratio%		[ + ] [ - ]
echo;
echo;		%txt_langset%  ^>	!txt_lang.%Language%!
echo;
echo;		%txt_workdir%
echo;		 %dir.jzip.temp%
%echo%;		%txt_b5.top%%txt_b5.top%%txt_b5.top%%txt_b5.top%
%echo%;		%txt_s.b.open%%txt_s.b.clean%%txt_s.b.ctm%%txt_s.b.def%
%echo%;		%txt_b5.bot%%txt_b5.bot%%txt_b5.bot%%txt_b5.bot%
echo;
if "%jzip.branches%"=="master" (
	echo;		%txt_version% !jzip.ver!
) else (
	echo;		%txt_version% !jzip.ver! !jzip.branches!
)
%echo%;		%txt_b6.top%%txt_b6.top%%txt_b6.top%
%echo%;		%txt_s.b.chk%%txt_s.b.bm%%txt_s.b.site% %txt_uninstall%
%echo%;		%txt_b6.bot%%txt_b6.bot%%txt_b6.bot%
echo;
%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	2}9}0}2}1}
	16}17}4}4}2}
	16}17}5}5}3}
	16}17}6}6}4}
	16}47}8}8}c}
	48}52}10}10}ui+}
	54}58}10}10}ui-}
	16}47}12}12}lang-s}
	17}24}16}18}w1}
	27}34}16}18}w2}
	37}44}16}18}w3}
	47}54}16}18}w4}
	17}26}21}23}ver}
	29}38}21}23}bm}
	41}50}21}23}web}
	53}62}22}22}rid}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"== "1" ( goto :EOF
) else if "%key%"== "2" ( call "%dir.jzip%\Part\Set_Assoc.cmd" -switch
) else if "%key%"== "3" ( call "%dir.jzip%\Part\Set_Lnk.cmd" -switch sendto
) else if "%key%"== "4" ( call "%dir.jzip%\Part\Set_Lnk.cmd" -switch desktop
) else if "%key%"== "c" ( call "%dir.jzip%\Part\Set_UI.cmd" color
) else if "%key%"== "ui+" ( call "%dir.jzip%\Part\Set_UI.cmd" uiratio +
) else if "%key%"== "ui-" ( call "%dir.jzip%\Part\Set_UI.cmd" uiratio -
) else if "%key%"== "w1" ( start "" "%dir.jzip.temp%"
) else if "%key%"== "w2" ( call :Temp_Clean
) else if "%key%"== "w3" ( call :Temp_Set
) else if "%key%"== "w4" ( call :Temp_Reset
) else if "%key%"== "lang-s" ( call :lang-s
) else if "%key%"== "ver" ( call "%dir.jzip%\Part\VerControl.cmd" -upgrade
) else if "%key%"== "bm" ( call :Benchmark
) else if "%key%"== "web" ( explorer "https://github.com/dennishaha/Jzip"
) else if "%key%"== "rid" ( call "%dir.jzip%\Part\VerControl.cmd" -uninstall
)
goto :more


:lang-s
if /i "%Language%"=="chs" chcp 437 >nul && (
	chcp 936 >nul
	%MsgBox-s% key "显示语言切换为%txt_lang.en%，JZip 将重新启动。"
	if "!key!"=="1" (
		call "%dir.jzip%\Part\Set_Lnk.cmd" -off all
		>nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Language" /d "en" /f
		start /i /min "" %ComSpec% /c call "%path.jzip.launcher%" -install
		exit 0
	)
) || (
	%MsgBox% "Jzip 切换该语言不成功。"
)
if /i "%Language%"=="en" chcp 936 >nul && (
	chcp 437 >nul
	%MsgBox-s% key "The display language switches to %txt_lang.chs% and JZip will restart."
	if "!key!"=="1" (
		call "%dir.jzip%\Part\Set_Lnk.cmd" -off all
		>nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Language" /d "chs" /f
		start /i /min "" %ComSpec% /c call "%path.jzip.launcher%" -install
		exit 0
	)
) || (
	%MsgBox% "Jzip switching the language was unsuccessful."
)
goto :EOF


:Temp_Clean
<nul set /p =".."

:: 注册表临时项清理 
reg delete "HKCU\Software\JFsoft.Jzip\Record\@" /f >nul 2>nul

:: 注册表临时文件夹清理 
if defined dir.jzip.temp >nul (
	rd /q /s "%dir.jzip.temp%"
	md "%dir.jzip.temp%"
) && (
	%msgbox% "%txt_s.clean.ok%"
) || (
	%msgbox% "%txt_s.clean.err%"
)
goto :EOF


:Temp_Set
call "%dir.jzip%\Function\Select_Folder.cmd" key
if not defined key goto :EOF

:: 空文件夹排除 
dir /a /b "%key%" | findstr .* >nul && (
	%msgbox% "%txt_s.need.emp%"
) || (
	set "dir.jzip.temp=!key!"
	reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
)
goto :EOF


:Temp_Reset
set "dir.jzip.temp=%dir.jzip.temp.default%"
md %dir.jzip.temp% >nul 2>nul
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
goto :EOF


:Benchmark
start "JFsoft.Jzip" %ComSpec% /d /c "mode 70,28 & color %color% & title & "%path.editor.7z%" b & echo. & echo.%txt_s.bm.ok% & %tmouse% /d 0 -1 1"
goto :EOF
