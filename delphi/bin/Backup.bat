del bd.gbk
if "%1" == "pause" pause
"C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gbak" "bd.gdb" "bd.gbk" -B -L -MO "read_only" -USER "sysdba" -PAS "masterkey" -V
