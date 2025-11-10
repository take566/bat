@echo off
chcp 65001 > nul
echo ========================================
echo NASタスク登録デバッグツール
echo ========================================
echo.

echo 1. 現在のディレクトリ確認
echo 現在のディレクトリ: %CD%
echo.

echo 2. ファイル存在確認
if exist "NasMountTask.xml" (
    echo  NasMountTask.xml が見つかりました
) else (
    echo  NasMountTask.xml が見つかりません
    pause
    exit /b 1
)

if exist "nas_mount.bat" (
    echo  nas_mount.bat が見つかりました
) else (
    echo  nas_mount.bat が見つかりません
    pause
    exit /b 1
)

echo.

echo 3. 管理者権限確認
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo  管理者権限で実行されています
) else (
    echo  管理者権限がありません
    echo 右クリック -^> 「管理者として実行」を選択してください
    pause
    exit /b 1
)

echo.

echo 4. タスクスケジューラーサービス確認
sc query Schedule | find "RUNNING" >nul
if %errorlevel% equ 0 (
    echo  タスクスケジューラーサービスが実行中です
) else (
    echo  タスクスケジューラーサービスが停止しています
    echo サービスを開始してください
    pause
    exit /b 1
)

echo.

echo 5. 既存のタスク確認
echo 既存のNAS Mount Taskを確認中...
schtasks /query /tn "NAS Mount Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo 既存のタスクが見つかりました
    echo タスクの詳細:
    schtasks /query /tn "NAS Mount Task" /fo list
    echo.
    set /p choice="既存のタスクを削除しますか？ (y/n): "
    if /i "%choice%"=="y" (
        echo タスクを削除中...
        schtasks /delete /tn "NAS Mount Task" /f
        if %errorlevel% equ 0 (
            echo  タスクを削除しました
        ) else (
            echo  タスクの削除に失敗しました
        )
    )
) else (
    echo 既存のタスクは見つかりませんでした
)

echo.

echo 6. XMLファイルの内容確認
echo NasMountTask.xmlの内容を確認中...
type "NasMountTask.xml"
echo.

echo 7. タスク登録テスト
echo タスクを登録中...
schtasks /create /xml "NasMountTask.xml" /tn "NAS Mount Task" /v

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo  タスクが正常に登録されました！
    echo ========================================
    echo.
    echo 登録されたタスクの詳細:
    schtasks /query /tn "NAS Mount Task" /fo list
) else (
    echo.
    echo ========================================
    echo  タスクの登録に失敗しました
    echo ========================================
    echo エラーコード: %errorlevel%
    echo.
    echo 詳細なエラー情報を確認してください
)

echo.
pause 