@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo ===================================================
echo Package Installer
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

REM Change to script directory to ensure correct path
cd /d "%~dp0"

REM Check if packages.txt exists
IF NOT EXIST "packages.txt" (
    echo Error: packages.txt not found in %~dp0
    pause
    exit /b 1
)

echo Installing packages from packages.txt...
echo.

REM Create log file
set LOG_FILE=install_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOG_FILE=%LOG_FILE: =0%

REM Create temporary file for filtered packages
set TEMP_PACKAGES=%TEMP%\packages_filtered.txt
if exist "%TEMP_PACKAGES%" del "%TEMP_PACKAGES%"

REM Filter packages (remove comments and empty lines)
set count=0
for /F "usebackq tokens=* eol=# delims=" %%A in ("packages.txt") do (
    set line=%%A
    if not "!line!"=="" (
        set "line=!line: =!"
        if not "!line!"=="" (
            echo !line!>>"%TEMP_PACKAGES%"
            set /a count+=1
        )
    )
)

echo Found !count! packages to install.
echo.

REM Check if any packages were found
if !count! EQU 0 (
    echo Warning: No packages found to install.
    echo Please check the packages.txt file.
    pause
    exit /b 1
)

REM Check if package count is too high for bulk install
if !count! GTR 20 (
    echo Warning: Large number of packages (!count!) detected.
    echo Consider installing packages individually for better reliability.
    echo.
    set /p choice="Do you want to continue with bulk install? (y/N): "
    if /i not "!choice!"=="y" (
        echo Installation cancelled.
        pause
        exit /b 0
    )
    echo.
)

REM Build package list
set PACKAGE_LIST=
for /F "usebackq tokens=*" %%A in ("%TEMP_PACKAGES%") do (
    set PACKAGE_LIST=!PACKAGE_LIST! %%A
)

REM Install packages
choco install!PACKAGE_LIST! -y > %LOG_FILE% 2>&1
set INSTALL_RESULT=%ERRORLEVEL%

REM Clean up temporary file
if exist "%TEMP_PACKAGES%" del "%TEMP_PACKAGES%"

IF %INSTALL_RESULT% NEQ 0 (
    echo Some packages may have failed to install.
    echo Check %LOG_FILE% for details.
) ELSE (
    echo All packages installed successfully!
)

echo.
echo Log file: %LOG_FILE%
pause
