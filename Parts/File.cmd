::Ԥ�趨Ŀ¼
set "dir.list=%userprofile%\desktop"

:listdir
title %dir.list% %title%
cls

dir "%dir.list%"

echo.������������������������������������������������������������������������������
echo. [1]�� [2]��һ�� [3]��ӵ�ѹ���� [4]��ѹ���ļ� [0]����
%choice% /c:12340 /n
set "next=%errorlevel%"
if "%next%"=="1" (
	set "list.typein="&set /p "list.typein=�򿪣�"
	dir "!dir.list!\!list.typein!" /a:d /b 1>nul 2>nul && set "dir.list=!dir.list!\!list.typein!"
	dir "!dir.list!\!list.typein!" /a:-d /b 1>nul 2>nul && start "" "!dir.list!\!list.typein!"
)
if "%next%"=="2" set "dir.list=!dir.list!\.."
if "%next%"=="3" (
	set "list.typein="&set /p "list.typein=ѡ���ļ���ӣ�"
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" add !dir.list!\!list.typein!
)
if "%next%"=="4" (
	set "list.typein="&set /p "list.typein=ѡ���ļ���ѹ����"
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" unzip !dir.list!\!list.typein!
)
if "%next%"=="5" set "next=" & goto :EOF
goto :listdir



