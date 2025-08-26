# NAS Tools

NAS（Network Attached Storage）関連のスクリプト

## ファイル説明

### マウント関連
- `nas_mount.bat` - NASドライブのマウント
- `check_nas_mounts.bat` - NASマウント状況の確認

### タスク設定
- `register_nas_mount_task.bat` - NASマウントタスクの登録
- `setup_nas_task_admin.bat` - NASタスクの管理者設定
- `setup_nas_check_task.bat` - NASチェックタスクの設定
- `setup_hourly_nas_task.ps1` - 時間ベースNASタスクの設定（PowerShell）

### 設定ファイル
- `NasMountTask.xml` - タスクスケジューラ用XML設定

## 使用方法

1. `nas_mount.bat`でNASドライブをマウント
2. `register_nas_mount_task.bat`で自動マウントタスクを登録
3. `check_nas_mounts.bat`でマウント状況を確認

