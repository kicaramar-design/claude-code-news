#!/usr/bin/env bash
# PostToolUse hook (matcher: Bash)
# git push が失敗しているのに気づかず成功として報告するのを防ぐ安全網。
input=$(cat)

tool_name=$(printf '%s' "$input" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
[ "$tool_name" = "Bash" ] || exit 0

command=$(printf '%s' "$input" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1)
case "$command" in
  *"git push"*) ;;
  *) exit 0 ;;
esac

if printf '%s' "$input" | grep -qE '"is_error"[[:space:]]*:[[:space:]]*true|non-fast-forward|rejected|fatal:|error: failed to push'; then
  echo "git push に失敗した可能性があります。Slack通知の前に、push が実際に成功したか(git status / git log / git ls-remote 等で)必ず確認し、失敗していれば失敗内容をSlack通知に明記してください。" >&2
  exit 2
fi

exit 0
