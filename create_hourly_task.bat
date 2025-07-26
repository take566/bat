@echo off
chcp 65001 > nul
echo Creating hourly NAS mount task...

REM Remove existing task if exists
echo Checking for existing task...
schtasks /query /tn "NAS Mount Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo Removing existing task...
    schtasks /delete /tn "NAS Mount Task" /f
)

REM Create hourly task using schtasks
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
    echo.
    echo Please run this script as Administrator
)

echo.
pause 