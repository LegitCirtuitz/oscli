@echo off
setlocal enabledelayedexpansion

set "launchCode=false"
set "SALT=9hp52s!6Oh0XD"

if exist "settings.bat" call "settings.bat"

set "versionData=OSCLI [Version 1.0.0:Build 2600H0A]"

for /f %%a in ('echo prompt $E^|cmd') do set "ESC=%%a"
set "OK=!ESC![92m"
set "INFO=!ESC![94m"
set "ERROR=!ESC![91m"
set "CLR_RESET=!ESC![0m"

echo [!INFO!INFO!CLR_RESET!] Initializing OS.C.L.I...
powershell -Command "Start-Sleep -Milliseconds 200"
echo [!INFO!INFO!CLR_RESET!] !versionData!
timeout /t 1 >nul

:: Fix: Logic for system enabled
IF "!enabled!"=="1" (
    echo [!OK!OK!CLR_RESET!] System is enabled.
    echo [!INFO!INFO!CLR_RESET!] Proceeding with Initialization.
    timeout /t 2 >nul
) ELSE (
    echo [!INFO!INFO!CLR_RESET!] System is currently disabled.
    echo [!INFO!INFO!CLR_RESET!] Automatically enabling System...
    set "enabled=1"
    timeout /t 2 >nul
    echo [!OK!OK!CLR_RESET!] Successfully enabled System. Proceeding...
    timeout /t 2 >nul
)

if not exist "password.db" goto :registration
goto :login

:login
echo ===================================================
set /p "userInput=Enter Password: "
set "combined=!userInput!!SALT!"

<nul set /p="%combined%" > temp_pass.txt
set "computedHash="
for /f "tokens=* skip=1" %%a in ('certutil -hashfile temp_pass.txt SHA256') do (
    if not defined computedHash (
        set "computedHash=%%a"
        set "computedHash=!computedHash: =!"
    )
)
del temp_pass.txt >nul 2>&1

set /p storedHash=<password.db
set "storedHash=!storedHash: =!"

if "!computedHash!"=="!storedHash!" (
    echo [!OK!OK!CLR_RESET!] Access Granted!
    goto :success
) else (
    echo [!ERROR!ERROR!CLR_RESET!] Incorrect password.
    goto :login
)

:registration
echo [!ERROR!ERROR!CLR_RESET!] No database found. First-time setup.
set /p "newPass=Create New Password: "
set /p "confirmPass=Confirm New Password: "
if not "!newPass!"=="!confirmPass!" (
    echo [!ERROR!ERROR!CLR_RESET!] Passwords do not match.
    goto :registration
)
set "regCombined=!newPass!!SALT!"
<nul set /p="%regCombined%" > temp_reg.txt
for /f "tokens=* skip=1" %%a in ('certutil -hashfile temp_reg.txt SHA256') do set "regHash=%%a"
del temp_reg.txt >nul 2>&1
echo !regHash: =!>password.db
echo [!OK!OK!CLR_RESET!] Registered successfully!
timeout /t 2 >nul
goto :success

:success
echo.
call cli.bat

pause
