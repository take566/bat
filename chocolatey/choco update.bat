@echo off
REM バッチファイルのディレクトリを基準にしたパスを設定（タスクスケジューラ対応）
SET SCRIPT_DIR=%~dp0
SET BASE_DIR=%SCRIPT_DIR%..

REM 作業ディレクトリをバッチファイルの場所に変更
CD /D "%SCRIPT_DIR%"

echo ========================================
echo Chocolatey Update Script Started
echo Date: %date%
echo Time: %time%
echo Script Directory: %SCRIPT_DIR%
echo ========================================

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

REM ログディレクトリをバッチファイルの親ディレクトリ基準に設定
SET LOG_DIR=%BASE_DIR%\log
SET LOG=%LOG_DIR%\clist_%filename%.txt

REM Check if the log directory exists, create it if it doesn't
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)

REM ログファイルに開始時刻を記録
echo ======================================== >> %LOG%
echo Chocolatey Update Script Started >> %LOG%
echo Date: %date% >> %LOG%
echo Time: %time% >> %LOG%
echo Script Directory: %SCRIPT_DIR% >> %LOG%
echo ======================================== >> %LOG%

REM Chocolateyがインストールされているか確認
WHERE choco >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Chocolatey is not installed or not in PATH >> %LOG%
    echo ERROR: Chocolatey is not installed or not in PATH
    EXIT /B 1
)

REM Chocolateyアップグレード実行（エラー出力も含める）
echo. >> %LOG%
echo Starting choco upgrade all... >> %LOG%
choco upgrade all -y >> %LOG% 2>&1
SET UPGRADE_ERROR=%ERRORLEVEL%
IF %UPGRADE_ERROR% NEQ 0 (
    echo ERROR: choco upgrade failed with error code %UPGRADE_ERROR% >> %LOG%
    echo ERROR: choco upgrade failed with error code %UPGRADE_ERROR%
)

REM ローカルパッケージリスト取得
echo. >> %LOG%
echo Getting local package list... >> %LOG%
choco list -localonly >> %LOG% 2>&1
SET LIST_ERROR=%ERRORLEVEL%
IF %LIST_ERROR% NEQ 0 (
    echo ERROR: choco list failed with error code %LIST_ERROR% >> %LOG%
    echo ERROR: choco list failed with error code %LIST_ERROR%
)

REM 終了時刻を記録
echo. >> %LOG%
echo ======================================== >> %LOG%
echo Script completed at %date% %time% >> %LOG%
IF %UPGRADE_ERROR% NEQ 0 (
    echo Exit code: %UPGRADE_ERROR% >> %LOG%
) ELSE IF %LIST_ERROR% NEQ 0 (
    echo Exit code: %LIST_ERROR% >> %LOG%
) ELSE (
    echo Exit code: 0 (Success) >> %LOG%
)
echo ======================================== >> %LOG%

echo.
echo Script completed. Log saved to: %LOG%
echo.
