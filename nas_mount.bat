@echo off
chcp 65001 > nul
echo %date%
echo %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET LOG_DIR=log
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
SET STATUS_FILE=log\nas_mount_status.txt
echo NAS Mount Status - %date% %time% > "%STATUS_FILE%"
echo ============================== >> "%STATUS_FILE%"

echo マウント状態をチェックしています... >> "%LOG%" 2>&1

REM マウント状態をチェック
SET MOUNT_NEEDED=false

echo Checking drive X: >> "%LOG%"
net use X: > "%LOG_DIR%\x_status.txt" 2>&1
findstr /i "Disconnected" "%LOG_DIR%\x_status.txt" >nul 2>&1
if %errorlevel% equ 0 (
    echo Drive X: is disconnected - needs remounting >> "%LOG%"
    SET MOUNT_NEEDED=true
) else (
    echo Drive X: is already mounted >> "%LOG%"
)

echo Checking drive Y: >> "%LOG%"
net use Y: > "%LOG_DIR%\y_status.txt" 2>&1
findstr /i "Disconnected" "%LOG_DIR%\y_status.txt" >nul 2>&1
if %errorlevel% equ 0 (
    echo Drive Y: is disconnected - needs remounting >> "%LOG%"
    SET MOUNT_NEEDED=true
) else (
    echo Drive Y: is already mounted >> "%LOG%"
)

echo Checking drive Z: >> "%LOG%"
net use Z: > "%LOG_DIR%\z_status.txt" 2>&1
findstr /i "Disconnected" "%LOG_DIR%\z_status.txt" >nul 2>&1
if %errorlevel% equ 0 (
    echo Drive Z: is disconnected - needs remounting >> "%LOG%"
    SET MOUNT_NEEDED=true
) else (
    echo Drive Z: is already mounted >> "%LOG%"
)

echo. >> "%LOG%"

REM マウントが必要な場合のみ実行
if "%MOUNT_NEEDED%"=="true" (
    echo マウントが必要です。マウント処理を開始します... >> "%LOG%" 2>&1
    echo 既存の接続を切断しています... >> "%LOG%" 2>&1
    
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
    
    echo マウント処理が完了しました。 >> "%LOG%"
) else (
    echo すべてのドライブが既にマウントされています。処理をスキップします。 >> "%LOG%"
)

echo ==================== Script End ==================== >> "%LOG%"

REM Optionally display the log file path at the end
echo Log saved to: %LOG%
