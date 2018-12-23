::预设定目录
set "dir.list=%userprofile%\desktop"

:listdir
title %dir.list% %title%
cls

dir "%dir.list%"

echo.———————————————————————————————————————
echo. [1]打开 [2]上一层 [3]添加到压缩档 [4]解压缩文件 [0]返回
%choice% /c:12340 /n
set "next=%errorlevel%"
if "%next%"=="1" (
	set "list.typein="&set /p "list.typein=打开："
	dir "!dir.list!\!list.typein!" /a:d /b 1>nul 2>nul && set "dir.list=!dir.list!\!list.typein!"
	dir "!dir.list!\!list.typein!" /a:-d /b 1>nul 2>nul && start "" "!dir.list!\!list.typein!"
)
if "%next%"=="2" set "dir.list=!dir.list!\.."
if "%next%"=="3" (
	set "list.typein="&set /p "list.typein=选定文件添加："
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" add !dir.list!\!list.typein!
)
if "%next%"=="4" (
	set "list.typein="&set /p "list.typein=选定文件解压缩："
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" unzip !dir.list!\!list.typein!
)
if "%next%"=="5" set "next=" & goto :EOF
goto :listdir



