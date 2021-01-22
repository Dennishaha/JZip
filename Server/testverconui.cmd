
@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001
mode 80, 25
color f0

:head
cls
echo;var: jzip.newver.des.chs?
set /p jzip.newver.des.chs=

::UI--------------------------------------------------

cls
echo;
echo;
echo;
echo;        现在可以安装 Jzip  x.x.x
echo;
echo;
for %%i in (!jzip.newver.des.chs!) do echo;	%%~i
echo;
echo;

::UI--------------------------------------------------

>nul pause
goto :head
