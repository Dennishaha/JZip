
@setlocal EnableExtensions EnableDelayedExpansion

@set "jzip.branches=master"
@set "jzip.ver=3.3.8"

@set "path.jzip.launcher=%~0"
@set "dir.jzip=%~dp0" & set "dir.jzip=!dir.jzip:~0,-1!"
@set "dir.jzip.temp=%temp%\JFsoft.Jzip"

:: Mshta ���� 
@mshta "vbscript:execute(close)" 2>nul || path %path%;%SystemRoot%\SysWOW64
@mshta "vbscript:execute(close)" || (
	echo;Mstha was not found, and JZip can no longer work.
	pause >nul
	exit /b 1
)

@for %%a in (-su -help) do @if /i "%~1"=="%%a" (call :%%a & goto :EOF)

@echo off

:: ���� ComSpec 
>nul 2>nul dir "%SystemRoot%\system32\cmd.exe" /a:-d /b && set "ComSpec=%SystemRoot%\system32\cmd.exe"

:: Ԥ���� Jzip ���� 
set "dir.jzip.temp.default=%dir.jzip.temp%"
set title=-- Jzip
set FileAssoc=
set ShortCut=y
set RightMenu=y
set UIRatio=m
set ColorAuto=y

:: �����û�������Ϣ����ʱ�ļ��� 
for /f "skip=2 tokens=1,2,*" %%a in ('reg query "HKCU\Software\JFsoft.Jzip" 2^>nul') do set "%%a=%%c"
for %%a in (Dir.Jzip.Temp Color FileAssoc ShortCut RightMenu RecentTime) do >nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "%%a" /d "!%%a!" /f 
>nul reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "RecentTime" /d "%date:~0,10% %time%" /f
>nul 2>nul (dir "%dir.jzip.temp%" /a:d /b || ( md "%dir.jzip.temp%" || (set "dir.jzip.temp=%dir.jzip.temp.default%" & md "!dir.jzip.temp!") ) )

:: ��ǳɫģʽ���� 
if /i "!ColorAuto!"=="y" (
	for /f "skip=2 tokens=3" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" 2^>nul') do (
		(echo;"%%~a" | find "0x") >nul || set "ColorAuto=n"
		(echo;"%%~a" | find "0x0") >nul && set "Color=0f" || set "Color=f0"
	)
)

:: ע����������趨ʱ��������Ŀǰ����ҳ�趨�� 
if not defined Language (
	for /f "tokens=2 delims=:" %%i in ('chcp') do set /a "chcp=%%i"
	if "!chcp!"=="936" (set "Language=chs") else (set "Language=en")
)
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "Language" /d "!Language!" /f >nul


:: �������/����̨���趨����ҳ/����/��С/���ٱ༭�������Ʊ������/�������� 
reg query "HKCU\Console" /v "ForceV2" 2>nul | find "0x1" >nul && set "Console.ver=2" || set "Console.ver=1"

for %%Z in (
	chs/936/1/n/0x36/""/0x0d0000/0x0f0000/0x110000
	chs/936/2/y/0x36/"����"/0x0d0000/0x0f0000/0x110000
	en/437/1/y/0x30/""/0x080006/0x0c0007/0x12000a
	en/437/2/y/0x36/"Consolas"/0x0e0000/0x100000/0x120000
) do for /f "tokens=1-9 delims=/" %%a in ("%%Z") do (
	if /i "!Language!"=="%%~a" if "!Console.ver!"=="%%~c" >nul (
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "CodePage" /d "%%~b" /f
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontFamily" /d "%%~e" /f
		reg add "HKCU\Console\JFsoft.Jzip" /t REG_SZ /v "FaceName" /d "%%~f" /f

		if /i "!UIRatio!"=="s" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~g" /f
		if /i "!UIRatio!"=="m" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~h" /f
		if /i "!UIRatio!"=="l" reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "FontSize" /d "%%~i" /f

		if "%%~d"=="n" set echo=echo
		if "%%~d"=="y" set echo=call "%dir.jzip%\Function\Echo.cmd"

		set "chcp=%%~b"
		for /f "eol=[ tokens=1,*" %%x in ('type "%dir.jzip%\Lang\%%~a.ini"') do set "%%x%%y"
	)
)
reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "ColorTable15" /d "0xffffff" /f  >nul
reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "QuickEdit" /d "0x0" /f  >nul
reg add "HKCU\Console\JFsoft.Jzip" /t REG_DWORD /v "WindowSize" /d "0x1b0050" /f  >nul


:: Ttool ���� 
set tcol="%dir.jzip%\Bin\x86\TCol.exe"
set tcurs="%dir.jzip%\Bin\x86\Tcurs.exe"
set tmouse="%dir.jzip%\Bin\x86\tmouse.exe"
set "tmouse.process= set "mouse=^^!errorlevel^^!" & (if "^^!mouse:~0,1^^!"=="-" set "mouse=^^!mouse:~1^^!" ) & set /a "mouse.x=^^!mouse:~0,-3^^!" & set /a "mouse.y=^^!mouse^^!-1000*^^!mouse.x^^!" & set key="
set "tmouse.test= echo;[^!mouse.x^!,^!mouse.y^!] Raw: ^!mouse^! & ping localhost -n 2 >nul "

:: Jzip �ļ�֧������ 
set "jzip.spt.rar=rar"
set "jzip.spt.7z=7z zip bz2 gz tgz tar wim xz 001 cab iso img dll msi chm cpio deb dmg lzh lzma rpm udf vhd xar"
set "jzip.spt.assoc=rar 7z zip bz2 gz tgz tar wim xz 001 cab"
set "jzip.spt.write=exe rar 7z zip tar wim"
set "jzip.spt.noadd=bz2 gz xz cab"
set "jzip.spt.add=%jzip.spt.write% %jzip.spt.noadd%"

:: ѹ���༭������
set "path.editor.7z=%dir.jzip%\Bin\x86\7z.exe"
set "path.editor.rar=%dir.jzip%\Bin\x86\Rar.exe"
set "path.editor.cab=%dir.jzip%\Bin\x86\Cabarc.exe"

for /f "skip=2 tokens=3" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE 2^>nul') do (
	echo;"%%~a" | find /i "AMD64" >nul && (
		set "path.editor.7z=%dir.jzip%\Bin\x64\7z.exe"
		set "path.editor.rar=%dir.jzip%\Bin\x64\Rar.exe"
	)
	echo;"%%~a" | find /i "ARM64" >nul && (
		set "path.editor.7z=%dir.jzip%\Bin\arm64\7z.exe"
	)
)

:: ������� 
set "iferror=|| ( call "%dir.jzip%\Function\EdCode.cmd" & exit /b ^^!errorlevel^^! )"
for %%i in (VbsBox SuDo CapTrans) do call "%dir.jzip%\Function\%%i.cmd" -import

::������ 
set start.jz=start "JFsoft.Jzip" "%ComSpec%" /e:on /v:on /d /c call "%dir.jzip%\Part\main.cmd"
if exist "%~1" %start.jz% :Set_Info list %* & goto :EOF
if exist "%~2" %start.jz% :Set_Info %* & goto :EOF
%start.jz% :Main %*
exit /b 0


:-su
@call "%dir.jzip%\Function\sudo.cmd" "%path.jzip.launcher%" %*
@goto :EOF


:-help
@echo;
@echo; JFsoft JZip %jzip.ver%   2012-2021 (c) Dennishaha  %txt.rightres%
@echo;
@echo; %txt.usage%�� Jzip ^< %txt.switch% ^> ^< %txt.command% ^> ^< %txt.files% ^| %txt.archives% ^>
@echo;
@echo;   ^< %txt.switch% ^>
@echo;	-help		%txt.h.help%
@echo;	-su		%txt.h.su%
@echo;	-install	%txt.h.install%
@echo;	-setting	%txt.h.setting%
@echo;
@echo;   ^< %txt.command% ^>
@echo;	""		%txt.h.@%
@echo;	add		%txt.h.add%
@echo;	unzip		%txt.h.unzip%
@echo;
@goto :EOF
