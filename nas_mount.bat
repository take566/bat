@echo off
echo %date%
echo %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET LOG_DIR=C:\work\log
REM Check if the log directory exists, create it if it doesn't
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%
SET LOG=%LOG_DIR%\nas_mount_%filename%.txt

echo ==================== Script Start ==================== >> "%LOG%"
echo Date: %date% >> "%LOG%"
echo Time: %time% >> "%LOG%"
echo Log file: %LOG% >> "%LOG%"
echo. >> "%LOG%"

REM Initialize status file
SET STATUS_FILE=C:\work\log\nas_mount_status.txt
echo NAS Mount Status - %date% %time% > "%STATUS_FILE%"
echo ============================== >> "%STATUS_FILE%"

echo マウント処理を開始します... >> "%LOG%" 2>&1
echo 既存の接続を切断しています... >> "%LOG%" 2>&1
echo Checking log directory: %LOG_DIR% >> "%LOG%"
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%" >> "%LOG%" 2>&1
    echo Created log directory: %LOG_DIR% >> "%LOG%"
) ELSE (
    echo Log directory already exists: %LOG_DIR% >> "%LOG%"
)
echo. >> "%LOG%"

REM 既存の接続を解除
echo Disconnecting drive X: >> "%LOG%"
net use X: /DELETE /y >> "%LOG%" 2>&1
echo Disconnecting drive Y: >> "%LOG%"
net use Y: /DELETE /y >> "%LOG%" 2>&1
echo Disconnecting drive Z: >> "%LOG%"
net use Z: /DELETE /y >> "%LOG%" 2>&1
echo. >> "%LOG%"

REM 新しい接続を確立
echo Connecting drive X: \\AS4002T-A6F7\Music >> "%LOG%"
net use X: \\AS4002T-A6F7\Music /user:admin asdf1242 >> "%LOG%" 2>&1
echo Connecting drive Y: \\AS4002T-A6F7\Media >> "%LOG%"
net use Y: \\AS4002T-A6F7\Media >> "%LOG%" 2>&1
echo Connecting drive Z: \\AS4002T-A6F7\Home >> "%LOG%"
net use Z: \\AS4002T-A6F7\Home >> "%LOG%" 2>&1
echo. >> "%LOG%"

echo ==================== Script End ==================== >> "%LOG%"

REM Optionally display the log file path at the end
echo Log saved to: %LOG%
