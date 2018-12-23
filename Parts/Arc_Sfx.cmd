:预设值
if /i "%Archive.exten%"==".exe" goto :menu-exe
if /i "%Archive.exten%"==".rar" goto :menu-rar

:menu-rar
cls
echo.
echo.
echo.
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.                    创建含自解压模块的副本 (.rar ^>^> .exe)
echo. 
echo.                         [1] 自解压压缩文件   (默认)
echo.                         [2] 自解压压缩文件   (64位)
echo.
echo.                         [3] 控制台自解压压缩文件
echo.                         [4] 控制台自解压压缩文件 (64位)
echo.
echo.                         [0] 返回
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.
echo.
echo.请用键盘选择并回车...
echo.-----------------------
%choice% /c:12340 /n
set "next=%errorlevel%"
if "%next%"=="1" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default.sfx"& goto :next
if "%next%"=="2" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default64.sfx"& goto :next
if "%next%"=="3" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon.sfx"& goto :next
if "%next%"=="4" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon64.sfx"& goto :next
if "%next%"=="5" goto :EOF
goto :menu-rar

:menu-exe
cls
echo.
echo.
echo.
echo.
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.                   创建不含自解压模块的副本 (.exe ^>^> .rar)
echo.
echo.                          [回车] 创建
echo.
echo.                             [0] 返回
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo.请用键盘选择并回车...
echo.-----------------------
set next=&set /p next=
if "%next%"=="" set SfxOrder=s-& goto :next
if "%next%"=="0" goto :EOF
goto :menu-exe

:next
set "random1=%random%%random%"
md "%dir.jzip.temp%\%random1%"

if "%type.editor%"=="rar" "%path.editor.rar%" %SfxOrder% -w%dir.jzip.temp%\%random1% "%path.Archive%"

echo.------------------------------------------------------------------------------
echo.
echo.    生成路径：
echo.     %path.Archive%
echo.
echo.                                    [回车] 好
pause>nul
goto :EOF