del bd.gbk
if "%1" == "pause" pause
"C:\Program Files\Firebird\Firebird_2_0\bin\gbak" "bd.gdb" "bd.gbk" -B -L -MO "read_only" -USER "sysdba" -PAS "masterkey" -V
