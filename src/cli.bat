@echo off
setlocal enabledelayedexpansion
call settings.bat

for /f %%a in ('echo prompt $E^|cmd') do set "ESC=%%a"

set "OK=!ESC![92m"
set "INFO=!ESC![94m"
set "ERROR=!ESC![91m"
set "WARN=!ESC![93m"
set "CLR_RESET=!ESC![0m"

if "!clienabled!"=="1" (
    echo [!INFO!INFO!CLR_RESET!] CLI is enabled.
    echo [!INFO!INFO!CLR_RESET!] Starting CLI...
)

cls

echo !versionData!
echo.
echo USERNAME
echo ========================================
echo What is your username?
set /p usrName="Please enter your username: "
echo Welcome, !usrName!

echo CLI NAME
echo ==========================================
echo What would you like to call this CLI?
set /p oscli="CLI Name: "
echo [%usrName%@%oscli%]

:climain
set "cmdInput="
set /p "cmdInput=[%usrName%@] $ "

pause
