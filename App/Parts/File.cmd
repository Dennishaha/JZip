:: Ԥ�趨Ŀ¼
set "dir.list=%userprofile%\desktop"

:listdir
title %dir.list% %title%
cls

dir "%dir.list%" %ViewExten%

echo.������������������������������������������������������������������������������
echo. [1]�� [2]��һ�� [3]��ӵ�ѹ���� [4]��ѹ���ļ� [0]����
%choice% /c:12340 /n
set "key=%errorlevel%"
if "%key%"=="1" (
	set "list.typein=" & set /p "list.typein=�򿪣�"

	:: dir �ж�·��ΪĿ¼���趨���� dir.list Ϊ��Ŀ¼
	dir "!dir.list!\!list.typein!" /a:d /b >nul 2>nul && set "dir.list=!dir.list!\!list.typein!"
	echo.!list.typein! | find ":" && ( dir "!list.typein!" /a:d /b >nul 2>nul && set "dir.list=!list.typein!" )

	:: dir �ж�·��Ϊ�ļ���ǰ���Ǹ�·��������Ŀ¼��
	dir "!dir.list!\!list.typein!" /a:d /b >nul 2>nul || (
		dir "!dir.list!\!list.typein!" /a:-d /b >nul 2>nul && (
			for /f "usebackq tokens=1* delims==" %%a in ('"!dir.list!\!list.typein!"') do (

				:: ������չ�����ļ�ʹ�� Jzip �򿪡�
				for %%A in (%jzip.spt.open%) do if /i "%%~xa"==".%%A" (
					call "!path.jzip.launcher!" "%%~a"
					set "errorlevel=1"
				)
				:: ������չ�����ļ�ʹ�� start �򿪡�
				if "!errorlevel!"=="0" start "" "!dir.list!\!list.typein!"
				set "errorlevel="
			)
		)
	)
)
if "%key%"=="2" set "dir.list=!dir.list!\.."
if "%key%"=="3" (
	set "list.typein=" & set /p "list.typein=ѡ���ļ���ӣ�"
	if exist "!dir.list!\!list.typein!" call "%path.jzip.launcher%" add "!dir.list!\!list.typein!"
)
if "%key%"=="4" (
	set "list.typein=" & set /p "list.typein=ѡ���ļ���ѹ����"
	dir "!dir.list!\!list.typein!" /a:-d /b >nul 2>nul && call "%path.jzip.launcher%" unzip "!dir.list!\!list.typein!"
)
if "%key%"=="5" set "key=" & goto :EOF
goto :listdir
