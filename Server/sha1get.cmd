
@echo off
if not "%~1"=="" (
	certutil -hashfile "%~1"
	>nul pause
)
