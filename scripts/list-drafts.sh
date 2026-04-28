#!/usr/bin/env bash
# ===================================================================
# list-drafts.sh
# ===================================================================
# 重新生成 _drafts/README.md 的「目前內容」清單。
#
# 使用方式：
#   cd ~/dotfiles
#   bash scripts/list-drafts.sh
#
# 機制：找到 _drafts/README.md 的「## 目前內容」marker，
# 替換它後面的清單為當前 _drafts/ 下所有 .md 檔案。
# - 用 -mindepth 2 排除頂層 _drafts/README.md，
#   但保留巢狀 README.md（例如 _drafts/tools/gemini/README.md）。
# - 按第一層目錄分類（prompts、tools、workflows、assets）。
# - 每個檔案附簡短描述：
#     優先：YAML frontmatter 的 description: 欄位
#     次選：檔案第一個 H1（去掉開頭 `# `）
# ===================================================================

set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f "_drafts/README.md" ]; then
  echo "❌ 找不到 _drafts/README.md，請在 dotfiles 根目錄執行"
  exit 1
fi

MARKER="## 目前內容"
TMP="$(mktemp)"

# 抓 marker 之前的所有內容（保留固定段落）
awk -v marker="$MARKER" '$0 == marker { exit } { print }' _drafts/README.md > "$TMP"

# 從檔案抽出簡短描述
# 順序：YAML frontmatter description > 第一個 H1 > "(無描述)"
get_description() {
  local file="$1"
  local desc
  desc=$(awk '
    BEGIN { fence = 0 }
    /^---$/ { fence++; next }
    fence == 1 && /^description:/ {
      sub(/^description:[ ]*/, "")
      print
      exit
    }
  ' "$file")
  if [ -n "$desc" ]; then
    echo "$desc"
    return
  fi
  desc=$(awk '/^# / { sub(/^# /, ""); print; exit }' "$file")
  echo "${desc:-(無描述)}"
}

# 列出某分類下所有檔案
emit_section() {
  local category="$1"
  local dir="_drafts/$category"
  if [ ! -d "$dir" ]; then
    return
  fi
  local files
  files=$(find "$dir" -mindepth 1 -type f -name '*.md' | sort)
  if [ -z "$files" ]; then
    return
  fi
  local count
  count=$(echo "$files" | wc -l | tr -d ' ')
  echo ""
  echo "### ${category}/（${count}）"
  while IFS= read -r path; do
    local rel="${path#_drafts/$category/}"
    local desc
    desc=$(get_description "$path")
    echo "- \`$rel\` — $desc"
  done <<< "$files"
}

# 重新加上 marker 區段
{
  echo "$MARKER"
  echo "（最後更新：$(date +%Y-%m-%d)，由 scripts/list-drafts.sh 生成）"
  emit_section "prompts"
  emit_section "tools"
  emit_section "workflows"
  emit_section "assets"
} >> "$TMP"

mv "$TMP" _drafts/README.md
echo "✅ _drafts/README.md 已更新"
total=$(find _drafts -mindepth 2 -type f -name '*.md' | wc -l | tr -d ' ')
echo "   draft 數量：$total"
