@echo off
if "%~1" == "" goto else
echo Restore: %~1
pause
"D:\Program Files\Firebird\Firebird_1_5\bin\gbak" %1 "bd.gdb" -C -R -USER "sysdba" -PAS "masterkey" -V
goto endif
:else
echo Restore: bd.gbk
pause
"D:\Program Files\Firebird\Firebird_1_5\bin\gbak" "bd.gbk" "bd.gdb" -C -R -USER "sysdba" -PAS "masterkey" -V
:endif
pause
