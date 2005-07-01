del bd.gbk
if "%1" == "pause" pause
"D:\Programmation\Firebird\Firebird_1_5\bin\gbak" "bd.gdb" "bd.gbk" -B -L -MO "read_only" -USER "sysdba" -PAS "masterkey" -V
