---
name: news-report
description: Generate today's Japanese news-roundup report for one category (ai, sonpo, or jinzai) in this repo's fixed format and commit it. Use when asked to generate/update a claude-code-news daily report.
---

# 日次ニュースレポート生成

このリポジトリ（claude-code-news）は毎朝6時に3カテゴリのニュースレポートを自動生成・コミットする運用。

## カテゴリと検索観点

- `ai` — AI関連の最新ニュース（新モデル発表、業界動向、規制、企業ニュースなど）
- `sonpo` — 損害保険関連の最新ニュース（保険料改定、業界再編、規制動向、大手損保のリリースなど）
- `jinzai` — 企業の人材育成・スキル育成関連の最新ニュース

各カテゴリでWeb検索を行い、直近（当日〜数日以内）の日本語ニュース、または日本語で要約可能な海外ニュースを5〜6件選ぶ。

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
- 出典URLは1件につき1つ、実際に参照した記事の URL を記載する

## コミット

レポート追加後、`git add` してコミットする。コミットメッセージは既存コミット（例: 「2026-08-29 のAI・損害保険ニュースレポートを追加」）に合わせて、`YYYY-MM-DD の<カテゴリ日本語名を「・」区切りで列挙>ニュースレポートを追加` の形式にする。

## 新カテゴリ追加時の注意

`reports/<カテゴリ>/` フォルダがまだ存在しない場合は新規作成してよい（例: `jinzai` は初回生成時にフォルダごと作る）。
