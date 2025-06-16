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
echo NASマウントタスクをタスクスケジューラーに登録します...
echo 管理者権限が必要です。

REM タスクをインポート
schtasks /create /xml "NasMountTask.xml" /tn "NAS Mount Task"

if %errorlevel% equ 0 (
    echo タスクが正常に登録されました。
    echo タスク名: NAS Mount Task
    echo 実行スケジュール: 
    echo  - システムログオン時
    echo  - 毎日午前9時
) else (
    echo エラー: タスクの登録に失敗しました。
    echo 管理者権限でこのバッチファイルを実行してください。
    echo 右クリック -^> 「管理者として実行」を選択してください。
)

pause
