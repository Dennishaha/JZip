
::调用判断
if "%~1"=="-info" call :text_color
if "%~1"=="" call :start
goto :eof


:text_color
for %%A in (0:黑,1:蓝,2:绿,3:浅绿,4:红,5:紫,6:黄,7:白,8:灰,9:淡蓝,a:淡绿,b:淡浅绿,c:淡红,d:淡紫,e:淡黄,f:亮白) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%界面颜色:~1,1%"=="%%a" set "ui.word=%%b"
		if "%界面颜色:~0,1%"=="%%a" set "ui.paper=%%b"
	)
)
goto :EOF

:start
call :text_color
if not defined ui.mouse set "ui.mouse=word"
color %界面颜色%
cls
echo.
echo.  ^<  Jzip 界面颜色设置
echo.———————————————————————————————————————
echo.
if "%ui.mouse%"=="word" echo.                   ^>^>^>  [Q] 文字        %ui.word%
if not "%ui.mouse%"=="word" echo.                        [Q] 文字        %ui.word%
echo.
if "%ui.mouse%"=="paper" echo.                   ^>^>^>  [W] 底色        %ui.paper%
if not "%ui.mouse%"=="paper" echo.                        [W] 底色        %ui.paper%
echo.
if errorlevel 1 echo.                 当前颜色不生效，文字和底色一致会导致无法显示内容。
echo.
echo.                         0 = 黑色       8 = 灰色
echo.                         1 = 蓝色       9 = 淡蓝色
echo.                         2 = 绿色       A = 淡绿色
echo.                         3 = 浅绿色     B = 淡浅绿色
echo.                         4 = 红色       C = 淡红色
echo.                         5 = 紫色       D = 淡紫色
echo.                         6 = 黄色       E = 淡黄色
echo.                         7 = 白色       F = 亮白色
echo.
echo.                      ^< [N] 返回   
echo.
echo.请用键盘选择并回车...
echo.-----------------------
%choice% /c:qwn0123456789abcdef /n
set "key=%errorlevel%"
if "%key%"=="1" set "ui.mouse=word"
if "%key%"=="2" set "ui.mouse=paper"
if "%key%"=="3" goto :EOF

for %%A in (4:0,5:1,6:2,7:3,8:4,9:5,10:6,11:7,12:8,13:9,14:a,15:b,16:c,17:d,18:e,19:f) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%key%"=="%%a" (
			if "%ui.mouse%"=="word" set "界面颜色=%界面颜色:~0,1%%%b"
			if "%ui.mouse%"=="paper" set "界面颜色=%%b%界面颜色:~1,1%"
			reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "界面颜色" /d "!界面颜色!" /f >nul
		)
	)
)
goto :start