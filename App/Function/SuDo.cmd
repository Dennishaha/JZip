
@(
:: ���� 
if /i "%~1"=="-import" (
	set sudo=call "%~0"
	goto :EOF
)

:: ���� 
setlocal enabledelayedexpansion
set params=%*
if defined params (
	set "params=!params:"=""!"
	set "params=!params:?=&!"
)

:: ��ǰȨ���ж�
@net session >nul 2>nul && (
	!params!
) || (
	::ȡ�ù���ԱȨ�� 
	mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("cmd.exe","/c call !params!","","runas",1^)^(window.close^)
)
endlocal
exit /b !errorlevel!
)

:: �Թ���Ա�����������
:: 
:: �÷�
:: %su% command
:: %su% command1 ? command2