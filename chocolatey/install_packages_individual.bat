@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo ===================================================
echo Individual Package Installer
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

REM Check if Chocolatey is installed
choco --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Chocolatey is not installed.
    echo Please run install_chocolatey.bat first.
    pause
    exit /b 1
)

REM Change to script directory
cd /d "%~dp0"

REM Check if packages.txt exists
IF NOT EXIST "packages.txt" (
    echo Error: packages.txt not found in %~dp0
    pause
    exit /b 1
)

echo Installing packages individually from packages.txt...
echo.

REM Create log file
set LOG_FILE=install_individual_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOG_FILE=%LOG_FILE: =0%

REM Count total packages first
set count=0
for /F "usebackq tokens=* eol=# delims=" %%A in ("packages.txt") do (
    set package=%%A
    if not "!package!"=="" (
        set "package=!package: =!"
        if not "!package!"=="" (
            set /a count+=1
        )
    )
)

echo Found !count! packages to install.
echo.

REM Initialize counters
set success=0
set failed=0

REM Install packages one by one
for /F "usebackq tokens=* eol=# delims=" %%A in ("packages.txt") do (
    set package=%%A
    if not "!package!"=="" (
        set "package=!package: =!"
        if not "!package!"=="" (
            echo Installing: !package!
            choco install !package! -y >> %LOG_FILE% 2>&1
            if !ERRORLEVEL! EQU 0 (
                echo [SUCCESS] !package!
                set /a success+=1
            ) else (
                echo [FAILED] !package!
                set /a failed+=1
            )
            echo.
        )
    )
)

echo ===================================================
echo Installation Summary:
echo Successfully installed: !success! packages
echo Failed installations: !failed! packages
echo Total packages: !count! packages
echo ===================================================

if !failed! GTR 0 (
    echo Some packages failed to install.
    echo Check %LOG_FILE% for details.
) else (
    echo All packages installed successfully!
)

echo.
echo Log file: %LOG_FILE%
pause
