# Batch Scripts Collection

Windows用バッチスクリプトのコレクション

## ディレクトリ構造

```
bat-master/
├── chocolatey/     # Chocolateyパッケージマネージャー関連
├── nas/           # NAS（Network Attached Storage）関連
├── docker/        # DockerとKubernetes関連
├── tasks/         # Windowsタスクスケジューラ関連
├── utils/         # 汎用ユーティリティ
├── docs/          # ドキュメント
├── log/           # ログファイル
└── .github/       # GitHub設定
```

## 主要機能

### 1. Chocolatey Package Management
- パッケージの一括インストール
- 自動更新タスクの設定
- PowerShellプロファイル問題の解決

### 2. NAS Management
- NASドライブの自動マウント
- マウント状況の監視
- タスクスケジューラでの自動化

### 3. Docker & Kubernetes
- Docker Machineの起動
- Minikubeクラスターの管理
- コンテナ・イメージのクリーンアップ

### 4. Task Scheduler
- Windowsタスクの作成・管理
- 時間ベースタスクの設定
- デバッグ・テストツール

### 5. Utilities
- 管理者権限での実行
- ファイル操作
- システム設定

## 使用方法

### 初回セットアップ
1. `chocolatey/run_cinst_as_admin.bat`を管理者権限で実行
2. Chocolateyとパッケージが自動インストールされます

### 日常的な使用
- 各ディレクトリのREADME.mdを参照
- 必要に応じて管理者権限で実行

## 注意事項

- すべてのスクリプトは管理者権限で実行してください
- 初回実行時はChocolateyのインストールが必要です
- インストールには時間がかかる場合があります
- 各ディレクトリのREADME.mdで詳細な使用方法を確認してください
