@ECHO OFF
SET destU=%1
IF /I "%destU%"=="" SET /P destU=Enter PascalCase target library title, e.g., "Threading" (without quotes):
SET srcU=%2
IF /I "%srcU%"=="" SET srcU=GemTem
SET srcL=%srcU%
SET destL=%destU%
SET ucase=ABCDEFGHIJKLMNOPQRSTUVWXYZ
SET lcase=abcdefghijklmnopqrstuvwxyz
SETLOCAL EnableDelayedExpansion

FOR /L %%a IN (0,1,25) DO (
   CALL SET "from=%%ucase:~%%a,1%%
   CALL SET "to=%%lcase:~%%a,1%%
   CALL SET "srcL=%%srcL:!from!=!to!%%
   CALL SET "destL=%%destL:!from!=!to!%%
)

ECHO.
ECHO *** GemStone Template Rename Script ***
ECHO.
ECHO About to rename "%srcU%/%srcL%" to "%destU%/%destL%", press Ctrl+C to cancel, or
PAUSE
.\build\tools\ReplaceInFiles /r /v /c ".\src\*.*" %srcU% %destU%
.\build\tools\ReplaceInFiles /r /v /c ".\docs\*.*" %srcU% %destU%
.\build\tools\BRC64 /REPLACECS:%srcU%:%destU% /RECURSIVE /EXECUTE
.\build\tools\ReplaceInFiles /r /v /c ".\src\*.*" %srcL% %destL%
.\build\tools\ReplaceInFiles /r /v /c ".\docs\*.*" %srcL% %destL%
.\build\tools\BRC64 /REPLACECS:%srcL%:%destL% /RECURSIVE /EXECUTE
REN ".\src\Gemstone.%srcU%" "Gemstone.%destU%"

ENDLOCAL
ECHO.
ECHO Project Rename to "%destU%" is now Complete.
ECHO It is recommended to now delete the "RenameProject.bat" script and the ".\build\tools\" folder.
ECHO.
PAUSE
