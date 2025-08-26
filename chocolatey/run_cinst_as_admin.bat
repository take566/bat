@echo off
chcp 65001 > nul

echo ===================================================
echo Chocolatey Package Install Tool
echo ===================================================
echo.

REM Check if running as administrator
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

REM If we get here, we have admin privileges
echo Running with administrator privileges.
echo.

REM Change to script directory
cd /d "%~dp0"

REM Check if Chocolatey is installed
choco --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Chocolatey is not installed. Installing...
    call install_chocolatey.bat
    IF %ERRORLEVEL% NEQ 0 (
        echo Chocolatey installation failed.
        pause
        exit /b 1
    )
    echo.
)

REM Install packages
echo Installing packages...
call install_packages.bat

echo.
echo Process completed.
pause
