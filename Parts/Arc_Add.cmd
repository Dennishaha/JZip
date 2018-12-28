
if not defined path.File (
	echo.
	echo. 请拖入要添加的文件^(夹^)：
	echo.
	echo. 注：使用 空格 区分项以添加多个项。
	echo.     文件夹路径后加 \* 不传递基目录。
	echo.
	set "path.File=" & set /p "path.File="
	if not defined path.File goto :EOF
)

call :GetFile_Single %path.File%

:Archive_Setting
call :Archive_info "%path.Archive%"
if "%ArchiveOrder%"=="add-7z" goto :Add_Process
for %%a in (固实文件,压缩加密) do if "!%%a!"=="y" (set "ui.%%a=●") else (set "ui.%%a=○")
cls
echo.
echo.  添加到压缩包
echo.
echo.
if "%ArchiveOrder%"=="add" echo.            [R] 压缩包  %path.Archive:~0,50%
if "%ArchiveOrder%"=="list" echo.                压缩包  %path.Archive:~0,50%
echo.                        %path.Archive:~50%
echo.
if "%ArchiveOrder%"=="add" (
	set "ui.Arc.exten=①7z ②rar ③zip ④tar ⑤bz2 ⑥gz ⑦xz ⑧wim ⑨cab"
	for %%A in (①/7z,②/rar,③/zip,④/tar,⑤/bz2,⑥/gz,⑦/xz,⑧/wim,⑨/cab) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%Archive.exten%"==".%%~b" echo.                格式    !ui.Arc.exten:%%~a=●!
	)
	echo.
)
for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if "%Archive.exten%"==".%%a" (
	for %%A in (
		0/"○○○○○ 存储"
		1/"●○○○○ 最快"
		2/"●●○○○ 很快"
		3/"●●●○○ 默认"
		4/"●●●●○ 很好"	
		5/"●●●●● 最好"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%压缩级别%"=="%%~a" echo.            [E] 压缩效率           %%~b
	)
) 
for %%a in (tar,wim) do if /i "%Archive.exten%"==".%%a" (
	echo.                压缩效率           ○○○○○ 存储
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" (
	echo.            [A] 固实文件           %ui.固实文件%
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" (
	if "%分卷压缩%"=="" echo.            [S] 分卷               ○
	if not "%分卷压缩%"=="" echo.            [S] 分卷               ● %分卷压缩%
)
if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.
	for %%A in (
		""/"○ "
		a32/"● 标准界面"
		a64/"● 标准界面（64位）"
		b32/"● 控制台界面"
		b64/"● 控制台界面（64位）"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%自解压%"=="%%~a" echo.            [F] 创建自释放程序     %%~b
	)
)
for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" (
	echo.
	echo.            [Q] 加密               %ui.压缩加密% %压缩密码%
)
if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" (
	echo.
	for %%A in (
		"4"/"●","5"/"○"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if not defined 压缩版本.rar set "压缩版本.rar=5"
		if "!压缩版本.rar!"=="%%~a" echo.            [D] 兼容早期版本       %%~b
	)
	for %%A in (
		""/"○","3"/"● 默认","6"/"● 强"
	) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%压缩恢复记录%"=="%%~a" echo.            [C] 恢复记录           %%~b
	)
)
echo.
echo.
echo.            [回车] 确定   [0] 返回
echo.
%key.request%
if /i "%key%"=="" goto :Add_Process
if "%ArchiveOrder%"=="add" (
	for %%A in (1/7z,2/rar,3/zip,4/tar,5/bz2,6/gz,7/xz,8/wim,9/cab) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if /i "%key%"=="%%a" set "Archive.exten=.%%b" & call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩格式切换
	)
)
if /i "%key%"=="R" if "%ArchiveOrder%"=="add" call "%dir.jzip%\Parts\Set_Zip.cmd" :目标路径
if /i "%key%"=="E" for %%a in (rar,7z,zip,bz2,gz,xz,cab) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩级别
if /i "%key%"=="A" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,xz) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :固实文件
if /i "%key%"=="S"  for %%a in (rar,7z,zip,tar,bz2,gz,xz,wim) do if "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :分卷压缩
if /i "%key%"=="F" if "%ArchiveOrder%"=="add" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :自解压
if /i "%key%"=="Q" for %%a in (rar,7z,zip) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩加密
if /i "%key%"=="D" if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩版本.rar
if /i "%key%"=="C" if "%ArchiveOrder%"=="add" for %%a in (rar) do if /i "%Archive.exten%"==".%%a" call "%dir.jzip%\Parts\Set_Zip.cmd" :压缩恢复记录
if /i "%key%"=="0" set "key=" & goto :EOF
goto :Archive_Setting


:Add_Process
cls
::配置压缩参数
if defined 压缩级别 (
	for %%A in (
		0/0/0/none,1/1/1/lzx:15,2/2/3/lzx:17,3/3/5/mszip,4/4/7/lzx:19,5/5/9/lzx:21
	) do (
		for /f "tokens=1,2,3,4 delims=/" %%a in ("%%A") do (
		if "%type.editor%"=="rar" if "%压缩级别%"=="%%a" set "btn.压缩级别=-m%%b"
		if "%type.editor%"=="7z" if "%压缩级别%"=="%%a" set "btn.压缩级别=-mx=%%c"
		if "%type.editor%"=="cab" if "%压缩级别%"=="%%a" set "btn.压缩级别=-m %%d"
	)
)
if "%压缩加密%"=="y" set "btn.压缩加密=-p%压缩密码%"
if "%固实文件%"=="y" set "btn.固实文件=-s"
if defined 分卷压缩 set "btn.分卷压缩= -v%分卷压缩%"
if defined 压缩版本.rar set "btn.压缩版本.rar=-ma%压缩版本.rar%"
if defined 压缩恢复记录 set "btn.压缩恢复记录=-rr%压缩恢复记录%"
if defined 自解压 (
	for %%A in (
		a32/Default/7z/Zip,
		a64/Default64/""/Zip64,
		b32/WinCon/7zCon/"",
		b64/WinCon64/""/,
	) do for /f "tokens=1-4 delims=/" %%a in ("%%A") do (
		if "%Archive.exten%"==".rar" if "%自解压%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%b.sfx""
		if "%Archive.exten%"==".7z" if "%自解压%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%c.sfx""
		if "%Archive.exten%"==".zip" if "%自解压%"=="%%a" set "btn.自解压=-sfx"%dir.jzip%\Components\Sfx\%%d.sfx""
		)
	)
)

if "%type.editor%"=="rar" "%path.editor.rar%" a %btn.压缩加密% %btn.压缩级别% %btn.固实文件% %btn.分卷压缩% %btn.压缩版本.rar% -ep1 %btn.压缩恢复记录% %btn.自解压% -w"%dir.jzip.temp%" "%path.Archive%" %path.File% %iferror%

if "%File.Single%"=="n" for %%a in (.bz2 .gz .xz) do if "%Archive.exten%"=="%%a" (
	"%path.editor.7z%" a -w"%dir.jzip.temp%" "%dir.jzip.temp%\%File.name%.tar" %path.File% %iferror%
	set "path.Archive=%dir.File%\%File.name%.tar%Archive.exten%"
	set "path.File=%dir.jzip.temp%\%File.name%.tar"
)

if "%type.editor%"=="7z" "%path.editor.7z%" a %btn.压缩加密% %btn.压缩级别% %btn.分卷压缩% -w"%dir.jzip.temp%" %btn.自解压% "%path.Archive%" %path.File% %iferror%

if "%type.editor%"=="cab" "%path.editor.cab%" -r %btn.压缩级别% n "%path.Archive%" %path.File% %iferror%


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
goto :EOF

:Archive_info
for /f "usebackq delims==" %%a in ('"%~1"') do (
	set "dir.File=%%~dpa" & set "dir.File=!dir.File:~0,-1!"
	set "File.name=%%~na"
	set "File.exten=%%~xa"
	
	dir "!path.raw.1!" /a:-d /b 1>nul 2>nul && (
		if not defined 自解压 set "path.Archive=%%~dpa%%~na!Archive.exten!"
		if defined 自解压 set "path.Archive=%%~dpa%%~na.exe"
	)
	dir "%~1" /a:d /b 1>nul 2>nul && (
		if not defined 自解压 set "path.Archive=%~1!Archive.exten!"
		if defined 自解压 set "path.Archive=%~1.exe"
	)

	title !path.Archive! %title%
)

for %%a in (7z,zip,tar,bz2,gz,xz,wim) do if /i "%Archive.exten%"==".%%a" set "type.editor=7z"
if /i "%Archive.exten%"==".rar" set "type.editor=rar"
if /i "%Archive.exten%"==".cab" set "type.editor=cab"
goto :EOF