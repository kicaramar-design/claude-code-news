---
name: news-report
description: Generate today's Japanese news-roundup report for one or all categories (ai, sonpo, jinzai) in this repo's fixed format, commit it, and — when run as part of the daily automated routine — push and notify Slack. Use when asked to generate/update a claude-code-news daily report, or when running the scheduled daily automation.
---

# 日次ニュースレポート生成

このリポジトリ（claude-code-news）は毎朝6時(JST)に3カテゴリのニュースレポートを自動生成・コミット・push し、Slackで完了通知する運用。

## カテゴリと検索観点

- `ai` — AI関連の最新ニュース（新モデル発表、業界動向、規制、企業ニュースなど）
- `sonpo` — 損害保険関連の最新ニュース（保険料改定、業界再編、規制動向、大手損保のリリースなど）
- `jinzai` — 企業の人材育成・スキル育成関連の最新ニュース

各カテゴリでWeb検索を行い、原則過去24時間以内（どうしても件数が足りない場合のみ過去48時間以内）に公開・更新された日本語ニュース、または日本語で要約可能な海外ニュースを5〜6件選ぶ。検索結果ごとに公開日を確認し、公開日が不明な記事・数日以上前の古い記事・過去記事の再掲は候補から除外する。件数が足りなくても無理に古い記事で埋めない。

## 出力フォーマット

ファイルパス: `reports/<カテゴリ>/YYYY-MM-DD.md`

```
# <カテゴリ日本語名>ニュースまとめ (YYYY-MM-DD)

## <見出し>
<1段落の要約（2〜4文程度）>
出典: <URL>

## <見出し>
<1段落の要約>
出典: <URL>
```

- カテゴリ日本語名: `ai`→「AI」、`sonpo`→「損害保険」、`jinzai`→「人材育成・スキル育成」
- 見出しは記事の要点が一目で分かる形にする（固有名詞・数値を入れる）
- 要約は事実ベースで簡潔に。憶測や意見は混ぜない
- 出典URLは1件につき1つ、実際に参照した記事のURLを記載する

## コミット

レポート追加後、`git add` してコミットする。コミットメッセージは既存コミット（例:「2026-08-29 のAI・損害保険ニュースレポートを追加」）に合わせて、`YYYY-MM-DD の<カテゴリ日本語名を「・」区切りで列挙>ニュースレポートを追加` の形式にする。同日分を再生成した場合で内容に変更がなければコミットはスキップしてよい。

## 新カテゴリ追加時の注意

`reports/<カテゴリ>/` フォルダがまだ存在しない場合は新規作成してよい（例: `jinzai` は初回生成時にフォルダごと作る）。

## 自動実行（毎朝6時の日次ルーティン）時の追加手順

日次の自動実行では、このスキルを `ai` / `sonpo` / `jinzai` の3カテゴリすべてに対して実行し、さらに以下を行う。

1. 日本時間(Asia/Tokyo)での本日の日付をYYYY-MM-DD形式で取得する（例: `TZ=Asia/Tokyo date +%Y-%m-%d`）。
2. 3カテゴリ分のレポートを上記フォーマットで作成・保存する。
3. まとめて1コミットにする。作者情報が未設定の場合は `git config user.name "claude-code-news-bot"` と `git config user.email "noreply@anthropic.com"` をこのリポジトリ内にローカル設定してからコミットする。
4. `git push origin main` でリモートにpushする。
5. Slackの `slack_send_message` ツールで、channel_id `U0BU82A6U6L`（本人宛DM）に完了通知を送る。通知には次を含める。
   - 対象日付
   - push成否
   - 成功時: 作成した3レポートのファイルパス（`reports/ai/<DATE>.md` など）とそれぞれの見出し一覧、リポジトリへのリンク（`https://github.com/kicaramar-design/claude-code-news`）
   - 失敗時: 何が失敗したか（git pushのエラー内容など）と必要な対応
   - いずれかのカテゴリで直近ニュースの件数が少なかった場合はその旨も一言添える
   - この通知は、コミット・pushがスキップされた場合（同一内容で変更なしの場合）も含めて毎回必ず送信する
