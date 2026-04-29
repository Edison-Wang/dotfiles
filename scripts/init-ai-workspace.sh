#!/usr/bin/env bash
# ===================================================================
# init-ai-workspace.sh
# ===================================================================
# 在指定專案建立 ai/ 工作空間（目前只含 workflow-state.md）。
# 預設使用 .git/info/exclude 排除（本機，不影響團隊）。
#
# 使用方式：
#   cd ~/my-project && bash ~/dotfiles/scripts/init-ai-workspace.sh
#   bash ~/dotfiles/scripts/init-ai-workspace.sh /path/to/project
#   bash ~/dotfiles/scripts/init-ai-workspace.sh /path/to/project --dry-run
#   bash ~/dotfiles/scripts/init-ai-workspace.sh /path/to/project --gitignore
#
# 選項：
#   --dry-run    只顯示會做什麼，不實際執行
#   --gitignore  把 ai/ 寫到 .gitignore（會進版控影響團隊），預設不寫
#
# 安全檢查：
#   - 拒絕在 $HOME、/、$DOTFILES_DIR 自身執行
#   - 目標需是 git repo 或含 README（避免在隨機目錄建立）
#   - ai/workflow-state.md 已存在則跳過，不覆蓋
# ===================================================================

set -euo pipefail

# ---- 參數解析 ------------------------------------------------------
TARGET=""
DRY_RUN=0
USE_GITIGNORE=0

for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=1 ;;
    --gitignore) USE_GITIGNORE=1 ;;
    -h|--help)
      sed -n '2,22p' "$0" | sed 's/^# //;s/^#//'
      exit 0
      ;;
    -*) echo "❌ 未知選項：$arg" >&2; exit 1 ;;
    *)
      if [ -z "$TARGET" ]; then
        TARGET="$arg"
      else
        echo "❌ 多餘參數：$arg" >&2; exit 1
      fi
      ;;
  esac
done

TARGET="${TARGET:-$PWD}"

# 解析絕對路徑（兼容無 realpath 的環境）
if command -v realpath >/dev/null 2>&1; then
  TARGET="$(realpath "$TARGET")"
else
  TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
    echo "❌ 找不到目標目錄：$TARGET" >&2; exit 1
  }
fi

# 解析 dotfiles 路徑（不寫死 ~/dotfiles）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_SRC="$DOTFILES_DIR/templates/ai-workspace/workflow-state.md"

# ---- 安全檢查 ------------------------------------------------------
if [ ! -d "$TARGET" ]; then
  echo "❌ 目標不是目錄：$TARGET" >&2
  exit 1
fi

# 拒絕危險路徑
case "$TARGET" in
  "$HOME"|"/"|"$DOTFILES_DIR")
    echo "❌ 拒絕在 $TARGET 執行（home / 根目錄 / dotfiles 自身）" >&2
    echo "   請進入實際的專案目錄再跑" >&2
    exit 1
    ;;
esac

# 必須是 git repo 或含 README
if [ ! -d "$TARGET/.git" ] && ! ls "$TARGET"/README* >/dev/null 2>&1; then
  echo "❌ 目標看起來不是專案（無 .git 也無 README）：$TARGET" >&2
  echo "   如果確認要在此建立，請先 git init 或建立 README" >&2
  exit 1
fi

# 確認模板存在
if [ ! -f "$TEMPLATE_SRC" ]; then
  echo "❌ 找不到模板：$TEMPLATE_SRC" >&2
  exit 1
fi

# ---- 動作執行 ------------------------------------------------------
AI_DIR="$TARGET/ai"
WS_FILE="$AI_DIR/workflow-state.md"

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] $*"
  else
    eval "$@"
  fi
}

echo "📂 目標專案：$TARGET"
[ "$DRY_RUN" -eq 1 ] && echo "🔍 dry-run 模式（不會實際修改）"

# 1. 建立 ai/ 目錄
if [ -d "$AI_DIR" ]; then
  echo "ℹ️  ai/ 已存在，跳過建立"
else
  echo "➕ 建立目錄：ai/"
  run "mkdir -p \"$AI_DIR\""
fi

# 2. 複製模板
if [ -f "$WS_FILE" ]; then
  echo "⚠️  ai/workflow-state.md 已存在，跳過（不覆蓋既有進度）"
else
  echo "➕ 複製模板：ai/workflow-state.md"
  run "cp \"$TEMPLATE_SRC\" \"$WS_FILE\""
fi

# 3. 設定 git exclude
if [ -d "$TARGET/.git" ]; then
  if [ "$USE_GITIGNORE" -eq 1 ]; then
    GI="$TARGET/.gitignore"
    if [ -f "$GI" ] && grep -qxF "ai/" "$GI" 2>/dev/null; then
      echo "ℹ️  .gitignore 已含 ai/，跳過"
    else
      echo "➕ 寫入 .gitignore（會進版控）：ai/"
      run "printf '\nai/\n' >> \"$GI\""
    fi
  else
    EXCL="$TARGET/.git/info/exclude"
    if [ -f "$EXCL" ] && grep -qxF "ai/" "$EXCL" 2>/dev/null; then
      echo "ℹ️  .git/info/exclude 已含 ai/，跳過"
    else
      echo "➕ 寫入 .git/info/exclude（本機，不影響團隊）：ai/"
      run "mkdir -p \"$TARGET/.git/info\""
      run "printf '\nai/\n' >> \"$EXCL\""
    fi
  fi
else
  echo "ℹ️  非 git repo，略過 exclude 設定"
fi

echo ""
echo "✅ 完成"
echo ""
echo "下一步："
echo "  1. 在 Cursor 對話中：「依工作流執行 @ai/workflow-state.md」"
echo "  2. AI 會偵測到 CurrentTask=<unset>，主動問你要做什麼"
echo "  3. 你回答後，AI 自動寫入並進入 ANALYZE → BLUEPRINT"
echo "  4. BLUEPRINT 完成後停下等你確認計畫，再進入 CONSTRUCT"
