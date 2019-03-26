
:: 用法1 %0 [A|a] "变量名" 

:: 用法2 导入 call %0 -import 
::       %CapTrans% [A|a] "变量名" 


:: 导入 
@if /i "%~1"=="-import" (
	set captrans=call "%~0"
	goto :EOF
)

:: 执行 
@if defined %~2 (
	if "%~1"=="a" >nul (
		for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set "%~2=%%%~2:%%i=%%i%%"
	)

	if "%~1"=="A" >nul (
		for %%i in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call set "%~2=%%%~2:%%i=%%i%%"
	)
)