
::调用
if not "%~1"=="" call :%*
goto :EOF

:压缩格式切换
if /i "%自解压%"=="y" call :自解压模块 -default
goto :EOF

:压缩加密
if /i "%压缩加密%"=="y" (
	set "压缩加密="
	set "压缩密码="
	goto :EOF
)
if /i "%压缩加密%"=="" (
	set "压缩加密=y"
	set "压缩密码="&set /p "压缩密码=--设定压缩密码："
	if "!压缩密码!"=="" set "压缩加密="
	goto :EOF
)
set "压缩加密=" & goto :EOF

:压缩级别
for %%A in (0:1,1:2,2:3,3:4,4:5,5:0) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%压缩级别%"=="%%a" set "压缩级别=%%b" & goto :EOF
	)
)
goto :EOF

:固实文件
if /i "%固实文件%"=="y" set "固实文件=" & goto :EOF
if /i "%固实文件%"=="" set "固实文件=y" & goto :EOF
set "固实文件=" & goto :EOF

:分卷压缩
set 分卷压缩=&set /p "分卷压缩=-- 设定分卷压缩大小 [大小|单位] k/m/g ："
if "%分卷压缩%"=="" set "分卷压缩="&goto :EOF
set "分卷压缩=%分卷压缩%" & goto :EOF

:压缩版本.rar
if /i "%压缩版本.rar%"=="5" set "压缩版本.rar=4" & goto :EOF
if /i "%压缩版本.rar%"=="4" set "压缩版本.rar=5" & goto :EOF
set "压缩版本.rar=5" & goto :EOF

:自解压

if /i "%自解压%"=="y" set "自解压=" & set "自解压模块=" & goto :EOF
if /i "%自解压%"=="" set "自解压=y" & set "自解压模块=a32" & goto :EOF
set "自解压=" & goto :EOF

:自解压模块
if "%~1"=="-default" set "自解压模块=a32" & goto :EOF
if /i "%自解压%"=="y" (
	for %%A in (
		.rar:a32:a64,
		.rar:a64:b32,
		.rar:b32:b64,
		.rar:b64:a32,
		.7z:a32:b32,
		.7z:b32:a32,
		.zip:a32:a64,
		.zip:a64:a32,
	) do (
		for /f "tokens=1,2,3 delims=:" %%a in ("%%A") do (
			if "%Archive.exten%"=="%%a" if "%自解压模块%"=="%%b" set "自解压模块=%%c" & goto :EOF
		)
	)
)
goto :EOF

:目标路径
set /p "path.Archive=-- 请输入压缩档路径："
goto :EOF
