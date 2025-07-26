@echo off
echo Creating NAS Mount Task with correct command...

REM Create hourly task with correct command syntax
schtasks /create /sc hourly /mo 1 /tn "NAS Mount Task" /tr "cmd.exe /c \"cd /d D:\work\bat && nas_mount.bat\"" /st 09:00 /f /ru "%USERNAME%"

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