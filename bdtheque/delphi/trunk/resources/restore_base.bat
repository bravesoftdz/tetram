@echo off

call SetVars.bat %*

if exist "%DB%" del "%DB%"
if %ERRORLEVEL% NEQ 0 goto :error
%CMD% -R "%DB%" "%BKF%"
if %ERRORLEVEL% NEQ 0 goto :error

goto :eof

:error
pause
exit /B %ERRORLEVEL%