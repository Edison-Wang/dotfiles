# Gemini 工具配置

## NotebookLM

最適合的場景：
- 大量技術文件的 grounded Q&A（上傳 PDF、RFC、vendor docs）
- 建立持久的知識庫
- 需要引用來源的研究

### 建議建立的 Notebook

1. **Architecture Patterns Reference** — 上傳架構相關書籍/文章
2. **Language Reference**（每個常用語言一個）— 上傳官方 spec、style guide
3. **Codebase Knowledge**（每個主要專案一個）— 上傳源碼、設計文件、ADR

### 使用技巧

- 來源品質 > 數量。5 份好來源勝過 50 份普通來源。
- 快速變化的技術（框架、套件），每幾個月更新一次 notebook。
- 用 Audio Overview 在通勤時聽摘要。

## Deep Research

最適合的場景：
- 需要綜合大量網路來源
- 需要有引用、可驗證的主張
- 時效性話題（最新發展、新發布）

### Prompt 模板

見 `_drafts/prompts/stage-2-research.md` 的 Prompt B。

### 使用技巧

- 每次 Deep Research 需要 5-15 分鐘，不是即時的。
- 越具體的 prompt，結果越好。
- 跑完後可在同一對話追問，深入特定發現。
