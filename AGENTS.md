# Agents

## script-reviewer

バッチスクリプトのレビュー・品質チェック担当。

### Responsibilities

- スクリプトのエラーハンドリング確認
- ログ出力パターンの統一性チェック
- 管理者権限要否の確認
- PATH設定の妥当性検証（タスクスケジューラ実行時を考慮）
- 認証情報のハードコード検出

### Review Checklist

- `IF %ERRORLEVEL%` によるエラーチェックが含まれているか
- ログ出力先が `C:\work\log` に統一されているか
- タイムスタンプ形式が `YYYY-MMDD-HHMMSS` に従っているか
- `REM` コメントで処理内容が説明されているか
