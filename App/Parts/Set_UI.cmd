
::调用判断
set "color.list=0/黑,1/蓝,2/绿,3/青,4/红,5/紫,6/黄,7/浅灰,8/深灰,9/浅蓝,a/浅绿,b/浅青,c/浅红,d/浅紫,e/浅黄,f/白"

if "%~1"=="-info" call :text_color
if "%~1"=="" call :start
goto :eof


:text_color
for %%A in (!color.list!) do (
	for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%界面颜色:~1,1%"=="%%a" set "ui.word=%%b"
		if "%界面颜色:~0,1%"=="%%a" set "ui.paper=%%b"
	)
)
goto :EOF

:start
if not defined ui.mouse set "ui.mouse=word"
color %界面颜色%
cls
echo.
echo.   Jzip 界面颜色设置
echo.
echo.
echo.
if "%ui.mouse%"=="paper" (
echo.                                                    ┌-----------┐
echo.                 点击下方颜色设定   ^< 背景色 ^>      │  设定文字 │
echo.                                                    └-----------┘
)
if "%ui.mouse%"=="word" (
echo.                                                    ┌-----------┐
echo.                 点击下方颜色设定   [ 文字色 ]      │  设定背景 │
echo.                                                    └-----------┘
)
echo.
echo.
echo.
set "ui.colorselect=   黑     深灰    浅灰     白   "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%界面颜色:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%界面颜色:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.                     !ui.colorselect!
echo.
echo.
set "ui.colorselect=   红      黄      绿      青      蓝      紫   "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%界面颜色:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%界面颜色:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.             !ui.colorselect!
echo.
echo.
set "ui.colorselect=  浅红    浅黄    浅绿    浅青    浅蓝    浅紫  "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%界面颜色:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%界面颜色:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.             !ui.colorselect!
echo.
echo.
echo.
echo.                                                               ┌-----------┐
echo.                                                               │    完成   │
echo.                                                               └-----------┘

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	64}75}21}23}back}
	53}64}5}7}change}
	14}19}13}15}红}
	14}19}16}18}浅红}
	22}27}10}12}黑}
	22}27}13}15}黄}
	22}27}16}18}浅黄}
	30}35}10}12}深灰}
	30}35}13}15}绿}
	30}35}16}18}浅绿}
	38}43}10}12}浅灰}
	38}43}13}15}青}
	38}43}16}18}浅青}
	46}51}10}12}白}
	46}51}13}15}蓝}
	46}51}16}18}浅蓝}
	54}59}10}15}紫}
	54}59}16}18}浅紫}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d (set "key=%%~e")
	)
)

if "%key%"=="change" ( if "%ui.mouse%"=="paper" set "ui.mouse=word" ) & ( if "%ui.mouse%"=="word" set "ui.mouse=paper" )
if "%key%"=="back" goto :EOF

for %%A in (!color.list!) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%key%"=="%%b" (
		if "%ui.mouse%"=="word" if not "%界面颜色:~0,1%"=="%%a" set "界面颜色=%界面颜色:~0,1%%%a"
		if "%ui.mouse%"=="paper" if not "%界面颜色:~1,1%"=="%%a" set "界面颜色=%%a%界面颜色:~1,1%"
		reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "界面颜色" /d "!界面颜色!" /f >nul
	)
)
goto :start

