
:: ����
for %%i in (rar exe) do if /i "%Archive.exten%"==".%%i" call :menu
goto :EOF

:menu
cls

::UI--------------------------------------------------

echo.
echo.
echo.
echo.
echo.
echo.
if /i "%Archive.exten%"==".rar" echo.                                    ������ Windows �Խ�ѹģ��ĸ���
if /i "%Archive.exten%"==".exe" echo.                                  �����Խ�ѹ�ļ��� Windows �Խ�ѹģ��
echo.
echo.
echo.                              ��-----------------------�� ��-------------��
echo.                              ��                       �� ��     64λ    ��
echo.                              ��                       �� ��-------------��
echo.                              ��                       �� ��-------------��
echo.                              ��       �Խ�ѹ�ļ�      �� ��    ����̨   ��
echo.                              ��                       �� ��-------------��
echo.                              ��                       �� ��-------------��
echo.                              ��                       �� �� ����̨��64λ��
echo.                              ��-----------------------�� ��-------------��
echo.
echo.
if /i "%Archive.exten%"==".exe" (
echo.                                   ��-----------------------------��
echo.                                   ��                             ��
echo.                                   ��   ���������Խ�ѹģ��ĸ���  ��
echo.                                   ��                             ��
echo.                                   ��-----------------------------��
) else echo.&echo.&echo.&echo.&echo.
echo.
echo.
echo.
echo.
echo.                                                                                          ��---------��
echo.                                                                                          ��   ȡ��  ��
echo.                                                                                          ��---------��

::UI--------------------------------------------------

%tmouse% /d 0 -1 1
%tmouse.process%
::%tmouse.test%

for %%A in (
	31}54}9}17}1}
	57}70}9}11}2}
	57}70}12}14}3}
	57}70}15}17}4}
	36}65}20}24}5}
	91}100}29}31}back}
) do for /f "tokens=1-5 delims=}" %%a in ("%%A") do (
	if %mouse.x% GEQ %%~a if %mouse.x% LEQ %%~b if %mouse.y% GEQ %%~c if %mouse.y% LEQ %%~d set "key=%%~e"
	)
)

if "%key%"=="1"  ( set "SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default.sfx"" & goto :next
) else if "%key%"=="2" ( set "SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default64.sfx"" & goto :next
) else if "%key%"=="3" ( set "SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon.sfx"" & goto :next
) else if "%key%"=="4" ( set "SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon64.sfx"" & goto :next
) else if "%key%"=="5" ( if /i "%Archive.exten%"==".exe" set "SfxOrder=s-" & goto :next
) else if "%key%"=="back" ( goto :EOF
)
goto :menu

:next
cls
md "%dir.jzip.temp%\%random1%" >nul

if "%type.editor%"=="rar" "%path.editor.rar%" %SfxOrder% -w%dir.jzip.temp%\%random1% "%path.Archive%" %iferror%

call "%dir.jzip%\Parts\VbsBox" MsgBox "ת����ɡ�" " " "·����%path.Archive%"
goto :EOF