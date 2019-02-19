
::调用
call :%*
goto :EOF

:压缩格式切换
set "Archive.exten=.%~1"
if /i not "%自解压%"=="" call :自解压 -default
goto :EOF

:压缩加密
set "key="
if "%~1"=="" (
	if defined 压缩密码 ( set "压缩密码=" ) else ( set "key=1" )
) else (
	if defined 压缩密码 set "key=1"
)
if "%key%"=="1" %InputBox% 压缩密码 "%txt_aas.passwd%"
goto :EOF

:压缩级别
for %%i in (0 1 2 3 4 5) do if "%~1"=="%%i" (
	set "压缩级别=%%i"
	goto :EOF
)
goto :EOF

:固实文件
if /i "%固实文件%"=="y" set "固实文件=" & goto :EOF
if /i "%固实文件%"=="" set "固实文件=y" & goto :EOF
set "固实文件=" & goto :EOF

:分卷压缩
set "key="
if "%~1"=="" (
	if defined 分卷压缩 ( set "分卷压缩=" ) else ( set "key=1" )
) else (
	if defined 分卷压缩 set "key=1"
)
if "%key%"=="1" %InputBox% 分卷压缩 "%txt_aas.split%" " " "%txt_aas.unit%"
goto :EOF

:压缩版本.rar
if /i "%压缩版本.rar%"=="5" set "压缩版本.rar=4" & goto :EOF
if /i "%压缩版本.rar%"=="4" set "压缩版本.rar=5" & goto :EOF
set "压缩版本.rar=5" & goto :EOF

:压缩恢复记录
if "%~1"=="" (
	if defined 压缩恢复记录 ( set "压缩恢复记录=" ) else ( set "压缩恢复记录=3" )
) else (
	for %%A in (3/6 6/9 9/3) do (
		for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
			if "%压缩恢复记录%"=="%%~a" set "压缩恢复记录=%%~b" & goto :EOF
		)
	)
)
goto :EOF

:自解压
if "%~1"=="-default" (
	set "自解压="
	for %%i in (rar 7z) do if "%Archive.exten%"==".%%i" set "自解压=a32"
	goto :EOF
)
if "%~1"=="" (
	if defined 自解压 ( set "自解压=" ) else ( set "自解压=a32" )
) else (
	for %%A in (
		rar/a32/a64,rar/a64/b32,rar/b32/b64,rar/b64/a32,
		7z/a32/b32,7z/b32/a32,
		zip/a32/a64,zip/a64/a32,
	) do (
		for /f "tokens=1,2,3 delims=/" %%a in ("%%A") do (
			if "%Archive.exten%"==".%%~a" if "%自解压%"=="%%~b" set "自解压=%%~c" & goto :EOF
		)
	)
)
goto :EOF

:更改名称
%InputBox% key1 "%txt_aas.zipname%"
if not defined key1 goto :EOF
set "Archive.name=%key1%"
for /f "delims=" %%i in ("%Archive.name%") do (
	if "%Archive.exten%"=="%%~xi" set "Archive.name=%%~ni"
)
goto :EOF

:浏览
call "%dir.jzip%\Function\Select_File.cmd" key1
if not defined key1 goto :EOF
for /f "delims=" %%i in ("%key1%") do (
	for %%a in (%jzip.spt.write%) do if /i "%%~xi"==".%%a" (
		if /i "%%~xi"==".exe" (
			"%path.editor.7z%" l "%%~i" | findstr /r /c:"^Type = 7z.*" >nul && ( set "Archive.exten=.7z" & set "自解压=y" )
			"%path.editor.rar%" l "%%~i" | findstr /r /c:"^Details: RAR.*" >nul && ( set "Archive.exten=.rar" & set "自解压=y" )
			if not "!自解压!"=="y" %MsgBox% "%txt_notzip%" " " "%%~i" & goto :EOF
		) else (
			set "Archive.exten=%%~xi"
		)
		set "Archive.dir=%%~dpi"
		set "Archive.name=%%~ni"
		goto :EOF
	)
	for %%a in (%jzip.spt.write.noadd%) do if /i "%%~xi"==".%%a" (
		%MsgBox% "%txt_cantadd%" " " "%%~i" & goto :EOF
	)
	%MsgBox% "%txt_notzip%" " " "%%~i"
)
goto :EOF

:更改路径
call "%dir.jzip%\Function\Select_Folder.cmd" key1
if not defined key1 goto :EOF
set "Archive.dir=%key1%\"
goto :EOF
