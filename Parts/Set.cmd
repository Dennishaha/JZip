
:more
title JFsoft Zip %jzip.ver% %processor_architecture%
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_FastEdit.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
call :�鿴����չ -info
cls
echo.
echo.  ^<  Jzip ����                                                       [K] ж��
echo.������������������������������������������������������������������������������
echo.
echo.                [1] �Ҽ��˵�����          %tips.Lnk.SendTo%
echo.                [2] �����潨���ݾ�        %tips.Lnk.Desktop%
echo.
echo.                [3] ������ɫ�趨 ^>        %ui.word%(%ui.paper%)
echo.                [4] ���ٱ༭ģʽ          %tips.FastEdit%
echo.                [5] �ļ��鿴����չ        %ui.�鿴����չ%
echo.
echo.                    ��ʱ�ļ���
echo.                    %dir.jzip.temp%
echo.                    [6]�� [7]�Զ��� [8]�ָ�Ĭ��
echo.
echo.                [A] ������
echo.                [B] ǰ�� Jzip �ٷ���վ
echo.                [C] ���� Jzip
echo.
echo.                [0] ����ѡ��
echo.
echo. ���벢�س���ѡ��...
echo.-----------------------
%choice% /c:12345678abck0 /n
set "next=%errorlevel%"
if "%next%"=="1" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
if "%next%"=="2" call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
if "%next%"=="3" call "%dir.jzip%\Parts\Set_UI.cmd"
if "%next%"=="4" call "%dir.jzip%\Parts\Set_FastEdit.cmd" -switch
if "%next%"=="5" call :�鿴����չ -switch
if "%next%"=="6" start "" "%dir.jzip.temp%"
if "%next%"=="7" call :��ʱ�ļ���
if "%next%"=="8" call :��ʱ�ļ��� default
if "%next%"=="9" call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
if "%next%"=="10" explorer "http://jfsoft.cc/jzip"
if "%next%"=="11" call :About_Jzip
if "%next%"=="12" call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
if "%next%"=="13" set "next=" & goto :EOF
goto :more

:��ʱ�ļ���
if "%~1"=="" set dir.jzip.temp.new=&set /p dir.jzip.temp.new=�������·����
if "%~1"=="default" set dir.jzip.temp.new=%temp%\JFsoft\Jzip
del /q /f /s "%dir.jzip.temp%"& rd /q /s "%dir.jzip.temp%"
if not exist "%dir.jzip.temp.new%" md "%dir.jzip.temp.new%"
if exist "%dir.jzip.temp.new%" (set dir.jzip.temp=%dir.jzip.temp.new%) else (echo.��Ǹ����ʱ�޷����ø�Ŀ¼��&pause)
call "%dir.jzip%\Parts\Set_Refresh.cmd"
goto :EOF

:�鿴����չ
if "%1"=="-info" if "%�鿴����չ%"=="y" (set "ui.�鿴����չ=��") else (set "ui.�鿴����չ=��")
if "%1"=="-switch" (
	if "%�鿴����չ%"=="" set "�鿴����չ=y"
	if "%�鿴����չ%"=="y" set "�鿴����չ="
	call "%dir.jzip%\Parts\Set_Refresh.cmd"
	start "" cmd /c ""%path.jzip.launcher%" -setting" & Exit
)
goto :EOF

:About_Jzip
cls
more /e <"%dir.jzip%\Components\About.txt"
pause
goto :EOF
