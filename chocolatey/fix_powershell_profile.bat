@echo off
chcp 65001 > nul

echo ===================================================
echo PowerShellプロファイル問題解決ツール
echo ===================================================
echo.

REM 管理者権限の確認
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo エラー: このスクリプトは管理者権限で実行する必要があります。
    echo 右クリックして「管理者として実行」を選択してください。
    goto :EOF
)

echo PowerShellプロファイルの問題を解決しています...
echo.

REM PowerShellプロファイルのバックアップ
set PROFILE_PATH=%USERPROFILE%\OneDrive\ドキュメント\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
if exist "%PROFILE_PATH%" (
    echo 既存のプロファイルをバックアップしています...
    copy "%PROFILE_PATH%" "%PROFILE_PATH%.backup" >nul
    echo バックアップ完了: %PROFILE_PATH%.backup
    echo.
)

REM 実行ポリシーを一時的に変更
echo PowerShellの実行ポリシーを変更しています...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

IF %ERRORLEVEL% NEQ 0 (
    echo 実行ポリシーの変更に失敗しました。
    echo 管理者権限で実行してください。
    goto :EOF
)

echo 実行ポリシーを RemoteSigned に変更しました。
echo.

REM プロファイルファイルを無効化
if exist "%PROFILE_PATH%" (
    echo 問題のあるプロファイルファイルを無効化しています...
    ren "%PROFILE_PATH%" "Microsoft.PowerShell_profile.ps1.disabled"
    echo プロファイルファイルを無効化しました。
    echo.
)

echo ===================================================
echo 修正完了！
echo ===================================================
echo.
echo 修正内容:
echo 1. PowerShell実行ポリシーを RemoteSigned に変更
echo 2. 問題のあるプロファイルファイルを無効化
echo 3. プロファイルファイルをバックアップ
echo.
echo これで Chocolatey のインストールが可能になります。
echo.
pause
