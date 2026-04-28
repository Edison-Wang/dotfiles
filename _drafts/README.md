# _drafts/

未啟用的範本「冷藏庫」。這些是規劃過但還沒實際用上的工具。

## 為什麼放這裡

避免 cargo culting — 主目錄（`prompts/`、`tools/`、`workflows/`、`assets/`）只放真正用過的東西。
規劃過但沒實戰驗證的範本先放這裡，需要時再啟用。

詳見 `decisions/2026-04-28-expand-dotfiles.md`。

## 啟用方式

```bash
# 範例：啟用 stage-2-research.md
mv _drafts/prompts/stage-2-research.md prompts/

# 啟用後 commit
git add . && git commit -m "feat: 啟用 stage-2-research prompt 範本"
```

啟用後記得：
1. 在主目錄對應的 `README.md`（例如 `prompts/README.md`）的「啟用狀態」段落加上這個檔案
2. 跟原本實戰需要對應 — 如果是為了某個任務啟用，附上情境說明

## 淘汰方式

```bash
# 確定永遠用不到
git rm _drafts/prompts/stage-2-research.md
git commit -m "remove: 淘汰 stage-2-research（用不到）"
```

git 歷史會保留內容，未來真的需要可從歷史撈回。

## 目前內容（24 個檔案）

### prompts/（5）

| 檔案 | 用途 |
|---|---|
| `prompts/stage-2-research.md` | 研究綜整（NotebookLM、Deep Research） |
| `prompts/stage-4-architecture.md` | 架構設計（Claude Project + Artifacts） |
| `prompts/stage-5-implementer.md` | 實作（Cursor 或 fallback prompt） |
| `prompts/stage-6-reviewer.md` | Code Review（五層次檢查） |
| `prompts/stage-7-deployer.md` | 部署（Beta 自動 / Production 手動） |

### tools/（11）

| 檔案 | 用途 |
|---|---|
| `tools/claude/projects/system-architect.md` | Claude Project 設定：架構師 |
| `tools/claude/projects/code-reviewer.md` | Claude Project 設定：Code Reviewer |
| `tools/chatgpt/custom-gpts/product-thinker.md` | Custom GPT 設定：產品思考夥伴 |
| `tools/chatgpt/custom-gpts/tech-evaluator.md` | Custom GPT 設定：技術選型評估 |
| `tools/gemini/README.md` | Gemini NotebookLM 與 Deep Research 使用指南 |
| `tools/cursor/agents/orchestrator.md` | Cursor subagent：流程總指揮 |
| `tools/cursor/agents/implementer.md` | Cursor subagent：實作者 |
| `tools/cursor/agents/tester.md` | Cursor subagent：測試者 |
| `tools/cursor/agents/reviewer.md` | Cursor subagent：Reviewer |
| `tools/cursor/commands/feature.md` | Cursor 指令：`/feature` |
| `tools/cursor/commands/review.md` | Cursor 指令：`/review` |

### workflows/（3）

| 檔案 | 觸發情境 |
|---|---|
| `workflows/bug-fix.md` | Bug report（自己發現、客戶回報、告警） |
| `workflows/refactor.md` | 代碼能動但難改，想重整結構 |
| `workflows/tech-evaluation.md` | 考慮採用新技術（框架、套件、服務） |

### assets/（5）

| 檔案 | 用途 |
|---|---|
| `assets/handoff-templates/problem-statement.md` | Stage 1 產出範本 |
| `assets/handoff-templates/tech-spec.md` | Stage 3 產出範本 |
| `assets/handoff-templates/architecture-doc.md` | Stage 4 產出範本 |
| `assets/checklists/pre-implementation.md` | 實作前檢查清單 |
| `assets/checklists/pre-deploy.md` | 部署前檢查清單 |

## 維護原則

- 啟用 = 真的用過至少一次。沒用過的不啟用
- 兩個月後仍 90% 沒啟用 → 觸發 ADR 重新檢視（見 `decisions/2026-04-28-expand-dotfiles.md`）
- 啟用後內容會迭代，不要回頭改 `_drafts/` 裡的舊版（git 歷史就夠了）
