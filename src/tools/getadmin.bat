:: Usage - CALL %~dp0getadmin.bat %~dpf0
:: Made by Folfy Blue

cd /d %~dp1

NET SESSION || REM Admin only command, if the error level is 0, it means we have admin privileges

if NOT %errorLevel% == 0 (
  echo Getting administrator privileges..
  powershell -command "Start-Process %~dpf1 -Verb runas" || REM Restart current batch file as admin
  exit
)