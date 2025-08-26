@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM 管理者権限の確認
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Error: This script requires administrator privileges.
    echo Right-click and select "Run as administrator".
    echo.
    echo Press any key to exit...
    pause > nul
    goto :EOF
)

echo ===================================================
echo Chocolatey Package Install Tool
echo ===================================================
echo 日付: %date%
echo 時刻: %time%
echo.

REM Check Chocolatey installation
echo Checking Chocolatey installation status...
choco --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Chocolatey is not installed.
    echo Installing Chocolatey...
    echo.
    
    REM Check PowerShell execution policy
    powershell -NoProfile -Command "Get-ExecutionPolicy" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo Cannot check PowerShell execution policy.
        echo Please run with administrator privileges.
        goto :EOF
    )
    
    REM Install Chocolatey
    echo Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    IF %ERRORLEVEL% NEQ 0 (
        echo Error: Chocolatey installation failed.
        echo Please run with administrator privileges.
        goto :EOF
    )
    
    echo Chocolatey installation completed.
    echo.
    
    REM Update PATH (try multiple methods)
    echo Updating PATH...
    
    REM Method 1: Try refreshenv command
    call refreshenv >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        REM Method 2: Add Chocolatey path directly
        set "PATH=%PATH%;%PROGRAMDATA%\chocolatey\bin"
        echo Added Chocolatey path manually.
    )
    
    REM Recheck if Chocolatey is available
    choco --version >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo Warning: Chocolatey path was not updated.
        echo Please open a new command prompt and try again.
        echo Or restart the system.
        goto :EOF
    )
    
    echo Chocolatey is now available.
    echo.
) ELSE (
    echo Chocolatey is already installed.
    echo.
)

REM 現在時刻の取得
SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%
SET time2=%time: =0%
SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

REM Log directory settings
SET LOG_DIR=log
SET LOG=%LOG_DIR%\cinst_%filename%.txt
SET TEMP_FILE=%TEMP%\packages_to_install.txt

REM Check if log directory exists, create if not
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)

REM Check if package list file exists
SET PACKAGE_LIST=packages.txt
IF NOT EXIST "%PACKAGE_LIST%" (
    echo Error: Package list file (%PACKAGE_LIST%) not found.
    echo Please create %PACKAGE_LIST% file in the current directory.
    echo Aborting process.
    goto :EOF
)

echo Log file: %LOG%
echo Package list: %PACKAGE_LIST%
echo.

REM Initialize temporary file
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

REM Load and filter package list
echo Loading package list...
set count=0
for /F "usebackq tokens=* eol=# delims=" %%A in ("%PACKAGE_LIST%") do (
    set line=%%A
    REM Skip empty lines and comments
    if not "!line!"=="" (
        REM Remove leading/trailing spaces
        set "line=!line: =!"
        if not "!line!"=="" (
            echo !line!>>"%TEMP_FILE%"
            set /a count+=1
        )
    )
)

echo Number of packages to install: !count!
echo.

REM If no packages found
if !count! EQU 0 (
    echo Warning: No packages found to install.
    echo Please check the %PACKAGE_LIST% file.
    echo Aborting process.
    goto :EOF
)

REM Start installation
echo ===================================================
echo Starting Chocolatey package installation...
echo ===================================================
echo.

REM Log file header
echo ===== Chocolatey Package Installation Log ===== > "%LOG%"
echo Started: %date% %time% >> "%LOG%"
echo Package list: %PACKAGE_LIST% >> "%LOG%"
echo Number of packages: !count! >> "%LOG%"
echo. >> "%LOG%"

REM Build bulk install command
set packages=
for /F "usebackq tokens=*" %%A in ("%TEMP_FILE%") do (
    set packages=!packages! %%A
)

REM Execute installation
echo Packages to install:!packages!
echo.
echo Starting installation... This may take some time.
echo.

REM Record command in log file
echo choco install!packages! -y >> "%LOG%"

REM Execute installation (including error output)
choco install!packages! -y >> "%LOG%" 2>&1
set INSTALL_RESULT=%ERRORLEVEL%

REM Check results
IF %INSTALL_RESULT% NEQ 0 (
    echo.
    echo Warning: Some packages may have failed to install.
    echo Error code: %INSTALL_RESULT%
    echo Please check the log file: %LOG%
    echo.
    echo Consider installing packages individually.
) ELSE (
    echo.
    echo All packages installed successfully.
)

REM Clean up temporary file
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

echo.
echo ===================================================
echo Installation process completed.
echo Log file: %LOG%
echo ===================================================
echo.
echo Press any key to exit...
pause > nul