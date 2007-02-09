@echo off
if "%~1" == "" goto else
echo Restore: %~1
pause
"C:\Program Files\Firebird\Firebird_1_5\bin\gbak" %1 "bd.gdb" -C -R -USER "sysdba" -PAS "laurence" -V
goto endif
:else
echo Restore: bd.gbk
pause
"C:\Program Files\Firebird\Firebird_1_5\bin\gbak" "bd.gbk" "bd.gdb" -C -R -USER "sysdba" -PAS "laurence" -V
:endif
pause
