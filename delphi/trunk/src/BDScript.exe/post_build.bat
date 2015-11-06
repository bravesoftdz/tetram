@echo off

call set PROJECTPATH=%~1
call set PROJECTDIR=%~dp1
call set OUTPUTPATH=%~2
call set OUTPUTFILENAME=%~nx2
call set OUTPUTDIR=%~dp2
call set PLATFORM=%~3

xcopy /S /E /I /Y /Q "%OUTPUTPATH%" "%OUTPUTDIR%\..\Win64\%OUTPUTFILENAME%"
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%