
::�����ж�
if "%~1"=="-info" call :text_color
if "%~1"=="" call :start
goto :eof


:text_color
for %%A in (0:��,1:��,2:��,3:ǳ��,4:��,5:��,6:��,7:��,8:��,9:����,a:����,b:��ǳ��,c:����,d:����,e:����,f:����) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%������ɫ:~1,1%"=="%%a" set "ui.word=%%b"
		if "%������ɫ:~0,1%"=="%%a" set "ui.paper=%%b"
	)
)
goto :EOF

:start
call :text_color
if not defined ui.mouse set "ui.mouse=word"
color %������ɫ%
cls
echo.
echo.  ^<  Jzip ������ɫ����
echo.������������������������������������������������������������������������������
echo.
if "%ui.mouse%"=="word" echo.                   ^>^>^>  [Q] ����        %ui.word%
if not "%ui.mouse%"=="word" echo.                        [Q] ����        %ui.word%
echo.
if "%ui.mouse%"=="paper" echo.                   ^>^>^>  [W] ��ɫ        %ui.paper%
if not "%ui.mouse%"=="paper" echo.                        [W] ��ɫ        %ui.paper%
echo.
if errorlevel 1 echo.                 ��ǰ��ɫ����Ч�����ֺ͵�ɫһ�»ᵼ���޷���ʾ���ݡ�
echo.
echo.                         0 = ��ɫ       8 = ��ɫ
echo.                         1 = ��ɫ       9 = ����ɫ
echo.                         2 = ��ɫ       A = ����ɫ
echo.                         3 = ǳ��ɫ     B = ��ǳ��ɫ
echo.                         4 = ��ɫ       C = ����ɫ
echo.                         5 = ��ɫ       D = ����ɫ
echo.                         6 = ��ɫ       E = ����ɫ
echo.                         7 = ��ɫ       F = ����ɫ
echo.
echo.                      ^< [N] ����   
echo.
echo.���ü���ѡ�񲢻س�...
echo.-----------------------
%choice% /c:qwn0123456789abcdef /n
set "key=%errorlevel%"
if "%key%"=="1" set "ui.mouse=word"
if "%key%"=="2" set "ui.mouse=paper"
if "%key%"=="3" goto :EOF

for %%A in (4:0,5:1,6:2,7:3,8:4,9:5,10:6,11:7,12:8,13:9,14:a,15:b,16:c,17:d,18:e,19:f) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%key%"=="%%a" (
			if "%ui.mouse%"=="word" set "������ɫ=%������ɫ:~0,1%%%b"
			if "%ui.mouse%"=="paper" set "������ɫ=%%b%������ɫ:~1,1%"
			reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "������ɫ" /d "!������ɫ!" /f >nul
		)
	)
)
goto :start