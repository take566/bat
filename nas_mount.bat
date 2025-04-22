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
SET LOG=C:\work\log\nas_mount_%filename%.txt

echo マウント処理を開始します... >> "%LOG%" 2>&1
echo 既存の接続を切断しています... >> "%LOG%" 2>&1

net use J: /DELETE /y >> "%LOG%" 2>&1
net use X: /DELETE /y >> "%LOG%" 2>&1
net use Y: /DELETE /y >> "%LOG%" 2>&1
net use Z: /DELETE /y >> "%LOG%" 2>&1

echo 切断完了 >> "%LOG%" 2>&1
echo. >> "%LOG%" 2>&1

REM リトライ回数の設定
SET MAX_RETRY=3
SET SERVER=\\AS4002T-A6F7

echo NASへの接続を開始します... >> "%LOG%" 2>&1

:MOUNT_X
SET RETRY=0
echo X: ドライブのマウントを試みます... >> "%LOG%" 2>&1
:RETRY_X
net use X: %SERVER%\Music /user:admin /savecred /persistent:yes >> "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    SET /A RETRY+=1
    echo X: ドライブのマウント失敗 - リトライ %RETRY%/%MAX_RETRY% >> "%LOG%" 2>&1
    IF %RETRY% LSS %MAX_RETRY% (
        timeout /t 5
        GOTO RETRY_X
    ) ELSE (
        echo X: ドライブのマウント失敗 - 最大リトライ回数に到達 >> "%LOG%" 2>&1
    )
) ELSE (
    echo X: ドライブのマウント成功 >> "%LOG%" 2>&1
)

:MOUNT_Y
SET RETRY=0
echo Y: ドライブのマウントを試みます... >> "%LOG%" 2>&1
:RETRY_Y
net use Y: %SERVER%\Media /user:admin /savecred /persistent:yes >> "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    SET /A RETRY+=1
    echo Y: ドライブのマウント失敗 - リトライ %RETRY%/%MAX_RETRY% >> "%LOG%" 2>&1
    IF %RETRY% LSS %MAX_RETRY% (
        timeout /t 5
        GOTO RETRY_Y
    ) ELSE (
        echo Y: ドライブのマウント失敗 - 最大リトライ回数に到達 >> "%LOG%" 2>&1
    )
) ELSE (
    echo Y: ドライブのマウント成功 >> "%LOG%" 2>&1
)

:MOUNT_Z
SET RETRY=0
echo Z: ドライブのマウントを試みます... >> "%LOG%" 2>&1
:RETRY_Z
net use Z: %SERVER%\Home /user:admin /savecred /persistent:yes >> "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    SET /A RETRY+=1
    echo Z: ドライブのマウント失敗 - リトライ %RETRY%/%MAX_RETRY% >> "%LOG%" 2>&1
    IF %RETRY% LSS %MAX_RETRY% (
        timeout /t 5
        GOTO RETRY_Z
    ) ELSE (
        echo Z: ドライブのマウント失敗 - 最大リトライ回数に到達 >> "%LOG%" 2>&1
    )
) ELSE (
    echo Z: ドライブのマウント成功 >> "%LOG%" 2>&1
)

:MOUNT_J
SET RETRY=0
echo J: ドライブのマウントを試みます... >> "%LOG%" 2>&1
:RETRY_J
net use J: %SERVER%\Docker /user:admin /savecred /persistent:yes >> "%LOG%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    SET /A RETRY+=1
    echo J: ドライブのマウント失敗 - リトライ %RETRY%/%MAX_RETRY% >> "%LOG%" 2>&1
    IF %RETRY% LSS %MAX_RETRY% (
        timeout /t 5
        GOTO RETRY_J
    ) ELSE (
        echo J: ドライブのマウント失敗 - 最大リトライ回数に到達 >> "%LOG%" 2>&1
    )
) ELSE (
    echo J: ドライブのマウント成功 >> "%LOG%" 2>&1
)

echo.
echo マウント処理が完了しました
echo ログファイル: %LOG%

REM マウントされたドライブの確認
net use >> "%LOG%" 2>&1

timeout /t 5
