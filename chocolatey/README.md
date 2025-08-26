# Chocolatey Tools

Chocolateyパッケージマネージャー関連のスクリプト

## ファイル説明

### インストール関連
- `install_chocolatey.bat` - Chocolateyのインストール
- `install_packages.bat` - パッケージの一括インストール
- `install_packages_individual.bat` - パッケージの個別インストール
- `run_cinst_as_admin.bat` - 一括実行（推奨）
- `cinst.bat` - 詳細なログ付きインストール
- `packages.txt` - インストールするパッケージのリスト

### 設定・修正
- `fix_powershell_profile.bat` - PowerShellプロファイル問題の解決

### 更新・タスク
- `choco update.bat` - Chocolateyパッケージの更新
- `register_choco_update_task.bat` - 自動更新タスクの登録
- `remove_choco_update_task.bat` - 自動更新タスクの削除
- `ChocoUpdateTask.xml` - タスクスケジューラ用XML
- `CHOCO_TASK_README.md` - タスク設定の詳細説明

## 使用方法

### 推奨方法（一括実行）
1. `run_cinst_as_admin.bat`をダブルクリック
2. 管理者権限の確認ダイアログで「はい」を選択
3. Chocolateyのインストールとパッケージのインストールが自動実行されます

### 個別実行
1. `install_chocolatey.bat`を管理者権限で実行（Chocolateyのインストール）
2. `install_packages.bat`を管理者権限で実行（パッケージの一括インストール）

### 個別インストール（推奨）
- `install_packages_individual.bat`を管理者権限で実行（パッケージを1つずつインストール、より確実）

### 詳細ログ付き実行
- `cinst.bat`を管理者権限で実行（詳細なログが生成されます）
