
:more
title JFsoft Zip ѹ��
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_FastEdit.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
call :�鿴����չ -info
cls
echo.
echo.  ^<  Jzip ����                                                       [K] ж��
echo.������������������������������������������������������������������������������
echo.
echo.                [1] %tips.Lnk.SendTo% �Ҽ��˵�����          
echo.                [2] %tips.Lnk.Desktop% �����潨���ݾ�        
echo.
echo.                [3]    ������ɫ�趨 ^>   %ui.word%(%ui.paper%)
echo.                [4] %tips.FastEdit% ���ٱ༭ģʽ          
echo.                [5] %ui.�鿴����չ% �ļ��鿴����չ        
echo.
echo.                    ����Ŀ¼
echo.                    %dir.jzip.temp%
echo.                    [6]�� [7]�Զ��� [8]�ָ�Ĭ��
echo.
echo.                [A] ������  %jzip.ver%
echo.                [B] ǰ�� Jzip ��Ŀ 
echo.
echo.                [0] ����ѡ��
echo.
echo.
echo. ���벢�س���ѡ��...
echo.-----------------------
%choice% /c:12345678abk0 /n
set "key=%errorlevel%"
if "%key%"=="1" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
if "%key%"=="2" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
if "%key%"=="3" call "%dir.jzip%\Parts\Set_UI.cmd"
if "%key%"=="4" call "%dir.jzip%\Parts\Set_FastEdit.cmd" -switch
if "%key%"=="5" call :�鿴����չ -switch
if "%key%"=="6" start "" "%dir.jzip.temp%"
if "%key%"=="7" call :��ʱ�ļ���
if "%key%"=="8" call :��ʱ�ļ��� default
if "%key%"=="9" call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
if "%key%"=="10" explorer "https://github.com/dennishaha/Jzip"
if "%key%"=="11" call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
if "%key%"=="12" set "key=" & goto :EOF
goto :more

:��ʱ�ļ���
if "%~1"=="default" set dir.jzip.temp.new=%temp%\JFsoft\Jzip
if "%~1"=="" set dir.jzip.temp.new=&set /p dir.jzip.temp.new=�������·����
md "%dir.jzip.temp.new%" && (
	set dir.jzip.temp=%dir.jzip.temp.new%
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f 1>nul
	rd /q /s "%dir.jzip.temp%"
) || (
	pause 1>nul
)
goto :EOF

:�鿴����չ
if "%1"=="-info" if "%�鿴����չ%"=="y" (set "ui.�鿴����չ=��") else (set "ui.�鿴����չ=��")
if "%1"=="-switch" (
	if "%�鿴����չ%"=="" set "�鿴����չ=y"
	if "%�鿴����չ%"=="y" set "�鿴����չ="
	reg add "HKEY_CURRENT_USER\Software\JFsoft.Jzip" /t REG_SZ /v "�鿴����չ" /d "!�鿴����չ!" /f 1>nul
	start "" cmd /c ""%path.jzip.launcher%" -setting" & Exit
)
goto :EOF
