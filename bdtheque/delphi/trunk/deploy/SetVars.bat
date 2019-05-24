set FIREBIRD=C:\Program Files\Firebird\Firebird_2_5\bin
set NBACKUP=%FIREBIRD%\nbackup.exe

set USERNAME=SYSDBA
set PWD=masterkey

set CMD="%nbackup%" -T -D on -U %USERNAME% -P %PWD% 

set CD=%~dp0

set DB=%~1
if %DB%!==! set DB=%CD%bd.gdb
for %%f in (%DB%) do (
  set BKF=%%~ndpf.nbk
)
