@echo off
set "MSYS_PATH=C:\msys64"
set "MSYS_SHELL=%MSYS_PATH%\msys2_shell.cmd"

if exist "%MSYS_SHELL%" exit /b 0

echo [!INFO!INFO!CLR_RESET!] Installing MSYS2 environment...

echo Downloading Installer...
call :show_progress 5
powershell -Command "Invoke-WebRequest -Uri 'https://repo.msys2.org/distrib/x86_64/msys2-x86_64-20240507.exe' -OutFile 'msys2_installer.exe'"

echo Installing MSYS2...
call :show_progress 10
start /wait msys2_installer.exe --root %MSYS_PATH% --confirm-command --accept-licenses --no-shortcuts
del msys2_installer.exe

echo Configuring Zsh...
call :show_progress 15
call "%MSYS_SHELL%" -defterm -no-start -ucrt64 -c "pacman -Syu --noconfirm && pacman -S zsh --noconfirm"

call :show_progress 20
echo [!OK!OK!CLR_RESET!] Setup complete!
exit /b 0

:show_progress
set "bar="
for /l %%i in (1,1,20) do (
    if %%i leq %1 set "bar=!bar!#"
    if %%i gtr %1 set "bar=!bar! "
)
echo [!bar!]
echo.
exit /b
