# Workflow: 新功能開發

## 觸發
有新功能要做，從模糊想法到上線。

## 階段

### Stage 1: Ideation（15-30 分鐘）
**工具:** ChatGPT Custom GPT「Product Thinker」
**Prompt:** `prompts/stage-1-ideation.md`
**產出:** Problem Statement（存為 Markdown）

### Stage 2: Research（15-60 分鐘，可選）
**跳過條件:** 技術和問題都是你熟悉的領域
**工具:** NotebookLM 或 Deep Research
**Prompt:** `_drafts/prompts/stage-2-research.md`（尚未啟用）
**產出:** Research Synthesis（存為 Markdown）

### Stage 3: Spec（30-60 分鐘）
**工具:** Claude Project「System Architect」
**Prompt:** `prompts/stage-3-spec.md`
**輸入:** Problem Statement + Research Synthesis
**產出:** spec 文件（路徑由你決定，例如 `docs/specs/<feature-name>.md`）

### Stage 4: Architecture（30-90 分鐘）
**工具:** Claude Project「System Architect」（搭配 Artifacts）
**交叉檢查（可選）:** GPT-5.5 Pro + Gemini 3.1 Pro
**Prompt:** `_drafts/prompts/stage-4-architecture.md`（尚未啟用）
**產出:** architecture 文件

### Stage 5: Implementation（依規模）
**工具:** Cursor（搭配 subagents）
**Prompt:** `_drafts/prompts/stage-5-implementer.md`（尚未啟用）
**產出:** 實際代碼，逐模組 commit

### Stage 6: Review（30-60 分鐘）
**工具:** Cursor reviewer subagent + Claude Project「Code Reviewer」
**Prompt:** `_drafts/prompts/stage-6-reviewer.md`（尚未啟用）
**產出:** Review 紀錄，修復後合併

### Stage 7: Deployment
**工具:** Cursor deployer + 手動確認
**Prompt:** `_drafts/prompts/stage-7-deployer.md`（尚未啟用）
**產出:** 部署完成

## 常見陷阱

- **跳過 Stage 1**: 做出來才發現搞錯問題。永遠花 15 分鐘在這。
- **跳過 Stage 4**: 實作過程中架構漂移。即使一頁的架構文件也有幫助。
- **讓 implementer 一口氣做完所有模組**: 偏差會累積。每個模組都要 checkpoint。
- **只在最後才 review**: 晚期 review = 昂貴的重工。盡可能逐模組 review。

## 備註

當你需要某個 stage 的 prompt 但發現它在 `_drafts/`，啟用方式：

```bash
mv _drafts/prompts/stage-4-architecture.md prompts/
```
