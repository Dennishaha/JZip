
:more
title JFsoft Zip ѹ��
call "%dir.jzip%\Parts\Set_Lnk.cmd" -info
call "%dir.jzip%\Parts\Set_Assoc.cmd" -info
call "%dir.jzip%\Parts\Set_UI.cmd" -info
cls
echo.
echo.  �� ����
echo.
echo.
echo.                    %tips.FileAssoc% ѹ���ļ�����
echo.                    %tips.Lnk.SendTo% �Ҽ��˵���չ
echo.                    %tips.Lnk.Desktop% �����潨���ݾ�
echo.
echo.                    �趨��ɫ ^>       %ui.word%(%ui.paper%)
echo.
echo.                    ����Ŀ¼
echo.                      %dir.jzip.temp%
echo.                    ��-------����-------����-------����-------��
echo.                    ��  �� ����  ��� ���� �Զ��婦��  Ĭ�� ��
echo.                    ��-------����-------����-------����-------��
echo.
echo.                    �汾 %jzip.ver%
echo.                    ��---------����---------��
echo.                    �� �����©��� ǰ��������  ж��
echo.                    ��---------����---------��
echo.
echo.
%tmouse% /d 0 -1 1
%tmouse.process%

for %%A in (
	2}9}0}2}1}
	20}21}4}4}2}
	20}21}5}5}3}
	20}21}6}6}4}
	20}47}8}8}5}
	21}28}12}14}6}
	30}37}12}14}7}
	39}46}12}14}8}
	48}55}12}14}9}
	21}30}17}19}10}
	32}41}17}19}11}
	44}47}18}18}12}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"== "1" ( goto :EOF
) else if "%key%"== "2" ( call "%dir.jzip%\Parts\Set_Assoc.cmd" -switch
) else if "%key%"== "3" ( call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch sendto
) else if "%key%"== "4" ( call "%dir.jzip%\Parts\Set_Lnk.cmd" -switch desktop
) else if "%key%"== "5" ( call "%dir.jzip%\Parts\Set_UI.cmd"
) else if "%key%"== "6" ( start "" "%dir.jzip.temp%"
) else if "%key%"== "7" ( call :���Temp
) else if "%key%"== "8" ( call :�Զ���Temp
) else if "%key%"== "9" ( call :Ĭ��Temp
) else if "%key%"== "10" ( call "%dir.jzip%\Parts\VerControl.cmd" -upgrade
) else if "%key%"== "11" ( explorer "https://github.com/dennishaha/Jzip"
) else if "%key%"== "12" ( call "%dir.jzip%\Parts\VerControl.cmd" -uninstall
)
goto :more


:���Temp
if defined dir.jzip.temp >nul (
	rd /q /s "%dir.jzip.temp%"
	md "%dir.jzip.temp%"
) && (
	mshta "vbscript:msgbox("��ʱ�ļ������ɡ�",64,"��ʾ")(window.close)" 
) || (
	mshta "vbscript:msgbox("�����ʱ�ļ��������⣬���Ժ����ԡ�",64,"��ʾ")(window.close)"
)
goto :EOF


:�Զ���Temp
call "%dir.jzip%\Parts\Select_Folder.cmd" key
if not defined key goto :EOF
dir /a /b "!key!" | findstr .* >nul && (
	mshta "vbscript:msgbox("��ѡ����յ��ļ��У�����һ�Ρ�",64,"��ʾ")(window.close)"
	goto :��ʱ�ļ���
)
dir /a /b "!key!" | findstr .* >nul || (
	set "dir.jzip.temp=!key!"
	reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
)
goto :EOF


:Ĭ��Temp
set "dir.jzip.temp=%temp%\JFsoft.Jzip"
md %dir.jzip.temp% >nul 2>nul
reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "dir.jzip.temp" /d "!dir.jzip.temp!" /f >nul
goto :EOF


