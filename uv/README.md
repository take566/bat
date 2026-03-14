# uv Cache Clean Tools

uvパッケージマネージャーのキャッシュクリーンアップ関連スクリプト

## ファイル説明

### キャッシュクリーンアップ
- `uv_cache_clean.bat` - uvキャッシュのクリーンアップ実行
- `register_uv_cache_clean_task.bat` - 定期クリーンアップタスクの登録
- `remove_uv_cache_clean_task.bat` - 定期クリーンアップタスクの削除
- `UvCacheCleanTask.xml` - タスクスケジューラ用XML

## 使用方法

### 手動実行
1. `uv_cache_clean.bat` をダブルクリック
2. uvキャッシュが自動的にクリーンアップされます
3. 実行結果は `log\uv_cache_clean_YYYY-MMDD-HHMMSS.txt` に保存されます

### 定期実行の設定
1. `register_uv_cache_clean_task.bat` を右クリック -> 「管理者として実行」
2. タスクスケジューラに「UV Cache Clean Task」が登録されます
3. 毎週日曜日午前3時に自動実行されます

### 定期実行の解除
1. `remove_uv_cache_clean_task.bat` を右クリック -> 「管理者として実行」

## 注意事項
- uvがインストールされている必要があります（`uv` コマンドが利用可能であること）
- タスクスケジューラからの実行時は `%USERPROFILE%\.local\bin` を自動的にPATHに追加します
- ログファイルは親ディレクトリの `log\` フォルダに出力されます
