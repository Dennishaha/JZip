
if "%ArchiveOrder%"=="list" (
	call "%dir.jzip%\Parts\Select_Folder.cmd"
	if not defined key goto :EOF
	dir /a:d /b "!key!" && set "dir.release=!key!" || goto :EOF
)

if "%ArchiveOrder%"=="unzip" (
	set "dir.release=%dir.Archive%\%Archive.name%_unzip"
)

cls
if "%type.editor%"=="rar" "%path.editor.rar%" x "%path.Archive%" "%dir.release%\" %iferror%
if "%type.editor%"=="7z" "%path.editor.7z%" x -o"%dir.release%\" "%path.Archive%" %iferror%

goto :EOF
