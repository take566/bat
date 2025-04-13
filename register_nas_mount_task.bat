@echo off
echo NASマウントタスクをタスクスケジューラーに登録します...
echo 管理者権限が必要です。

REM タスクをインポート
schtasks /create /xml "C:\work\bat\NasMountTask.xml" /tn "NAS Mount Task"

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
