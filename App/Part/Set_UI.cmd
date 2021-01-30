
::调用判断 
if "%~1"=="-info" (
	if /i "%ColorAuto%"=="y" (
		set "stat.color=%txt_color.auto%"
	) else (
		set "stat.color=!txt_color.%color:~1,1%! (!txt_color.%color:~0,1%!)"
		if /i "%Color%"=="f0" set "stat.color=%txt_color.light%"
		if /i "%Color%"=="0f" set "stat.color=%txt_color.dark%"
	)
	set "stat.uiratio=!txt_uiratio.%UIRatio%!"
)
for %%i in (color uiratio) do if "%~1"=="%%i" call :%*
goto :eof


:color
if not defined ui.mouse set "ui.mouse=wd"

setlocal

:: 自定义部分配置 
for %%i in (0 1 2 3 4 5 6 7 8 9 a b c d e f) do (
	set "ui_c.%%i=  !txt_color.%%i!  "
	if /i "%color:~1,1%"=="%%i" set "ui_c.%%i=[ !txt_color.%%i! ]"
	if /i "%color:~0,1%"=="%%i" set "ui_c.%%i=# !txt_color.%%i! #"
)

:: 深浅色模式选择配置 
for %%i in (light dark auto) do set "ui_c.%%i=  !txt_color.%%i!  "
if /i "%ColorAuto%"=="y" (
	set "ui_c.auto=[ %txt_color.auto% ]"
) else (
	if /i "%Color%"=="f0" set "ui_c.light=[ %txt_color.light% ]"
	if /i "%Color%"=="0f" set "ui_c.dark=[ %txt_color.dark% ]"
)

:: 若系统不支持自动配置
>nul 2>nul reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" || set "ui_c.auto=	"

cls

echo;
echo;
echo;     %txt_color.title%
echo;
echo;
if "%ui.mouse%"=="wd" (
%echo%;				    %txt_color.tip%  [ !txt_color.wd! ]	 !txt_color.swd!
)
if "%ui.mouse%"=="bg" (
%echo%;				    %txt_color.tip%  # !txt_color.bg! #	 !txt_color.sbg!
)
echo;
echo;
%echo%;			    %txt_tabs.2%
%echo%;			    %txt_tabs.2%    %ui_c.0%   %ui_c.8%  %ui_c.7%    %ui_c.f%
%echo%;	 %ui_c.light%	    %txt_tabs.2%
%echo%;			    %txt_tabs.2%
%echo%;			    %txt_tabs.2%    %ui_c.4%    %ui_c.5%   %ui_c.c%   %ui_c.d%
%echo%;	 %ui_c.dark% 	    %txt_tabs.2%
%echo%;			    %txt_tabs.2%
%echo%;			    %txt_tabs.2%    %ui_c.6%    %ui_c.1%   %ui_c.e%   %ui_c.9%
%echo%;	 %ui_c.auto% 	    %txt_tabs.2%
%echo%;		   	    %txt_tabs.2%
%echo%;			    %txt_tabs.2%    %ui_c.2%    %ui_c.3%   %ui_c.a%   %ui_c.b%
%echo%;			    %txt_tabs.2%
echo;
echo;
echo;
%echo%;								%txt_b7.top%
%echo%;								%txt_b7.finish%
%echo%;								%txt_b7.bot%

endlocal

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	65}74}23}25}back}
	57}68}5}5}switch}

	9}22}10}10}lm}
	9}22}13}13}dm}
	9}22}16}16}auto}

	34}40}9}9}0}
	34}40}12}12}4}
	34}40}15}15}6}
	34}40}18}18}2}

	43}51}9}9}8}
	43}51}12}12}5}
	43}51}15}15}1}
	43}51}18}18}3}

	53}61}9}9}7}
	53}61}12}12}c}
	53}61}15}15}e}
	53}61}18}18}a}

	64}72}9}9}f}
	64}72}12}12}d}
	64}72}15}15}9}
	64}72}18}18}b}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d (set "key=%%~e")
	)
)

if "%key%"=="switch" (
	if "%ui.mouse%"=="wd" (set "ui.mouse=bg") else (set "ui.mouse=wd")
)
if "%key%"=="back" goto :EOF

if not defined key goto :color

:: 颜色选择 
for %%i in (0 1 2 3 4 5 6 7 8 9 a b c d e f) do (
	if "%key%"=="%%i" (
		if "%ui.mouse%"=="wd" if "%Color:~0,1%"=="%%i" (
				set "Color=%Color:~1,1%%%i"
			) else (
				set "Color=%color:~0,1%%%i"
			)
		if "%ui.mouse%"=="bg" if "%Color:~1,1%"=="%%i" (
				set "Color=%%i%Color:~0,1%"
			) else (
				set "Color=%%i%Color:~1,1%"
			)
		set "ColorAuto=n"
	)
)

:: 模式切换 
if "%key%"=="lm" set "ColorAuto=n" & set "Color=f0" 
if "%key%"=="dm" set "ColorAuto=n" & set "Color=0f"
if "%key%"=="auto" (
	for /f "skip=2 tokens=3" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" 2^>nul') do (
		(echo;"%%~a" | find "0x" >nul) && set "ColorAuto=y" || set "ColorAuto=n"
		if "!ColorAuto!"=="y" (echo;"%%~a" | find "0x0" >nul) && set "Color=0f" || set "Color=f0"
	)
)

:: 更新颜色和注册表 
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Color" /d "%Color%" /f >nul
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "ColorAuto" /d "%ColorAuto%" /f >nul
cls & color %Color%

:: 模式切换则退出 
for %%i in (lm dm auto) do if "%key%"=="%%i" exit /b

goto :color


:uiratio
for %%A in (
	s/s/m
	m/s/l
	l/m/l
) do for /f "tokens=1-3 delims=/" %%a in ("%%A") do if /i "%uiratio%"=="%%a" (
	if "%~1"=="-" set "UIRatio=%%b"
	if "%~1"=="+" set "UIRatio=%%c"
	if not "!UIRatio!"=="%%a" (
		reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "UIRatio" /d "!UIRatio!" /f >nul
		start /i /min "" %ComSpec% /c call "%path.jzip.launcher%" -setting
		exit 0
	)
)
goto :EOF

