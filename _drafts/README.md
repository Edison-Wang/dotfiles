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

# 同步「目前內容」清單
bash scripts/list-drafts.sh

# commit
git add . && git commit -m "feat: 啟用 stage-2-research prompt 範本"
```

啟用後記得：
1. 在主目錄對應的 `README.md`（例如 `prompts/README.md`）的「啟用狀態」段落加上這個檔案
2. 跟原本實戰需要對應 — 如果是為了某個任務啟用，附上情境說明

## 淘汰方式

```bash
# 確定永遠用不到
git rm _drafts/prompts/stage-2-research.md

# 同步「目前內容」清單
bash scripts/list-drafts.sh

git commit -m "remove: 淘汰 stage-2-research（用不到）"
```

git 歷史會保留內容，未來真的需要可從歷史撈回。

## 維護原則

- 啟用 = 真的用過至少一次。沒用過的不啟用
- 兩個月後仍 90% 沒啟用 → 觸發 ADR 重新檢視（見 `decisions/2026-04-28-expand-dotfiles.md`）
- 啟用後內容會迭代，不要回頭改 `_drafts/` 裡的舊版（git 歷史就夠了）
- 「目前內容」清單由 `scripts/list-drafts.sh` 自動生成，不要手寫

## 目前內容
（最後更新：2026-04-28，由 scripts/list-drafts.sh 生成）

### prompts/（5）
- `stage-2-research.md` — Stage 2: Research（研究綜整）
- `stage-4-architecture.md` — Stage 4: Architecture（架構設計）
- `stage-5-implementer.md` — Stage 5: Implementer（實作）
- `stage-6-reviewer.md` — Stage 6: Reviewer（Code Review）
- `stage-7-deployer.md` — Stage 7: Deployer（部署）

### tools/（11）
- `chatgpt/custom-gpts/product-thinker.md` — Custom GPT: Product Thinker
- `chatgpt/custom-gpts/tech-evaluator.md` — Custom GPT: Tech Evaluator
- `claude/projects/code-reviewer.md` — Claude Project: Code Reviewer
- `claude/projects/system-architect.md` — Claude Project: System Architect
- `cursor/agents/implementer.md` — 根據 spec 和架構文件實作代碼。架構確認後使用。嚴格遵守 spec，不發明功能。
- `cursor/agents/orchestrator.md` — 協調多階段開發任務。當用戶帶著 spec 或架構文件來實作時使用。委派 implementer、tester、reviewer 子代理。
- `cursor/agents/reviewer.md` — 代碼品質最終檢查。測試通過後使用。唯讀 — 浮出問題，不修。
- `cursor/agents/tester.md` — 為新代碼寫測試並執行測試套件。implementer 完成後使用。
- `cursor/commands/feature.md` — /feature [描述]
- `cursor/commands/review.md` — /review
- `gemini/README.md` — Gemini 工具配置

### workflows/（4）
- `bug-fix.md` — Workflow: Bug 修復
- `producer-reviewer-loop.md` — Workflow: Producer-Reviewer Loop
- `refactor.md` — Workflow: 重構
- `tech-evaluation.md` — Workflow: 技術選型評估

### assets/（5）
- `checklists/pre-deploy.md` — 部署前 Checklist
- `checklists/pre-implementation.md` — 實作前 Checklist
- `handoff-templates/architecture-doc.md` — Architecture: [系統名稱]
- `handoff-templates/problem-statement.md` — Problem Statement: [一句話名稱]
- `handoff-templates/tech-spec.md` — Technical Spec: [功能/系統名稱]
