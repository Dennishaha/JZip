:Ԥ��ֵ
if /i "%Archive.exten%"==".exe" goto :menu-exe
if /i "%Archive.exten%"==".rar" goto :menu-rar

:menu-rar
cls
echo.
echo.
echo.
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.                    �������Խ�ѹģ��ĸ��� (.rar ^>^> .exe)
echo. 
echo.                         [1] �Խ�ѹѹ���ļ�   (Ĭ��)
echo.                         [2] �Խ�ѹѹ���ļ�   (64λ)
echo.
echo.                         [3] ����̨�Խ�ѹѹ���ļ�
echo.                         [4] ����̨�Խ�ѹѹ���ļ� (64λ)
echo.
echo.                         [0] ����
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.
echo.
echo.���ü���ѡ�񲢻س�...
echo.-----------------------
%choice% /c:12340 /n
set "next=%errorlevel%"
if "%next%"=="1" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default.sfx"& goto :next
if "%next%"=="2" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\default64.sfx"& goto :next
if "%next%"=="3" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon.sfx"& goto :next
if "%next%"=="4" set SfxOrder=s -sfx"%dir.jzip%\Components\Sfx\wincon64.sfx"& goto :next
if "%next%"=="5" goto :EOF
goto :menu-rar

:menu-exe
cls
echo.
echo.
echo.
echo.
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.                   ���������Խ�ѹģ��ĸ��� (.exe ^>^> .rar)
echo.
echo.                          [�س�] ����
echo.
echo.                             [0] ����
echo.
echo.          ------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo.���ü���ѡ�񲢻س�...
echo.-----------------------
set next=&set /p next=
if "%next%"=="" set SfxOrder=s-& goto :next
if "%next%"=="0" goto :EOF
goto :menu-exe

:next
set "random1=%random%%random%"
md "%dir.jzip.temp%\%random1%"

if "%type.editor%"=="rar" "%path.editor.rar%" %SfxOrder% -w%dir.jzip.temp%\%random1% "%path.Archive%"

echo.------------------------------------------------------------------------------
echo.
echo.    ����·����
echo.     %path.Archive%
echo.
echo.                                    [�س�] ��
pause>nul
goto :EOF