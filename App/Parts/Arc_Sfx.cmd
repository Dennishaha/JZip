
:: 调用 
for %%i in (rar exe) do if /i "%Archive.exten%"==".%%i" call :menu
goto :EOF

:menu
cls

::UI--------------------------------------------------

echo,
echo,
echo,
echo,
echo,
echo,
if /i "%Archive.exten%"==".rar" echo,                                    %txt_as.tip.add%
if /i "%Archive.exten%"==".exe" echo,                                  %txt_as.tip.re%
echo,
echo,
%echo%,                              %txt_b13.top%%txt_b8.top%
%echo%,                              %txt_b13.emp%%txt_as.b.64%
%echo%,                              %txt_b13.emp%%txt_b8.bot%
%echo%,                              %txt_b13.emp%%txt_b8.top%
%echo%,                              %txt_as.b.sfx%%txt_as.b.con%
%echo%,                              %txt_b13.emp%%txt_b8.bot%
%echo%,                              %txt_b13.emp%%txt_b8.top%
%echo%,                              %txt_b13.emp%%txt_as.b.con64%
%echo%,                              %txt_b13.bot%%txt_b8.bot%
echo,
echo,
if /i "%Archive.exten%"==".exe" (
%echo%,                                   %txt_b16.top%
%echo%,                                   %txt_b16.emp%
%echo%,                                   %txt_as.b.add%
%echo%,                                   %txt_b16.emp%
%echo%,                                   %txt_b16.bot%
) else echo,& echo,& echo,& echo,& echo,
echo,
echo,
echo,
echo,
%echo%,                                                                                         %txt_b7.top%
%echo%,                                                                                         %txt_b7.cancel%
%echo%,                                                                                         %txt_b7.bot%

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
	90}101}29}31}back}
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

%MsgBox% "转换完成。" " " "路径：%path.Archive%"
goto :EOF