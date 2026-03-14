# bat - Windows Batch Scripts Collection

Windows用システム管理・開発環境バッチスクリプト集。

## Structure

```
bat/
├── chocolatey/  # Chocolateyパッケージ管理（インストール・自動更新）
├── nas/         # NASドライブ自動マウント・監視
├── docker/      # Docker/Kubernetes起動・クリーンアップ
├── tasks/       # Windowsタスクスケジューラ操作
├── utils/       # 管理者権限実行、ファイル操作、システム設定
├── uv/          # uvキャッシュクリーンアップ（週次自動実行）
├── data/        # データファイル（gitignore推奨）
├── docs/        # 詳細ドキュメント
└── .github/     # GitHub Actions設定
```

## Key Patterns

- ログ出力先: `C:\work\log` （YYYY-MMDD-HHMMSS形式）
- 管理者権限: ほぼ全スクリプトで必要（右クリック -> 管理者として実行）
- タスク登録: `register_*_task.bat` で登録、`remove_*_task.bat` で解除
- エラーハンドリング: `IF %ERRORLEVEL%` パターンで統一
- 変数命名: `SET LOG_DIR=`, `SET LOG=` 等の統一規約
- 出力リダイレクト: `>> "%LOG%" 2>&1` でログファイルへ
- コメント: `REM` を使用

## Gotchas

- タスクスケジューラ実行時はPATHが通常と異なる。`choco update.bat`等では明示的にPATH設定が必要
- NASスクリプトには認証情報が埋め込まれている（取り扱い注意）
- Chocolatey v2.6.0以降: `choco list` コマンドの仕様変更あり
- スクリプト名にスペースを含むファイルあり（例: `docker-machine start - hv.bat`）
- 遅延展開（`ENABLEDELAYEDEXPANSION`）を使う複雑なスクリプトあり

## Rules

- 絵文字禁止
- 新規スクリプト作成時は既存のログ・エラーハンドリングパターンに従うこと
- READMEは各サブディレクトリに配置
- 各サブディレクトリのREADME.mdで詳細な使用方法を確認

## Dependencies

- Chocolatey package manager
- Docker Desktop
- uv (Python package manager)
- Windows Task Scheduler
- 管理者権限
