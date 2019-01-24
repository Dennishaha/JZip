@echo off
setlocal EnableExtensions
setlocal enabledelayedexpansion
chcp 936 >nul
color %界面颜色%

::初始变量设定
set "Window.Wide=110"
set "Window.Height=35"
mode %Window.Wide%, %Window.Height%

for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
if "%type.editor%"=="rar" set "listzip.FileBoundary=^\<----------- ---------  ---------- -----  ----\>$"
if "%type.editor%"=="7z" set "listzip.FileBoundary=^\<------------------- ----- ------------ ------------  ------------------------\>$"
for /f "delims=" %%a in ('cscript //nologo "%dir.jzip%\Parts\Create_GUID.vbs"') do set "random1=%%a"
set "listzip.txt=%dir.jzip.temp%\%random1%.tmp"
set "listzip.Dir="

:Menu
cls

:: 动态调整窗口大小，调试时需注释以禁用
for /f "tokens=1-2 delims= " %%i in ('mode') do (
	if "%%i"=="行:　" set "Window.Height=%%~j"
	if "%%i"=="列:　　" set "Window.Wide=%%~j"
)
set /a "listzip.ViewLineBlock=Window.Height-5"

:: 生成压缩档文件列表
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" "!path.editor.%%a!" l "%path.Archive%" | find /v "" >"%listzip.txt%" %iferror%

:: 找到列出压缩档内容的位置
set "listzip.FileLineStart="
set "listzip.FileLineEnd="
for /f "tokens=1 delims=:" %%i in ('findstr /n "%listzip.FileBoundary%" "%listzip.txt%"') do (
	if "!listzip.FileLineStart!"=="" (set "listzip.FileLineStart=%%i" ) else ( set listzip.FileLineEnd=%%i )
)
set /a "listzip.FileLineStart+=0","listzip.FileLineEnd-=2","listzip.TitleLine=listzip.FileLineStart-2"

::设定显示行首行数
if not defined listzip.ViewLineStart set /a "listzip.ViewLineStart=listzip.FileLineStart"
if %listzip.ViewLineStart% LSS %listzip.FileLineStart% set /a "listzip.ViewLineStart=listzip.FileLineStart"
if %listzip.ViewLineStart% GTR %listzip.FileLineEnd% set /a "listzip.ViewLineStart-=listzip.ViewLineBlock"

::设定显示行末行数
set /a "listzip.ViewLineEnd=listzip.ViewLineStart+listzip.ViewLineBlock-1"
if %listzip.ViewLineEnd% GTR %listzip.FileLineEnd% set /a "listzip.ViewLineEnd=listzip.FileLineEnd"

::计算文件项数和显示页数
set /a "listzip.FileLineTotal=listzip.FileLineEnd-listzip.FileLineStart+1"
set /a "listzip.ViewPageNow=((listzip.ViewLineStart-listzip.FileLineStart)/listzip.ViewLineBlock)+1"
set /a "listzip.ViewPageTotal=(listzip.FileLineTotal-1)/listzip.ViewLineBlock+1"

::UI--------------------------------------------------

::显示压缩档操作选项
if "%ui.Archive.writeable%"=="y" (
	echo.  主页 │  打开 提取 解压到 添加 删除 重命名 高级 上页 下页
) else (
	echo.  主页 │  打开 提取 解压到                  高级 上页 下页
)
::echo. File {%listzip.FileLineStart%:%listzip.FileLineEnd%} View [%listzip.ViewLineStart%:%listzip.ViewLineEnd%]
echo.
call :输出一行内容 %listzip.TitleLine%

::分析指定行读至变量 listzip.FileLine.x 判断行宽，然后输出到屏幕，if 判断排除空压缩档
if %listzip.FileLineStart% LEQ %listzip.FileLineEnd% (
	for /l %%a in (%listzip.ViewLineStart%,1,%listzip.ViewLineEnd%) do call :分析一行内容 %%a
	for /l %%a in (%listzip.ViewLineStart%,1,%listzip.ViewLineEnd%) do (
		for %%d in (!Window.Wide!) do echo,!listzip.FileLine.%%a:~0,%%d!
	)
)

::补充空行
set /a "listzip.ViewEchoEnd=listzip.ViewLineStart+listzip.ViewLineBlock"
set /a "listzip.ViewEchoSpace=listzip.ViewEchoEnd-listzip.FileLineEnd-2"
if %listzip.ViewLineEnd% LSS %listzip.ViewEchoEnd% (
	for /l %%a in (0,1,!listzip.ViewEchoSpace!) do echo.
)

::下方提示
echo. %listzip.ViewPageNow%/%listzip.ViewPageTotal% 页  %listzip.FileLineTotal% 个项目

::UI--------------------------------------------------
::坐标判断
%tmouse% /d 0 -1 1
%tmouse.process%
::ping localhost -n 2 >nul

set "listzip.ButtonLine=3"
if defined mouse.x if defined mouse.y (
	for /l %%a in (%listzip.ViewLineStart%,1,%listzip.ViewLineEnd%) do (
		if defined listzip.FileLine.%%a (
			if %mouse.y% EQU !listzip.ButtonLine! (
				if "%type.editor%"=="rar" if %mouse.x% GEQ 41 call "%dir.jzip%\Parts\Arc_Open.cmd" "!listzip.FileLine.%%a:~41!"
				if "%type.editor%"=="7z" if %mouse.x% GEQ 53 call "%dir.jzip%\Parts\Arc_Open.cmd" "!listzip.FileLine.%%a:~53!"
			)
		)
		set /a "listzip.ButtonLine+=1"
	)
)

for %%A in (
	1}5}0}0}10}
	10}13}0}0}1}
	15}18}0}0}2}
	20}25}0}0}3}
	27}30}0}0}4}
	32}35}0}0}5}
	37}42}0}0}6}
	44}47}0}0}7}
	49}52}0}0}8}
	54}57}0}0}9}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"=="1" ( call "%dir.jzip%\Parts\Arc_Open.cmd"
) else if "%key%"=="2" ( call "%dir.jzip%\Parts\Arc_UnPart.cmd"
) else if "%key%"=="3" ( call "%dir.jzip%\Parts\Arc_UnZip.cmd"
) else if "%key%"=="4" ( if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Add.cmd"
) else if "%key%"=="5" ( if "%ui.Archive.writeable%"=="y" call :Arc_Delete
) else if "%key%"=="6" ( if "%ui.Archive.writeable%"=="y" call :Arc_ReName
) else if "%key%"=="7" ( call :menu-more
) else if "%key%"=="8" ( set /a "listzip.ViewLineStart-=%listzip.ViewLineBlock%"
) else if "%key%"=="9" ( set /a "listzip.ViewLineStart+=%listzip.ViewLineBlock%"
) else if "%key%"=="10" ( start /i "" "%path.jzip.launcher%" & goto :EOF
)
goto :Menu


:分析一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do set "listzip.FileLine.%1=%%a" & goto :EOF
goto :EOF


:输出一行内容
for /f "skip=%1 delims=" %%a in (%listzip.txt%) do echo,%%a & goto :EOF
goto :EOF


:menu-more
echo.
if "%type.editor%"=="7z" echo. -- [Q]测试 [0] 返回
if "%type.editor%"=="rar" echo. -- [Q]测试 [W]修复 [E]锁定 [R]添加注释 [T]自解压转换 [0]返回

%choice% /c:qwert0 /n
set "key=%errorlevel%"
if "%key%"=="1" ( call :Arc_Check & goto :EOF
) else if "%key%"=="2" ( if "%type.editor%"=="rar" call :Arc_Repair & goto :EOF
) else if "%key%"=="3" ( if "%type.editor%"=="rar" call :Arc_Lock & goto :EOF
) else if "%key%"=="4" ( if "%type.editor%"=="rar" call :Arc_Note & goto :EOF
) else if "%key%"=="5" ( if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd" & goto :EOF
) else if "%key%"=="6" ( goto :EOF
)
goto :menu-more


:Arc_Delete
set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("请键入要删除的文件/夹："&vbCrLf&vbCrLf&"使用空格区分项以添加多个项，可用通配符*?。","提示"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file%
goto :EOF

:Arc_ReName
set "Archive.file="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("请键入要重命名的文件/夹："&vbCrLf&vbCrLf&"使用空格区分项以添加多个项，可用通配符*?。","提示"))(window.close)"') do (
	set "Archive.file=%%a"
)
if not defined Archive.file goto :EOF
set "Archive.file.rn="
for /f "delims=" %%a in (' mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(inputbox("请键入文件/夹的新名字："&vbCrLf&vbCrLf&"使用空格区分项以添加多个项，可用通配符*?。","提示"))(window.close)"') do (
	set "Archive.file.rn=%%a"
)
if not defined Archive.file.rn goto :EOF
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" rn -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file% %Archive.file.rn%
goto :EOF

:Arc_Check
cls
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" t "%path.Archive%"
pause
goto :EOF

:Arc_Repair
cls
if "%type.editor%"=="rar" "%path.editor.rar%" r -w%dir.jzip.temp% "%path.Archive%"
pause
goto :EOF

:Arc_Note
cls
if "%type.editor%"=="rar" "%path.editor.rar%" c -w%dir.jzip.temp% "%path.Archive%"
pause
goto :EOF

:Arc_Lock
set "key="
for /f "delims=" %%a in ('mshta "vbscript:CreateObject("Scripting.Filesystemobject").GetStandardStream(1).Write(msgbox("锁定压缩文件后不可修改，确认锁定?",1+64,"提示"))(window.close)"') do set "key=%%a"
if "%key%"=="1" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%"
	pause
)
goto :EOF

