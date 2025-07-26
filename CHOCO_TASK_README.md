# Chocolatey更新タスクスケジューラ設定

このフォルダには、Chocolateyパッケージを定期的に更新するためのタスクスケジューラ設定が含まれています。

## ファイル構成

- `choco update.bat` - Chocolateyの更新を実行するメインスクリプト
- `ChocoUpdateTask.xml` - タスクスケジューラの設定ファイル
- `register_choco_update_task.bat` - タスクを登録するスクリプト
- `remove_choco_update_task.bat` - タスクを削除するスクリプト

## 実行スケジュール

- **頻度**: 毎週月曜日
- **時刻**: 午前10時
- **実行時間制限**: 2時間

## 使用方法

### 1. タスクの登録

管理者権限で `register_choco_update_task.bat` を実行してください。

```cmd
# 右クリック → 「管理者として実行」を選択
register_choco_update_task.bat
```

### 2. タスクの削除

管理者権限で `remove_choco_update_task.bat` を実行してください。

```cmd
# 右クリック → 「管理者として実行」を選択
remove_choco_update_task.bat
```

### 3. 手動実行

タスクスケジューラから手動で実行することも可能です：

1. タスクスケジューラを開く
2. 「タスク スケジューラ ライブラリ」を展開
3. 「Chocolatey Update Task」を右クリック
4. 「実行」を選択

## ログファイル

実行結果は `log/` フォルダに保存されます：

- ファイル名形式: `clist_YYYY-MMDD-HHMMSS.txt`
- 例: `clist_2025-0127-100000.txt`

## 設定の変更

スケジュールを変更したい場合は、`ChocoUpdateTask.xml` を編集してください：

### 毎日実行する場合
```xml
<ScheduleByDay>
  <DaysInterval>1</DaysInterval>
</ScheduleByDay>
```

### 毎月実行する場合
```xml
<ScheduleByMonth>
  <DaysOfMonth>
    <Day>1</Day>
  </DaysOfMonth>
</ScheduleByMonth>
```

### 時刻を変更する場合
`StartBoundary` の値を変更してください：
```xml
<StartBoundary>2025-01-27T15:00:00</StartBoundary>
```

## 注意事項

- 管理者権限が必要です
- インターネット接続が必要です
- 実行中は他のChocolatey操作を避けてください
- ログファイルは自動的に作成されます

## トラブルシューティング

### タスクが実行されない場合

1. タスクスケジューラーサービスが有効になっているか確認
2. 管理者権限でタスクが登録されているか確認
3. ログファイルでエラー内容を確認

### 権限エラーが発生する場合

1. スクリプトを右クリック → 「管理者として実行」を選択
2. UAC（ユーザーアカウント制御）の設定を確認

### ネットワークエラーが発生する場合

1. インターネット接続を確認
2. プロキシ設定を確認
3. ファイアウォール設定を確認 