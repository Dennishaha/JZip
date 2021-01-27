
::µ÷ÓÃÅÐ¶Ï 
if "%~1"=="-info" (
	set "stat.color.wd=!txt_color.%color:~1,1%!"
	set "stat.color.bg=!txt_color.%color:~0,1%!"
	set "stat.uiratio=!txt_uiratio.%UIRatio%!"
)
for %%i in (color uiratio) do if "%~1"=="%%i" call :%*
goto :eof


:color
if not defined ui.mouse set "ui.mouse=word"
color %Color%
cls

echo;
echo;   %txt_color.title%
echo;
echo;
echo;
echo;
if "%ui.mouse%"=="word" (
%echo%;							%txt_b7.top%
%echo%;		%txt_color.tip%	[ %txt_color.wd% ]	%txt_color.b7.bg%
%echo%;							%txt_b7.bot%
)
if "%ui.mouse%"=="paper" (
%echo%;							%txt_b7.top%
%echo%;		%txt_color.tip%	= %txt_color.bg% =	%txt_color.b7.wd%
%echo%;							%txt_b7.bot%
)
echo;
echo;
echo;
set "ui.tmp=   %txt_color.0%     %txt_color.8%    %txt_color.7%     %txt_color.f%   "
for %%i in (0 8 7 f) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo;                     !ui.tmp!
echo;
echo;
set "ui.tmp=   %txt_color.4%      %txt_color.6%      %txt_color.2%      %txt_color.3%      %txt_color.1%      %txt_color.5%   "
for %%i in (4 6 2 3 1 5) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo;             !ui.tmp!
echo;
echo;
set "ui.tmp=  %txt_color.c%    %txt_color.e%    %txt_color.a%    %txt_color.b%    %txt_color.9%    %txt_color.d%  "
for %%i in (c e a b 9 d) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo;             !ui.tmp!
echo;
echo;
echo;
echo;
%echo%;								%txt_b7.top%
%echo%;								%txt_b7.finish%
%echo%;								%txt_b7.bot%

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	65}74}23}25}back}
	57}68}6}8}switch}
	14}19}14}16}4}
	14}19}17}19}c}
	22}27}11}13}0}
	22}27}14}16}6}
	22}27}17}19}e}
	30}35}11}13}8}
	30}35}14}16}2}
	30}35}17}19}a}
	38}43}11}13}7}
	38}43}14}16}3}
	38}43}17}19}b}
	46}51}11}13}f}
	46}51}14}16}1}
	46}51}17}19}9}
	54}59}11}16}5}
	54}59}17}19}d}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d (set "key=%%~e")
	)
)

if "%key%"=="switch" (
	if "%ui.mouse%"=="paper" set "ui.mouse=word"
	if "%ui.mouse%"=="word" set "ui.mouse=paper"
)
if "%key%"=="back" goto :EOF

for %%i in (0 1 2 3 4 5 6 7 8 9 a b c d e f) do (
	if "%key%"=="%%i" (
		if "%ui.mouse%"=="word" if "%Color:~0,1%"=="%%i" (
				set "Color=%Color:~1,1%%%i"
			) else (
				set "Color=%color:~0,1%%%i"
			)
		if "%ui.mouse%"=="paper" if "%Color:~1,1%"=="%%i" (
				set "Color=%%i%Color:~0,1%"
			) else (
				set "Color=%%i%Color:~1,1%"
			)
		reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Color" /d "!Color!" /f >nul
	)
)
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

