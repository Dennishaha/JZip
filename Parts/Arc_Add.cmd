
if not defined path.File (
	echo.
	echo. 请拖入要添加的文件^(夹^)：
	echo.
	echo. 注：使用 空格 区分项以添加多个项。
	echo.     文件夹路径后加 \* 不传递基目录。
	echo.
	set path.File=&set /p path.File=
	if not defined path.File goto :EOF
)

call :GetFile_Single %path.File%

:Archive_Setting
call :GetFile_Info %path.Archive%
for %%a in (7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" set "type.editor=7z"
for %%a in (rar) do if /i "%Archive.exten%"==".%%a" set "type.editor=rar"
for %%a in (cab) do if /i "%Archive.exten%"==".%%a" set "type.editor=cab"
if "!自解压!"=="y" (set "path.Archive=!dir.File!\!File.name!.exe") else (set "path.Archive=!dir.File!\!File.name!!Archive.exten!")
if "%ArchiveOrder%"=="add-7z" goto :Add_Process
for %%a in (固实文件,压缩加密,自解压) do if "!%%a!"=="y" (set "ui.%%a=●") else (set "ui.%%a=○")
cls
echo. 添加到压缩包
echo.
echo.
echo.
if "%ArchiveOrder%"=="add" echo.            [R] 压缩包：%path.Archive:~0,50%
if "%ArchiveOrder%"=="list" echo.                压缩包：%path.Archive:~0,50%
echo.                        %path.Archive:~50%
echo.
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten=①rar ②7z ③zip ④tar ⑤bz2 ⑥gz ⑦xz ⑧wim ⑨cab"
	for %%A in (①:rar,②:7z,③:zip,④:tar,⑤:bz2,⑥:gz,⑦:xz,⑧:wim,⑨:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%b" echo.                格式：  !ui.Arc.exten:%%a=●!
	)
	echo.
	echo.
)
for %%i in (rar,7z,zip,bz2,gz,xz,cab) do if "%Archive.exten%"==".%%i" (
	for %%A in (0:"○○○○○ 存储",1:"●○○○○ 最快",2:"●●○○○ 很快",3:"●●●○○ 标准",4:"●●●●○ 很好",5:"●●●●● 最好") do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%压缩级别%"=="%%~a" echo.            [E] 压缩效率：         %%~b
	)
) 
for %%a in (tar,wim) do if /i "%Archive.exten%"==".%%a" (
	echo.                压缩效率：         ○○○○○ 存储
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" (
	echo.            [A] 固实文件：         %ui.固实文件%
)
echo.
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" (
	if "%分卷压缩%"=="" echo.            [S] 分卷压缩,大小：    不分卷
	if not "%分卷压缩%"=="" echo.            [S] 分卷压缩,大小：    %分卷压缩%
)
if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" (
	echo.            [D] RAR压缩,版本：     %压缩版本.rar%
	echo.
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.            [F] 创建自释放程序：   %ui.自解压%
	if "%自解压%"=="y" for %%A in (a32:"标准界面",a64:"标准界面（64位）",b32:"控制台界面",b64:"控制台界面（64位）") do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
			if "%自解压模块%"=="%%~a" echo.            [G]  L 模块：          %%~b
	)
	echo.
)
for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.            [Q] 加密：             %ui.压缩加密% %压缩密码%
)
echo.
echo.
if "%ArchiveOrder%"=="add" for %%A in (1:rar,2:7z,3:zip,4:tar,5:bz2,6:gz,7:xz,8:wim,9:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%b"  echo.            [%%a] 确定   [0] 返回
)
if "%ArchiveOrder%"=="list" echo.            [1] 确定   [0] 返回
%choice% /c:123456789reasdfgq0 /n
set "next=%errorlevel%"
if "%ArchiveOrder%"=="add" (
	for %%A in (1:rar,2:7z,3:zip,4:tar,5:bz2,6:gz,7:xz,8:wim,9:cab) do for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%next%"=="%%a" if "%Archive.exten%"==".%%b" (goto :Add_Process) else (set "Archive.exten=.%%b" & call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩格式切换)
	)
)
if "%ArchiveOrder%"=="list" if "%next%"=="1" goto :Add_Process

if "%next%"=="10" if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Set_Zip.cmd" :目标路径
if "%next%"=="11" for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩级别
if "%next%"=="12" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :固实文件
if "%next%"=="13"  for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :分卷压缩
if "%next%"=="14" if "%ArchiveOrder%"=="add" for %%a in (rar) do if "%Archive.exten%"=="%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩版本.rar
if "%next%"=="15" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :自解压
if "%next%"=="16" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :自解压模块
if "%next%"=="17" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩加密
if "%next%"=="18" set "next=" & goto :EOF
goto :Archive_Setting


:Add_Process
cls
::配置压缩参数
for %%A in (0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21) do (
	for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
	if "%type.editor%"=="rar" if "%压缩级别%"=="%%a" set "btn.压缩级别=%%b"
	if "%type.editor%"=="7z" if "%压缩级别%"=="%%a" set "btn.压缩级别=%%c"
	if "%type.editor%"=="cab" if "%压缩级别%"=="%%a" set "btn.压缩级别=%%d"
)

if "%压缩加密%"=="y" set "btn.压缩加密=-p%压缩密码%"
if "%固实文件%"=="y" set "btn.固实文件=-s"
if defined 分卷压缩 set "btn.分卷压缩= -v%分卷压缩%"
if "%自解压%"=="y" (
	for %%A in (
		a32/Default/7z/Zip,
		a64/Default64//Zip64,
		b32/WinCon/7zCon/,
		b64/WinCon64//,
	) do for /f "tokens=1-4 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".rar" if "%自解压模块%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx""
		if "%Archive.exten%"==".7z" if "%自解压模块%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx""
		if "%Archive.exten%"==".zip" if "%自解压模块%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%d.sfx""
		)
	)
)

if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.压缩加密% -m%btn.压缩级别% %btn.固实文件% %btn.分卷压缩% -ma%压缩版本.rar% -ep1 %btn.自解压% -w"%dir.jzip.temp%" "%path.Archive%" %path.File%

if "%File.Single%"=="n" for %%a in (.bz2 .gz .xz) do if "%Archive.exten%"=="%%a" (
	"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%File.name%.tar" %path.File%
	set "path.Archive=%dir.File%\%File.name%.tar%Archive.exten%"
	set "path.File=%dir.jzip.temp%\%File.name%.tar"
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.压缩加密% -mx=%btn.压缩级别% %btn.分卷压缩% -w"%dir.jzip.temp%" %btn.自解压% "%path.Archive%" %path.File%

if "%type.editor%"=="cab" "%path.editor.cab%" -r -m %btn.压缩级别% n "%path.Archive%" %path.File%


if "%ArchiveOrder%"=="add" (
	echo.------------------------------------------------------------------------------
	echo.
	echo.     生成路径：
	echo.       %path.Archive:~0,66%
	echo.       %path.Archive:~66%
	echo.                                    [回车] 好
	pause >nul
)
set "path.File=" & goto :EOF



:GetFile_Single
if "%~2"=="" (
	dir "%~1" /a:d /b 1>nul 2>nul && set "File.Single=n" || set "File.Single=y"
) else (
	set "File.Single=n"
)

:GetFile_Info
for /f "usebackq delims==" %%a in ('"%~1"') do (
	set "dir.File=%%~dpa" & set "dir.File=!dir.File:~0,-1!"
	set "File.name=%%~na"
	set "File.exten=%%~xa"
)
goto :EOF