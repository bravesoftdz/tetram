@echo off

call SetVars.bat %*

if exist "%BKF%" del "%BKF%"
if %ERRORLEVEL% NEQ 0 goto :error
%CMD% -B 0 "%DB%" "%BKF%"
if %ERRORLEVEL% NEQ 0 goto :error

goto :eof

:error
pause
exit /B %ERRORLEVEL%