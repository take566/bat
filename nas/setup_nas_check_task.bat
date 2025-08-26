@echo off
echo Setting up scheduled task for NAS mount checking...

SET SCRIPT_PATH=%~dp0check_nas_mounts.bat
SET TASK_NAME=NASMountCheck

REM Create the scheduled task to run every hour
schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc hourly /mo 1 /ru SYSTEM /f

IF %ERRORLEVEL% EQU 0 (
    echo Task created successfully.
    echo The NAS mount check will run every hour.
) ELSE (
    echo Failed to create task. Error code: %ERRORLEVEL%
)

echo.
echo You can manually modify this task in Task Scheduler if needed.
echo To run the check immediately, use: schtasks /run /tn "%TASK_NAME%"

pause