@echo off
chcp 65001 > nul
echo Docker クリーンアップを開始します...
echo 日付: %date%
echo 時刻: %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET LOG_DIR=log
REM ログディレクトリの存在確認、なければ作成
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo ログディレクトリを作成しました: %LOG_DIR%
)

SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%
SET LOG=%LOG_DIR%\docker_clean_%filename%.txt

echo ログファイル: %LOG%
echo.

echo 1. Docker システムのクリーンアップを実行中...
docker system prune -f > "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo   警告: Docker system prune コマンドが失敗しました。
) ELSE (
    echo   Docker system prune が完了しました。
)

echo 2. Docker マシンの削除を実行中...
docker-machine rm default -y >> "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo   警告: Docker マシンの削除が失敗しました。
) ELSE (
    echo   Docker マシンの削除が完了しました。
)

echo 3. すべての Docker イメージを削除中...
FOR /F "tokens=*" %%i IN ('docker images -a -q') DO (
    IF NOT "%%i"=="" (
        docker rmi -f %%i >> "%LOG%" 2>&1
    )
)
echo   Docker イメージの削除が完了しました。

echo 4. すべての Docker コンテナを削除中...
FOR /F "tokens=*" %%i IN ('docker ps -a -q') DO (
    IF NOT "%%i"=="" (
        docker rm -f %%i >> "%LOG%" 2>&1
    )
)
echo   Docker コンテナの削除が完了しました。

echo.
echo Docker クリーンアップが完了しました。
echo ログファイルは %LOG% に保存されています。
pause
