
@setlocal EnableExtensions EnableDelayedExpansion

@set "jzip.branches=master"
@set "jzip.ver=3.3.18"

@set "path.jzip.launcher=%~0"
@set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
@set "dir.jzip.temp=%temp%\JFsoft.Jzip"

:: Mshta 配置 
@mshta "vbscript:execute(close)" 2>nul || path !path!;"%SystemRoot%\SysWOW64"
@mshta "vbscript:execute(close)" || (
	echo;Mstha was not found, and JZip can no longer work.
	pause >nul
	exit /b 1
)

:: 获取管理员权限跳转（此处避免英文括号使用）
@if /i "%~1"=="-su" call :%*
@if /i "%~1"=="-su" exit /b 0
@echo off

:: 设置 ComSpec 
2>nul (if exist "%SystemRoot%\system32\cmd.exe" set "ComSpec=%SystemRoot%\system32\cmd.exe")

:: 预配置 Jzip 环境 
set "dir.jzip.temp.default=%dir.jzip.temp%"
set title=-- Jzip
set FileAssoc=n
set ShortCut=y
set RightMenu=y
set UIRatio=m
set Color=f0
set ColorAuto=y

:: 加载用户配置信息及临时文件夹 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip" 2^>nul') do set "%%a=%%c"
for %%a in (Dir.Jzip.Temp Color FileAssoc ShortCut RightMenu RecentTime) do >nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 
>nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "RecentTime" /d "%date:~0,10% %time%" /f
>nul 2>nul (dir "%dir.jzip.temp%" /a:d /b || ( md "%dir.jzip.temp%" || (set "dir.jzip.temp=%dir.jzip.temp.default%" & md "!dir.jzip.temp!") ) )

:: 深浅色模式配置 
if /i "!ColorAuto!"=="y" (
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" | find "0x" || set "ColorAuto=n"
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" | find "0x0" && set "Color=0f" || set "Color=f0"
) >nul 2>nul

:: 注册表无语言设定时，则依据目前代码页设定。 
if not defined Language (
	for /f "tokens=2 delims=:" %%i in ('chcp') do set /a "chcp=%%i"
	if "!chcp!"=="936" (set "Language=chs") else (set "Language=en")
)
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Language" /d "!Language!" /f >nul

:: 控制台设置为传统控制台 
>nul (reg query "HKCU\Console\%%%%Startup" /v "DelegationConsole" | find "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}" || reg add "HKCU\Console\%%%%Startup" /t REG_SZ /v "DelegationConsole" /d "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}" /f)
>nul (reg query "HKCU\Console\%%%%Startup" /v "DelegationTerminal" | find "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}" || reg add "HKCU\Console\%%%%Startup" /t REG_SZ /v "DelegationTerminal" /d "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}" /f)

:: 检测语言/控制台，设定代码页/字体/大小/快速编辑，加载制表符补偿/语言配置 
reg query "HKCU\Console" /v "ForceV2" 2>nul | find "0x1" >nul && set "Console.ver=2" || set "Console.ver=1"

chcp 65001 >nul 

for %%Z in (
	chs/936/1/n/0x36/"新宋体"/0x0d0000/0x0f0000/0x110000
	chs/936/2/y/0x36/"黑体"/0x0d0000/0x0f0000/0x110000
	en/437/1/y/0x36/"Consolas"/0x0e0000/0x100000/0x120000
	en/437/2/y/0x36/"Consolas"/0x0e0000/0x100000/0x120000
) do for /f "tokens=1-9 delims=/" %%a in ("%%Z") do (
	if /i "!Language!"=="%%~a" if "!Console.ver!"=="%%~c" (
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "CodePage" /d "%%~b" /f
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontFamily" /d "%%~e" /f
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_SZ /v "FaceName" /d "%%~f" /f

		if /i "!UIRatio!"=="s" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~g" /f
		if /i "!UIRatio!"=="m" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~h" /f
		if /i "!UIRatio!"=="l" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~i" /f

		if "%%~d"=="n" set echo=echo
		if "%%~d"=="y" set echo=call "%dir.jzip%\Function\Echo.cmd"

		set "chcp=%%~b"
	) >nul
)

>nul (
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "ColorTable00" /d "0x0" /f
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "ColorTable15" /d "0xffffff" /f
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontWeight" /d "0x190" /f
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "QuickEdit" /d "0x0" /f
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "WindowSize" /d "0x1b0050" /f
	reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "ScreenBufferSize" /d "0x1b0050" /f
)

:: 读取语言包
for /f "eol=[ tokens=1,*" %%x in ('type "%dir.jzip%\Lang\!Language!.ini"') do set "%%x%%y"
chcp %chcp% >nul 

:: Ttool 配置 
set tcol=>nul 2>nul "%dir.jzip%\Bin\x86\TCol.exe"
set tcurs=>nul 2>nul "%dir.jzip%\Bin\x86\Tcurs.exe"
set tmouse=>nul 2>nul "%dir.jzip%\Bin\x86\tmouse.exe"
set "tmouse.process= set "mouse=^^!errorlevel^^!" & (if "^^!mouse:~0,1^^!"=="-" set "mouse=^^!mouse:~1^^!" ) & set /a "mouse.x=^^!mouse:~0,-3^^!" & set /a "mouse.y=^^!mouse^^!-1000*^^!mouse.x^^!" & set key="
set "tmouse.test= echo;[^!mouse.x^!,^!mouse.y^!] Raw: ^!mouse^! & ping localhost -n 2 >nul "

:: Jzip 文件支持类型 
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z zip bz2 gz tgz tar wim xz 001 cab iso img dll msi chm cpio deb dmg lzh lzma rpm udf vhd xar"
set "jzip.spt.assoc=rar 7z zip bz2 gz tgz tar wim xz 001 cab"
set "jzip.spt.write=exe rar 7z zip tar wim"
set "jzip.spt.noadd=bz2 gz xz cab"
set "jzip.spt.add=%jzip.spt.write% %jzip.spt.noadd%"

:: 压缩编辑器配置
set "path.editor.7z=%dir.jzip%\Bin\x86\7z.exe"
set "path.editor.rar=%dir.jzip%\Bin\x86\Rar.exe"
set "path.editor.cab=%dir.jzip%\Bin\x86\Cabarc.exe"

for /f "skip=2 tokens=3" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE 2^>nul') do (
	if /i "%%~a"=="AMD64" (
		if exist "%dir.jzip%\Bin\x64\7z.exe" set "path.editor.7z=%dir.jzip%\Bin\x64\7z.exe"
		if exist "%dir.jzip%\Bin\x64\Rar.exe" set "path.editor.rar=%dir.jzip%\Bin\x64\Rar.exe"
	)
	if /i "%%~a"=="ARM" (
		if exist "%dir.jzip%\Bin\arm\7z.exe" set "path.editor.7z=%dir.jzip%\Bin\arm\7z.exe"
	)
	if /i "%%~a"=="ARM64" (
		if exist "%dir.jzip%\Bin\arm64\7z.exe" set "path.editor.7z=%dir.jzip%\Bin\arm64\7z.exe"
	)
)

:: 配置组件 
set iferror=^|^|(call "%dir.jzip%\Function\EdCode.cmd" ^& exit /b ^^!errorlevel^^! )
set echocut=call "%dir.jzip%\Function\EchoCut.cmd"
for %%i in (VbsBox SuDo CapTrans) do call "%dir.jzip%\Function\%%i.cmd" -import

:: 帮助信息跳转 
if /i "%~1"=="-help" (call :-help & goto :EOF)

:: 被调用 
set start.jz=start "JFsoft.Jzip" "%ComSpec%" /e:on /v:on /d /c call "%dir.jzip%\Part\main.cmd"
if exist "%~1" %start.jz% :Set_Info list %* & goto :EOF
if exist "%~2" %start.jz% :Set_Info %* & goto :EOF
%start.jz% :Main %*
exit /b 0


:-su
@call "%dir.jzip%\Function\sudo.cmd" "%path.jzip.launcher%" %*
@exit /b 0


:-help
echo;
echo; JFsoft JZip %jzip.ver%   2012-2023 (c) Dennishaha  %txt.rightres%
echo;
echo; %txt.usage%： Jzip ^< %txt.switch% ^> ^< %txt.command% ^> ^< %txt.files% ^| %txt.archives% ^>
echo;
echo;   ^< %txt.switch% ^>
echo;	-help		%txt.h.help%
echo;	-su		%txt.h.su%
echo;	-install	%txt.h.install%
echo;	-setting	%txt.h.setting%
echo;
echo;   ^< %txt.command% ^>
echo;	""		%txt.h.@%
echo;	add		%txt.h.add%
echo;	unzip		%txt.h.unzip%
echo;
echo;
pause
