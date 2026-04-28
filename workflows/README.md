# workflows/

跨工具的端到端工作流程。每個 workflow 描述一個完整的任務類型，
從開始到結束要經過哪些 AI 工具、用什麼 prompt、產出什麼 artifact。

## 使用方式

1. 判斷你的任務屬於哪個 workflow
2. 打開對應的 .md 檔案
3. 按階段執行，每個階段會告訴你用什麼工具
4. 實戰中發現流程有問題，回來更新 workflow

## 啟用狀態

目前啟用的 workflow：

- `new-feature.md` — 新功能開發（從發想到部署）
- `cross-model-review.md` — 三模型交叉檢查（重大決策用）

未啟用的 workflow（在 `_drafts/workflows/`）：bug-fix、refactor、tech-evaluation。
