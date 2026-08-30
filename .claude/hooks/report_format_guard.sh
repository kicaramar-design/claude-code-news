#!/usr/bin/env bash
# PostToolUse hook (matcher: Write|Edit)
# reports/<category>/YYYY-MM-DD.md の出力フォーマット崩れを検知する安全網。
input=$(cat)

tool_name=$(printf '%s' "$input" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
case "$tool_name" in
  Write|Edit) ;;
  *) exit 0 ;;
esac

file_path=$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
case "$file_path" in
  */reports/*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md) ;;
  *) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0

errors=""
head -n 1 "$file_path" | grep -q '^# ' || errors="${errors}1行目が見出し(# )で始まっていません。"
grep -q '^出典: ' "$file_path" || errors="${errors} 「出典: 」で始まる行が見つかりません。"

if [ -n "$errors" ]; then
  echo "レポート $file_path のフォーマットに問題があります:$errors SKILL.mdの出力フォーマットに沿って修正してください。" >&2
  exit 2
fi

exit 0
