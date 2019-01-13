:: 预设定目录
set "dir.list=%userprofile%\desktop"

:listdir
title %dir.list% %title%
cls

dir "%dir.list%" %ViewExten%

echo.———————————————————————————————————————
echo. [1]打开 [2]上一层 [3]添加到压缩档 [4]解压缩文件 [0]返回
%choice% /c:12340 /n
set "key=%errorlevel%"
if "%key%"=="1" (
	set "list.typein=" & set /p "list.typein=打开："

	:: dir 判断路径为目录将设定变量 dir.list 为新目录
	dir "!dir.list!\!list.typein!" /a:d /b >nul 2>nul && set "dir.list=!dir.list!\!list.typein!"
	echo.!list.typein! | find ":" && ( dir "!list.typein!" /a:d /b >nul 2>nul && set "dir.list=!list.typein!" )

	:: dir 判断路径为文件的前提是该路径不属于目录。
	dir "!dir.list!\!list.typein!" /a:d /b >nul 2>nul || (
		dir "!dir.list!\!list.typein!" /a:-d /b >nul 2>nul && (
			for /f "usebackq tokens=1* delims==" %%a in ('"!dir.list!\!list.typein!"') do (

				:: 以下扩展名的文件使用 Jzip 打开。
				for %%A in (%jzip.spt.open%) do if /i "%%~xa"==".%%A" (
					call "!path.jzip.launcher!" "%%~a"
					set "errorlevel=1"
				)
				:: 其余扩展名的文件使用 start 打开。
				if "!errorlevel!"=="0" start "" "!dir.list!\!list.typein!"
				set "errorlevel="
			)
		)
	)
)
if "%key%"=="2" set "dir.list=!dir.list!\.."
if "%key%"=="3" (
	set "list.typein=" & set /p "list.typein=选定文件添加："
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" add "!dir.list!\!list.typein!"
)
if "%key%"=="4" (
	set "list.typein=" & set /p "list.typein=选定文件解压缩："
	dir "!dir.list!\!list.typein!" /a:-d /b >nul 2>nul && call "%path.jzip.launcher%" unzip "!dir.list!\!list.typein!"
)
if "%key%"=="5" set "key=" & goto :EOF
goto :listdir
