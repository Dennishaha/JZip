
:more
title JFsoft Zip ѹ��
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_Assoc.cmd" -info
call "%dir.jzip%\Parts\Set_FastEdit.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
call :�鿴����չ -info
cls
echo.
echo.  ^<  Jzip ����                                                       [K] ж��
echo.������������������������������������������������������������������������������
echo.
echo.                [1] %tips.FileAssoc% ѹ���ļ�����
echo.                [2] %tips.Lnk.SendTo% �Ҽ��˵���չ
echo.                [3] %tips.Lnk.Desktop% �����潨���ݾ�
echo.
echo.                [4]    ������ɫ�趨 ^>   %ui.word%(%ui.paper%)
echo.                [5] %tips.FastEdit% ���ٱ༭ģʽ
echo.                [6] %ui.�鿴����չ% �ļ��鿴����չ
echo.
echo.                    ����Ŀ¼
echo.                    %dir.jzip.temp%
echo.                    �ߴ� ���Զ��� ��ָ�Ĭ��
echo.
echo.                [A] ������  %jzip.ver%
echo.                [B] ǰ�� Jzip ��Ŀ
echo.
echo.                [0] ������
echo.
echo. ���벢�س���ѡ��...
echo.-----------------------
%choice% /c:123456789abk0 /n
set "key=%errorlevel%"
if "%key%"=="1" call "%dir.jzip%\Parts\Set_Assoc.cmd" -switch
if "%key%"=="2" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
if "%key%"=="3" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
if "%key%"=="4" call "%dir.jzip%\Parts\Set_UI.cmd"
if "%key%"=="5" call "%dir.jzip%\Parts\Set_FastEdit.cmd" -switch
if "%key%"=="6" call :�鿴����չ -switch
if "%key%"=="7" start "" "%dir.jzip.temp%"
if "%key%"=="8" call :��ʱ�ļ���
if "%key%"=="9" call :��ʱ�ļ��� default
if "%key%"=="10" call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
if "%key%"=="11" explorer "https://github.com/dennishaha/Jzip"
if "%key%"=="12" call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
if "%key%"=="13" set "key=" & goto :EOF
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
