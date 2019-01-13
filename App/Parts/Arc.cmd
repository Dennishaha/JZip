color %界面颜色%

:menu
cls
for %%a in (rar,7z,cab) do if "%type.editor%"=="%%a" "!path.editor.%%a!" l "%path.Archive%" %ViewExten%

echo.———————————————————————————————————————
for %%a in (%jzip.spt.write%) do if /i "%Archive.exten%"==".%%a" set "ui.Archive.writeable=y"
if "%ui.Archive.writeable%"=="y" (
	echo. [1]打开 [2]提取 [3]解压到 [4]添加 [5]删除 [6]重命名 [7]高级 [0]返回
) else (
	echo. [1]打开 [2]提取 [3]解压到 [7]高级 [0]返回
)

%choice% /c:12345670 /n
set "key=%errorlevel%"
if "%key%"=="1" call "%dir.jzip%\Parts\Arc_View.cmd"
if "%key%"=="2" call "%dir.jzip%\Parts\Arc_UnPart.cmd"
if "%key%"=="3" call "%dir.jzip%\Parts\Arc_UnZip.cmd"
if "%key%"=="4" if "%ui.Archive.writeable%"=="y" call "%dir.jzip%\Parts\Arc_Add.cmd"
if "%key%"=="5" if "%ui.Archive.writeable%"=="y" call :Arc_Delete
if "%key%"=="6" if "%ui.Archive.writeable%"=="y" call :Arc_ReName
if "%key%"=="7" call :menu-more
if "%key%"=="8" set "key=" & goto :EOF
goto :menu

:menu-more
echo.
if "%type.editor%"=="7z" echo. -- [Q]测试 [0] 返回
if "%type.editor%"=="rar" echo. -- [Q]测试 [W]修复 [E]锁定 [R]添加注释 [T]自解压转换 [0]返回

%choice% /c:qwert0 /n
set "key=%errorlevel%"
if "%key%"=="1" call :Arc_Check & goto :EOF
if "%key%"=="2" if "%type.editor%"=="rar" call :Arc_Repair & goto :EOF
if "%key%"=="3" if "%type.editor%"=="rar" call :Arc_Lock & goto :EOF
if "%key%"=="4" if "%type.editor%"=="rar" call :Arc_Note & goto :EOF
if "%key%"=="5" if "%type.editor%"=="rar" call "%dir.jzip%\Parts\Arc_Sfx.cmd" & goto :EOF
if "%key%"=="6" set "key=" & goto :EOF
goto :menu-more


:Arc_Delete
echo.
echo. 请键入要删除的文件(夹)：
echo.
echo.  注：使用 空格 区分项以添加多个项。
echo.     通配符 * ? 代表多个项。
echo.
set "Archive.file=" & set /p "Archive.file="
if not defined Archive.file goto :EOF
for %%a in (rar,7z) do  if "%type.editor%"=="%%a" "!path.editor.%%a!" d -w"%dir.jzip.temp%" "%path.Archive%" %Archive.file%
goto :EOF

:Arc_ReName
echo.
echo. 请键入要重命名的文件(夹)：
echo.
echo.  注：使用 空格 区分项以添加多个项。
echo.     通配符 * ? 代表多个项。
echo.
set Archive.file=&set /p Archive.file=
if not defined Archive.file goto :EOF
echo.
echo. 新文件名：
echo.
set "Archive.file.rn=" & set /p "Archive.file.rn="
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
echo.
echo.  锁定压缩文件后不能再修改，确认锁定?
echo.            [Y] 确认    [0] 返回
echo.
set "key=" & set /p "key="
if /i "%key%"=="y" (
	cls
	if "%type.editor%"=="rar" "%path.editor.rar%" k -w"%dir.jzip.temp%" "%path.Archive%"
	pause
)
goto :EOF