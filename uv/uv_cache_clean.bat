@echo off
chcp 65001 > nul
REM バッチファイルのディレクトリを基準にしたパスを設定（タスクスケジューラ対応）
SET SCRIPT_DIR=%~dp0
SET BASE_DIR=%SCRIPT_DIR%..

REM 作業ディレクトリをバッチファイルの場所に変更
CD /D "%SCRIPT_DIR%"

echo ========================================
echo uv Cache Clean Script Started
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
SET LOG=%LOG_DIR%\uv_cache_clean_%filename%.txt

REM ログディレクトリが存在しない場合は作成
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)

REM ログファイルに開始時刻を記録
echo ======================================== >> %LOG%
echo uv Cache Clean Script Started >> %LOG%
echo Date: %date% >> %LOG%
echo Time: %time% >> %LOG%
echo Script Directory: %SCRIPT_DIR% >> %LOG%
echo ======================================== >> %LOG%

REM タスクスケジューラ実行時はPATHに含まれないことがあるため、uvのパスを明示的に追加
set "PATH=%USERPROFILE%\.local\bin;%PATH%"

REM uvがインストールされているか確認
WHERE uv >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: uv is not installed or not in PATH >> %LOG%
    echo ERROR: uv is not installed or not in PATH
    EXIT /B 1
)

REM uvのバージョンを記録
echo. >> %LOG%
echo uv version: >> %LOG%
uv --version >> %LOG% 2>&1

REM キャッシュディレクトリの場所を表示
echo. >> %LOG%
echo Cache directory location: >> %LOG%
uv cache dir >> %LOG% 2>&1

REM クリーンアップ前のキャッシュディレクトリのサイズを表示
echo. >> %LOG%
echo Cache size before cleanup: >> %LOG%
FOR /F "delims=" %%D in ('uv cache dir') DO (
    IF EXIST "%%D" (
        dir /s "%%D" 2>nul | findstr /C:"File(s)" >> %LOG% 2>&1
    ) ELSE (
        echo Cache directory does not exist: %%D >> %LOG%
    )
)

REM uvキャッシュクリーンアップ実行
echo. >> %LOG%
echo Starting uv cache clean... >> %LOG%
uv cache clean >> %LOG% 2>&1
SET CLEAN_ERROR=%ERRORLEVEL%
IF %CLEAN_ERROR% NEQ 0 (
    echo ERROR: uv cache clean failed with error code %CLEAN_ERROR% >> %LOG%
    echo ERROR: uv cache clean failed with error code %CLEAN_ERROR%
) ELSE (
    echo uv cache clean completed successfully. >> %LOG%
    echo uv cache clean completed successfully.
)

REM 終了時刻を記録
echo. >> %LOG%
echo ======================================== >> %LOG%
echo Script completed at %date% %time% >> %LOG%
IF %CLEAN_ERROR% NEQ 0 (
    echo Exit code: %CLEAN_ERROR% >> %LOG%
) ELSE (
    echo Exit code: 0 (Success) >> %LOG%
)
echo ======================================== >> %LOG%

echo.
echo Script completed. Log saved to: %LOG%
echo.
