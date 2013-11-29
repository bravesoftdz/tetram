@echo off
if "%~1" == "" goto else
echo Restore: %~1
pause
"C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gbak" %1 "bd.gdb" -REP -C -R -USER "sysdba" -PAS "masterkey" -V
goto endif
:else
echo Restore: bd.gbk
pause
"C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gbak" "bd.gbk" "bd.gdb" -REP -C -R -USER "sysdba" -PAS "masterkey" -V
:endif
pause
