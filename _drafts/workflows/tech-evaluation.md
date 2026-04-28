# Workflow: 技術選型評估

## 觸發
考慮採用新技術（框架、套件、服務、架構）。

## 階段

### Stage 1: 釐清問題
**工具:** ChatGPT Custom GPT「Tech Evaluator」
從「該不該用 X」到精確的評估維度清單。

### Stage 2: 獨立研究
**工具:** Gemini Deep Research 或 ChatGPT Deep Research
每個候選方案各跑一次。存報告。

### Stage 3: 綜整
**工具:** NotebookLM
上傳所有 Stage 2 的報告，請它產出比較矩陣和 trade-off 綜整。

### Stage 4: 三模型交叉檢查
**工具:** Claude + ChatGPT + Gemini（獨立跑）
同一份綜整問三家，不要讓一家看到另一家的答案。
比較共識和分歧。

### Stage 5: 低成本驗證
**工具:** Cursor（做 POC）
最小可行的 proof of concept。上限 1-2 天。

### Stage 6: 決策
**產出:** ADR 存在 `decisions/`

## 常見陷阱

- 只評估新選項，不評估現狀。現狀永遠是一個選項。
- 跳過 POC。紙上談兵遺漏真實的 failure mode。
- 尋求確認而非反駁。問「什麼會讓我改主意」比「什麼支持我的想法」有用。
