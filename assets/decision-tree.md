# 工具決策樹

快速判斷用哪個工具。

```
你現在在做什麼？

├── 在 codebase 裡改代碼
│   └── → Cursor
│
├── 思考問題（還沒到寫代碼）
│   ├── 模糊想法，需要釐清
│   │   └── → ChatGPT（Custom GPT「Product Thinker」）
│   │
│   ├── 具體技術問題
│   │   └── → Claude 或 ChatGPT Thinking
│   │
│   └── 高風險、不可逆決策
│       └── → 三模型交叉檢查（workflows/cross-model-review.md）
│
├── 研究 / 整理資訊
│   ├── 手上有大量文件（PDF、RFC、論文）
│   │   └── → NotebookLM（Gemini）
│   │
│   ├── 需要即時網路研究
│   │   └── → Gemini Deep Research 或 ChatGPT Deep Research
│   │
│   └── 快速查證
│       └── → 三家任一，開搜尋
│
├── 寫長文件（spec、RFC、blog、ADR）
│   └── → Claude（Project）
│
├── 設計系統架構
│   ├── 初版架構
│   │   └── → Claude Project「System Architect」+ Artifacts
│   │
│   └── 驗證關鍵設計
│       └── → 三模型交叉檢查
│
└── Review 代碼
    ├── 逐行 diff review
    │   └── → Cursor reviewer subagent
    │
    └── 架構層面 review
        └── → Claude Project「Code Reviewer」
```

## 經驗法則

- **預設**: Cursor 寫代碼，Claude 想事情。
- **卡住時**: 換一個模型問同樣的問題，有時候不同的訓練資料能突破。
- **要學新東西時**: 有文件用 NotebookLM，沒文件用 Deep Research。
- **錯不起時**: 三模型交叉檢查。否則挑一個就好。

## 避免

- 同一件事在四個工具間輪轉（浪費時間，不是更好的答案）。
- 用 Cursor 做非代碼的工作（它是最貴的 token）。
- 用 ChatGPT / Gemini 做 codebase-aware 的工作卻不上傳檔案（它們看不到你的檔案系統）。
