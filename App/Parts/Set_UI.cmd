
::�����ж�
set "color.list=0/��,1/��,2/��,3/��,4/��,5/��,6/��,7/ǳ��,8/���,9/ǳ��,a/ǳ��,b/ǳ��,c/ǳ��,d/ǳ��,e/ǳ��,f/��"

if "%~1"=="-info" call :text_color
if "%~1"=="" call :start
goto :eof


:text_color
for %%A in (!color.list!) do (
	for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
		if "%������ɫ:~1,1%"=="%%a" set "ui.word=%%b"
		if "%������ɫ:~0,1%"=="%%a" set "ui.paper=%%b"
	)
)
goto :EOF

:start
if not defined ui.mouse set "ui.mouse=word"
color %������ɫ%
cls
echo.
echo.  ��  Jzip ������ɫ����
echo.
echo.
echo.
if "%ui.mouse%"=="paper" (
echo.                                                    ��-----------��
echo.                 ����·���ɫ�趨   ^< ����ɫ ^>      ��  �趨���� ��
echo.                                                    ��-----------��
)
if "%ui.mouse%"=="word" (
echo.                                                    ��-----------��
echo.                 ����·���ɫ�趨   [ ����ɫ ]      ��  �趨���� ��
echo.                                                    ��-----------��
)
echo.
echo.
echo.
echo.
set "ui.colorselect=   ��     ���    ǳ��     ��   "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%������ɫ:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%������ɫ:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.                     !ui.colorselect!
echo.
echo.
set "ui.colorselect=   ��      ��      ��      ��      ��      ��   "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%������ɫ:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%������ɫ:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.             !ui.colorselect!
echo.
echo.
set "ui.colorselect=  ǳ��    ǳ��    ǳ��    ǳ��    ǳ��    ǳ��  "
for %%A in (!color.list!) do for /f "tokens=1-2 delims=/" %%a in ("%%A") do (
	if "%������ɫ:~1,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =[ %%~b ]!"
	if "%������ɫ:~0,1%"=="%%~a" set "ui.colorselect=!ui.colorselect:  %%~b  =< %%~b >!"
)
echo.             !ui.colorselect!
echo.
echo.
echo.

%tmouse% /d 0 -1 1
%tmouse.process%

for %%A in (
	3}22}0}2}back}
	53}64}5}7}change}
	14}19}14}16}��}
	14}19}17}19}ǳ��}
	22}27}11}13}��}
	22}27}14}16}��}
	22}27}17}19}ǳ��}
	30}35}11}13}���}
	30}35}14}16}��}
	30}35}17}19}ǳ��}
	38}43}11}13}ǳ��}
	38}43}14}16}��}
	38}43}17}19}ǳ��}
	46}51}11}13}��}
	46}51}14}16}��}
	46}51}17}19}ǳ��}
	54}59}14}16}��}
	54}59}17}19}ǳ��}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if defined mouse.x if defined mouse.y (
		if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d (set "key=%%~e")
	)
)

if "%key%"=="change" ( if "%ui.mouse%"=="paper" set "ui.mouse=word" ) & ( if "%ui.mouse%"=="word" set "ui.mouse=paper" )
if "%key%"=="back" goto :EOF

for %%A in (!color.list!) do for /f "tokens=1,2 delims=/" %%a in ("%%A") do (
	if "%key%"=="%%b" (
		if "%ui.mouse%"=="word" if not "%������ɫ:~0,1%"=="%%a" set "������ɫ=%������ɫ:~0,1%%%a"
		if "%ui.mouse%"=="paper" if not "%������ɫ:~1,1%"=="%%a" set "������ɫ=%%a%������ɫ:~1,1%"
		reg add "HKCU\Software\JFsoft.Jzip" /t REG_SZ /v "������ɫ" /d "!������ɫ!" /f >nul
	)
)
goto :start

