@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

SET LOG_DIR=log
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)

SET CHECK_LOG=%LOG_DIR%\nas_mount_check.txt
SET STATUS_FILE=%LOG_DIR%\nas_mount_status.txt

echo NAS Mount Check - %date% %time% > "%CHECK_LOG%"
echo ============================== >> "%CHECK_LOG%"

SET MOUNT_FAILED=false

REM Check drive X:
IF NOT EXIST X:\ (
    echo X: (Music) drive not mounted >> "%CHECK_LOG%"
    SET MOUNT_FAILED=true
) ELSE (
    echo X: (Music) drive OK >> "%CHECK_LOG%"
)

REM Check drive Y:
IF NOT EXIST Y:\ (
    echo Y: (Media) drive not mounted >> "%CHECK_LOG%"
    SET MOUNT_FAILED=true
) ELSE (
    echo Y: (Media) drive OK >> "%CHECK_LOG%"
)

REM Check drive Z:
IF NOT EXIST Z:\ (
    echo Z: (Home) drive not mounted >> "%CHECK_LOG%"
    SET MOUNT_FAILED=true
) ELSE (
    echo Z: (Home) drive OK >> "%CHECK_LOG%"
)

REM Check drive J:
IF NOT EXIST J:\ (
    echo J: (Docker) drive not mounted >> "%CHECK_LOG%"
    SET MOUNT_FAILED=true
) ELSE (
    echo J: (Docker) drive OK >> "%CHECK_LOG%"
)

echo. >> "%CHECK_LOG%"
IF "%MOUNT_FAILED%"=="true" (
    echo Overall Status: FAILED - Some NAS drives are not mounted >> "%CHECK_LOG%"
    echo Attempting to remount drives... >> "%CHECK_LOG%"
    
    REM Call the mount script
    call nas_mount.bat
    
    echo Remount attempt complete. See nas_mount log for details. >> "%CHECK_LOG%"
) ELSE (
    echo Overall Status: SUCCESS - All NAS drives are mounted correctly >> "%CHECK_LOG%"
)

echo ============================== >> "%CHECK_LOG%"

echo NAS Mount Check completed
echo Log file: %CHECK_LOG%

timeout /t 5