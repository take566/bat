@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 管理者権限を要求しています...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

chcp 65001 > nul
echo ========================================
echo Chocolatey更新タスクをタスクスケジューラーに登録します...
echo ========================================
echo.

REM 現在のディレクトリを表示
echo 現在のディレクトリ: %CD%
echo.

REM XMLファイルの存在確認
if not exist "ChocoUpdateTask.xml" (
    echo エラー: ChocoUpdateTask.xml が見つかりません。
    echo 現在のディレクトリ: %CD%
    echo ファイル一覧:
    dir /b
    pause
    exit /b 1
)

echo ChocoUpdateTask.xml が見つかりました。
echo.

REM 既存のタスクを削除（存在する場合）
echo 既存のタスクを確認中...
schtasks /query /tn "Chocolatey Update Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo 既存のタスクを削除中...
    schtasks /delete /tn "Chocolatey Update Task" /f
    if %errorlevel% equ 0 (
        echo 既存のタスクを削除しました。
    ) else (
        echo 警告: 既存のタスクの削除に失敗しました。
    )
    echo.
)

REM タスクをインポート
echo 新しいタスクを登録中...
schtasks /create /xml "ChocoUpdateTask.xml" /tn "Chocolatey Update Task"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo タスクが正常に登録されました！
    echo ========================================
    echo タスク名: Chocolatey Update Task
    echo 実行スケジュール: 
    echo  - 毎週月曜日午前10時
    echo.
    echo タスクの詳細を確認中...
    schtasks /query /tn "Chocolatey Update Task" /fo list
) else (
    echo.
    echo ========================================
    echo エラー: タスクの登録に失敗しました。
    echo ========================================
    echo エラーコード: %errorlevel%
    echo.
    echo 考えられる原因:
    echo 1. 管理者権限が不足しています
    echo 2. XMLファイルの形式に問題があります
    echo 3. タスクスケジューラーサービスが無効になっています
    echo.
    echo 対処法:
    echo - 右クリック -^> 「管理者として実行」を選択してください
    echo - XMLファイルの内容を確認してください
    echo - タスクスケジューラーサービスが有効になっているか確認してください
    echo.
    echo 詳細なエラー情報を確認するには:
    echo schtasks /create /xml "ChocoUpdateTask.xml" /tn "Chocolatey Update Task" /v
)

echo.
pause 