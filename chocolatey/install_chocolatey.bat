@echo off
chcp 65001 > nul

echo ===================================================
echo Chocolatey Installer
echo ===================================================
echo.

REM Check if running as administrator
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Administrator privileges required.
    echo Right-click and select "Run as administrator".
    pause
    exit /b 1
)

echo Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

IF %ERRORLEVEL% NEQ 0 (
    echo Installation failed.
    pause
    exit /b 1
)

echo.
echo Chocolatey installed successfully!
echo You can now use 'choco install <package>' commands.
echo.
pause
