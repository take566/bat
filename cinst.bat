@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Chocolateyパッケージ自動インストールツール
echo ===================================================
echo 日付: %date%
echo 時刻: %time%
echo.

REM 日時情報の取得
SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%
SET time2=%time: =0%
SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

REM ログディレクトリの設定
SET LOG_DIR=C:\work\log
SET LOG=%LOG_DIR%\cinst_%filename%.txt
SET TEMP_FILE=%TEMP%\packages_to_install.txt

REM ログディレクトリの存在確認、なければ作成
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo ログディレクトリを作成しました: %LOG_DIR%
)

REM パッケージリストファイルの存在確認
SET PACKAGE_LIST=packages.txt
IF NOT EXIST "%PACKAGE_LIST%" (
    echo エラー: パッケージリストファイル（%PACKAGE_LIST%）が見つかりません。
    echo 同じディレクトリに %PACKAGE_LIST% ファイルを作成してください。
    echo 処理を中止します。
    goto :EOF
)

echo ログファイル: %LOG%
echo パッケージリスト: %PACKAGE_LIST%
echo.

REM 一時ファイルの初期化
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

REM パッケージリストの読み込みとフィルタリング
echo パッケージリストを読み込んでいます...
set count=0
for /F "usebackq tokens=* eol=# delims=" %%A in ("%PACKAGE_LIST%") do (
    set line=%%A
    if not "!line!"=="" (
        echo !line!>>"%TEMP_FILE%"
        set /a count+=1
    )
)

echo インストール対象パッケージ数: !count!
echo.

REM パッケージが見つからない場合
if !count! EQU 0 (
    echo 警告: インストール対象のパッケージが見つかりません。
    echo %PACKAGE_LIST% ファイルを確認してください。
    echo 処理を中止します。
    goto :EOF
)

REM インストール開始
echo ===================================================
echo Chocolateyパッケージのインストールを開始します...
echo ===================================================
echo.

REM ログファイルのヘッダー
echo ===== Chocolateyパッケージインストールログ ===== > "%LOG%"
echo 日時: %date% %time% >> "%LOG%"
echo パッケージリスト: %PACKAGE_LIST% >> "%LOG%"
echo インストール対象パッケージ数: !count! >> "%LOG%"
echo. >> "%LOG%"

REM 一括インストールコマンドの構築
set packages=
for /F "usebackq tokens=*" %%A in ("%TEMP_FILE%") do (
    set packages=!packages! %%A
)

REM インストールの実行
echo インストールするパッケージ:!packages!
echo.
echo インストールを開始します...この処理には時間がかかる場合があります。
echo.

echo choco install!packages! -y >> "%LOG%"
choco install!packages! -y >> "%LOG%" 2>&1

REM 結果の確認
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo 警告: 一部のパッケージのインストールに失敗した可能性があります。
    echo ログファイル（%LOG%）を確認してください。
) ELSE (
    echo.
    echo すべてのパッケージが正常にインストールされました。
)

REM 一時ファイルの削除
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

echo.
echo ===================================================
echo インストール処理が完了しました。
echo ログファイル: %LOG%
echo ===================================================
echo.
echo 何かキーを押すと終了します...
pause > nul
