#!/usr/bin/env bash
set -euo pipefail

BASE64_FILE="hello.docx.base64"
TARGET_FILE="hello.docx"

if [ ! -f "$BASE64_FILE" ]; then
  echo "找不到 $BASE64_FILE，請先確認檔案存在於 repo root。"
  exit 1
fi

# 解碼（Linux / macOS）
if base64 --help >/dev/null 2>&1; then
  base64 --decode "$BASE64_FILE" > "$TARGET_FILE" || base64 -d "$BASE64_FILE" > "$TARGET_FILE"
else
  base64 -d "$BASE64_FILE" > "$TARGET_FILE"
fi

echo "已產生 $TARGET_FILE"

# CI/Workflow 可設環境變數 GIT_COMMIT_IF_PRESENT=1 來自動 commit
if [ -n "
${GIT_COMMIT_IF_PRESENT:-}" ]; then
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add "$TARGET_FILE"
  git commit -m "Generate hello.docx from hello.docx.base64" || echo "No changes to commit"
  git push
fi
