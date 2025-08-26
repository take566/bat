@echo off
echo Testing task creation...

REM Create a simple hourly task
schtasks /create /sc hourly /mo 1 /tn "NAS Mount Task" /tr "cmd.exe /c \"cd /d D:\work\bat && nas_mount.bat\"" /st 09:00 /f /ru "%USERNAME%"

if %errorlevel% equ 0 (
    echo Task created successfully!
    schtasks /query /tn "NAS Mount Task" /fo list
) else (
    echo Failed to create task. Error code: %errorlevel%
)

pause 