@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 管理者権限を要求しています...
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

chcp 65001 > nul
echo ========================================
echo NAS Mount Task Registration
echo ========================================
echo.

REM 現在のディレクトリを表示
echo 現在のディレクトリ: %CD%
echo.

REM Delete existing task if exists
echo Checking existing task...
schtasks /query /tn "NAS Mount Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo Deleting existing task...
    schtasks /delete /tn "NAS Mount Task" /f
    if %errorlevel% equ 0 (
        echo Existing task deleted.
    ) else (
        echo Warning: Failed to delete existing task.
    )
    echo.
)

REM Create task using schtasks command
echo Creating new task...
schtasks /create /tn "NAS Mount Task" /tr "cmd.exe /c \"cd /d D:\work\bat && nas_mount.bat\"" /sc hourly /mo 1 /st 09:00 /f /ru "NT AUTHORITY\SYSTEM"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Task registered successfully!
    echo ========================================
    echo Task name: NAS Mount Task
    echo Schedule: Every hour starting at 9:00 AM
    echo Description: Checks NAS mount status and mounts if needed
    echo.
    echo Checking task details...
    schtasks /query /tn "NAS Mount Task" /fo list
) else (
    echo.
    echo ========================================
    echo Error: Task registration failed.
    echo ========================================
    echo Error code: %errorlevel%
    echo.
    echo Possible causes:
    echo 1. Insufficient administrator privileges
    echo 2. XML file format issue
    echo 3. Task Scheduler service is disabled
    echo.
    echo Solutions:
    echo - Right-click -^> "Run as administrator"
    echo - Check XML file content
    echo - Verify Task Scheduler service is enabled
    echo.
    echo For detailed error information:
    echo schtasks /create /xml "NasMountTask.xml" /tn "NAS Mount Task" /v
)

echo.
pause
