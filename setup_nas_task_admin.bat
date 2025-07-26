@echo off
chcp 65001 > nul

REM Check for administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Administrator privileges required.
    echo Requesting administrator privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

echo ========================================
echo Setting up NAS Mount Task
echo ========================================
echo.

REM Remove existing task if exists
echo Checking for existing task...
schtasks /query /tn "NAS Mount Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo Removing existing task...
    schtasks /delete /tn "NAS Mount Task" /f
)

REM Create hourly task
echo Creating new hourly task...
schtasks /create /tn "NAS Mount Task" /tr "cmd.exe /c \"cd /d D:\work\bat && nas_mount.bat\"" /sc hourly /mo 1 /st 09:00 /f /ru "NT AUTHORITY\SYSTEM"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Task created successfully!
    echo ========================================
    echo Task name: NAS Mount Task
    echo Schedule: Every hour starting at 9:00 AM
    echo.
    echo Task details:
    schtasks /query /tn "NAS Mount Task" /fo list
) else (
    echo.
    echo ========================================
    echo Error: Failed to create task
    echo ========================================
    echo Error code: %errorlevel%
)

echo.
pause 