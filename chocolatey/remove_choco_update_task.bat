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
echo Chocolatey更新タスクをタスクスケジューラーから削除します...
echo ========================================
echo.

REM 既存のタスクを確認
echo 既存のタスクを確認中...
schtasks /query /tn "Chocolatey Update Task" >nul 2>&1
if %errorlevel% equ 0 (
    echo タスクが見つかりました。削除中...
    schtasks /delete /tn "Chocolatey Update Task" /f
    if %errorlevel% equ 0 (
        echo.
        echo ========================================
        echo タスクが正常に削除されました！
        echo ========================================
        echo タスク名: Chocolatey Update Task
    ) else (
        echo.
        echo ========================================
        echo エラー: タスクの削除に失敗しました。
        echo ========================================
        echo エラーコード: %errorlevel%
    )
) else (
    echo.
    echo ========================================
    echo タスクが見つかりませんでした。
    echo ========================================
    echo タスク名: Chocolatey Update Task
    echo このタスクは既に削除されているか、存在しません。
)

echo.
pause 