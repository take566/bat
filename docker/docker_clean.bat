@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Docker cleanup starting...
echo Date: %date%
echo Time: %time%

REM 日付と時刻の取得（安全な方法）
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set yyyy=%%a
    set mm=%%b
    set dd=%%c
)

REM 時刻の取得（安全な方法）
set time_str=%time: =0%
for /f "tokens=1-3 delims=:" %%a in ("!time_str!") do (
    set hh=%%a
    set mn=%%b
    set ss=%%c
)
set ss=!ss:~0,2!

SET LOG_DIR=log
REM Check if log directory exists, create if not
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Log directory created: %LOG_DIR%
)

REM Generate log filename
SET filename=!yyyy!-!mm!-!dd!-!hh!-!mn!-!ss!
SET LOG=%LOG_DIR%\docker_clean_!filename!.txt

echo Log file: !LOG!
echo.

REM Initialize log file
echo Docker cleanup started at %date% %time% > "!LOG!"
echo ================================== >> "!LOG!"
echo. >> "!LOG!"

echo 1. Running Docker system cleanup...
echo [%date% %time%] Starting Docker system prune >> "!LOG!"
docker system prune -f >> "!LOG!" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo   WARNING: Docker system prune command failed.
    echo [%date% %time%] WARNING: Docker system prune failed >> "!LOG!"
) ELSE (
    echo   Docker system prune completed.
    echo [%date% %time%] Docker system prune completed successfully >> "!LOG!"
)

echo 2. Removing Docker machine...
echo [%date% %time%] Starting Docker machine removal >> "!LOG!"
docker-machine rm default -y >> "!LOG!" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo   WARNING: Docker machine removal failed.
    echo [%date% %time%] WARNING: Docker machine removal failed >> "!LOG!"
) ELSE (
    echo   Docker machine removal completed.
    echo [%date% %time%] Docker machine removal completed >> "!LOG!"
)

echo 3. Removing all Docker images...
echo [%date% %time%] Starting Docker images removal >> "!LOG!"
for /f "tokens=*" %%i in ('docker images -a -q 2^>nul') do (
    if not "%%i"=="" (
        echo [%date% %time%] Removing image: %%i >> "!LOG!"
        docker rmi -f %%i >> "!LOG!" 2>&1
    )
)
echo   Docker images removal completed.
echo [%date% %time%] Docker images removal completed >> "!LOG!"

echo 4. Removing all Docker containers...
echo [%date% %time%] Starting Docker containers removal >> "!LOG!"
for /f "tokens=*" %%i in ('docker ps -a -q 2^>nul') do (
    if not "%%i"=="" (
        echo [%date% %time%] Removing container: %%i >> "!LOG!"
        docker rm -f %%i >> "!LOG!" 2>&1
    )
)
echo   Docker containers removal completed.
echo [%date% %time%] Docker containers removal completed >> "!LOG!"

echo.
echo [%date% %time%] Docker cleanup completed successfully >> "!LOG!"
echo Docker cleanup completed.

REM Display log file path
set "LOG_MSG=Log file saved to: !LOG!"
echo !LOG_MSG!

REM ここで一時停止
pause
