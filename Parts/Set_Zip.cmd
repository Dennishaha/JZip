
::����
if not "%~1"=="" call :%*
goto :EOF

:ѹ����ʽ�л�
if /i "%�Խ�ѹ%"=="y" call :�Խ�ѹģ�� -default
goto :EOF

:ѹ������
if /i "%ѹ������%"=="y" (
	set "ѹ������="
	set "ѹ������="
	goto :EOF
)
if /i "%ѹ������%"=="" (
	set "ѹ������=y"
	set "ѹ������="&set /p "ѹ������=--�趨ѹ�����룺"
	if "!ѹ������!"=="" set "ѹ������="
	goto :EOF
)
set "ѹ������=" & goto :EOF

:ѹ������
for %%A in (0:1,1:2,2:3,3:4,4:5,5:0) do (
	for /f "tokens=1,2 delims=:" %%a in ("%%A") do (
		if "%ѹ������%"=="%%a" set "ѹ������=%%b" & goto :EOF
	)
)
goto :EOF

:��ʵ�ļ�
if /i "%��ʵ�ļ�%"=="y" set "��ʵ�ļ�=" & goto :EOF
if /i "%��ʵ�ļ�%"=="" set "��ʵ�ļ�=y" & goto :EOF
set "��ʵ�ļ�=" & goto :EOF

:�־�ѹ��
set �־�ѹ��=&set /p "�־�ѹ��=-- �趨�־�ѹ����С [��С|��λ] k/m/g ��"
if "%�־�ѹ��%"=="" set "�־�ѹ��="&goto :EOF
set "�־�ѹ��=%�־�ѹ��%" & goto :EOF

:ѹ���汾.rar
if /i "%ѹ���汾.rar%"=="5" set "ѹ���汾.rar=4" & goto :EOF
if /i "%ѹ���汾.rar%"=="4" set "ѹ���汾.rar=5" & goto :EOF
set "ѹ���汾.rar=5" & goto :EOF

:�Խ�ѹ

if /i "%�Խ�ѹ%"=="y" set "�Խ�ѹ=" & set "�Խ�ѹģ��=" & goto :EOF
if /i "%�Խ�ѹ%"=="" set "�Խ�ѹ=y" & set "�Խ�ѹģ��=a32" & goto :EOF
set "�Խ�ѹ=" & goto :EOF

:�Խ�ѹģ��
if "%~1"=="-default" set "�Խ�ѹģ��=a32" & goto :EOF
if /i "%�Խ�ѹ%"=="y" (
	for %%A in (
		.rar:a32:a64,
		.rar:a64:b32,
		.rar:b32:b64,
		.rar:b64:a32,
		.7z:a32:b32,
		.7z:b32:a32,
		.zip:a32:a64,
		.zip:a64:a32,
	) do (
		for /f "tokens=1,2,3 delims=:" %%a in ("%%A") do (
			if "%Archive.exten%"=="%%a" if "%�Խ�ѹģ��%"=="%%b" set "�Խ�ѹģ��=%%c" & goto :EOF
		)
	)
)
goto :EOF

:Ŀ��·��
set /p "path.Archive=-- ������ѹ����·����"
goto :EOF
