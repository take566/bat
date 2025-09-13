@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Docker クリーンアップを開始します...
echo 日付: %date%
echo 時刻: %time%

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
REM ログディレクトリの存在確認、なければ作成
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo ログディレクトリを作成しました: %LOG_DIR%
)

REM ファイル名の安全な生成
SET filename=!yyyy!-!mm!-!dd!-!hh!-!mn!-!ss!
SET LOG=%LOG_DIR%\docker_clean_!filename!.txt

echo ログファイル: !LOG!
echo.

REM ログファイルの初期化
echo Docker cleanup started at %date% %time% > "!LOG!"
echo ================================== >> "!LOG!"
echo. >> "!LOG!"

echo 1. Docker システムのクリーンアップを実行中...
echo [%date% %time%] Starting Docker system prune >> "!LOG!"
docker system prune -f >> "!LOG!" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo   警告: Docker system prune コマンドが失敗しました。
    echo [%date% %time%] WARNING: Docker system prune failed >> "!LOG!"
) ELSE (
    echo   Docker system prune が完了しました。
    echo [%date% %time%] Docker system prune completed successfully >> "!LOG!"
)

echo 2. Docker マシンの削除を実行中...
echo [%date% %time%] Starting Docker machine removal >> "!LOG!"
docker-machine rm default -y >> "!LOG!" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo   警告: Docker マシンの削除が失敗しました。
    echo [%date% %time%] WARNING: Docker machine removal failed >> "!LOG!"
) ELSE (
    echo   Docker マシンの削除が完了しました。
    echo [%date% %time%] Docker machine removal completed >> "!LOG!"
)

echo 3. すべての Docker イメージを削除中...
echo [%date% %time%] Starting Docker images removal >> "!LOG!"
for /f "tokens=*" %%i in ('docker images -a -q 2^>nul') do (
    if not "%%i"=="" (
        echo [%date% %time%] Removing image: %%i >> "!LOG!"
        docker rmi -f %%i >> "!LOG!" 2>&1
    )
)
echo   Docker イメージの削除が完了しました。
echo [%date% %time%] Docker images removal completed >> "!LOG!"

echo 4. すべての Docker コンテナを削除中...
echo [%date% %time%] Starting Docker containers removal >> "!LOG!"
for /f "tokens=*" %%i in ('docker ps -a -q 2^>nul') do (
    if not "%%i"=="" (
        echo [%date% %time%] Removing container: %%i >> "!LOG!"
        docker rm -f %%i >> "!LOG!" 2>&1
    )
)
echo   Docker コンテナの削除が完了しました。
echo [%date% %time%] Docker containers removal completed >> "!LOG!"

echo.
echo [%date% %time%] Docker cleanup completed successfully >> "!LOG!"
echo Docker クリーンアップが完了しました。

REM ログファイルパスを安全に表示
set "LOG_MSG=ログファイルは !LOG! に保存されています。"
echo !LOG_MSG!

REM ここで一時停止
pause
