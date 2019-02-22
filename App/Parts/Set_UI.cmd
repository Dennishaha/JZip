
::µ÷ÓÃÅÐ¶Ï
if "%~1"=="-info" (
	set "stat.color.wd=!txt_color.%color:~1,1%!"
	set "stat.color.bg=!txt_color.%color:~0,1%!"
)
if "%~1"=="" call :start
goto :eof


:start
if not defined ui.mouse set "ui.mouse=word"
color %Color%
cls

echo,
echo,   %txt_color.title%
echo,
echo,
echo,
if "%ui.mouse%"=="word" (
%echo%,							%txt_b7.top%
%echo%,		%txt_color.tip%	[ %txt_color.wd% ]	%txt_color.b7.bg%
%echo%,							%txt_b7.bot%
)
if "%ui.mouse%"=="paper" (
%echo%,							%txt_b7.top%
%echo%,		%txt_color.tip%	= %txt_color.bg% =	%txt_color.b7.wd%
%echo%,							%txt_b7.bot%
)
echo,
echo,
echo,
set "ui.tmp=   %txt_color.0%     %txt_color.8%    %txt_color.7%     %txt_color.f%   "
for %%i in (0 8 7 f) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo,                     !ui.tmp!
echo,
echo,
set "ui.tmp=   %txt_color.4%      %txt_color.6%      %txt_color.2%      %txt_color.3%      %txt_color.1%      %txt_color.5%   "
for %%i in (4 6 2 3 1 5) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo,             !ui.tmp!
echo,
echo,
set "ui.tmp=  %txt_color.c%    %txt_color.e%    %txt_color.a%    %txt_color.b%    %txt_color.9%    %txt_color.d%  "
for %%i in (c e a b 9 d) do (
	if "%color:~1,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  =[ !txt_color.%%i! ]%%"
	if "%color:~0,1%"=="%%i" call set "ui.tmp=%%ui.tmp:  !txt_color.%%i!  == !txt_color.%%i! =%%"
)
echo,             !ui.tmp!
echo,
echo,
echo,
%echo%,								%txt_b7.top%
%echo%,								%txt_b7.finish%
%echo%,								%txt_b7.bot%

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	65}74}21}23}back}
	57}68}5}7}change}
	14}19}13}15}4}
	14}19}16}18}c}
	22}27}10}12}0}
	22}27}13}15}6}
	22}27}16}18}e}
	30}35}10}12}8}
	30}35}13}15}2}
	30}35}16}18}a}
	38}43}10}12}7}
	38}43}13}15}3}
	38}43}16}18}b}
	46}51}10}12}f}
	46}51}13}15}1}
	46}51}16}18}9}
	54}59}10}15}5}
	54}59}16}18}d}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d (set "key=%%~e")
	)
)

if "%key%"=="change" (
	if "%ui.mouse%"=="paper" set "ui.mouse=word"
	if "%ui.mouse%"=="word" set "ui.mouse=paper"
)
if "%key%"=="back" goto :EOF

for %%i in (0 1 2 3 4 5 6 7 8 9 a b c d e f) do (
	if "%key%"=="%%i" (
		if "%ui.mouse%"=="word" if not "%Color:~0,1%"=="%%i" set "Color=%Color:~0,1%%%i"
		if "%ui.mouse%"=="paper" if not "%Color:~1,1%"=="%%i" set "Color=%%i%Color:~1,1%"
		reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Color" /d "!Color!" /f >nul
	)
)
goto :start

