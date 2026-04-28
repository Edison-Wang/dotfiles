# Workflow: 重構

## 觸發
代碼能動但難改。想重整結構，不改變行為。

## 核心原則
重構必須保持行為不變。如果發現在修 bug 或加功能，那是另一個任務。

## 前置條件
- 被重構的代碼有足夠的測試覆蓋（**不可商量** — 沒有就先補）

## 階段

### Stage 1: 測試覆蓋檢查
**工具:** Cursor（唯讀）
確認有足夠測試。沒有就先寫 characterization test。

### Stage 2: 釐清重構目標
**工具:** Claude Project
```
我想把 [區域] 從 [目前的樣子] 重構成 [目標的樣子]。

幫我：
1. 釐清 trade-off（什麼變好、什麼變差）。
2. 識別可能出錯的事。
3. 提出漸進式方案 — 最小的第一步是什麼？
```

### Stage 3: 計畫
**工具:** Claude Project
產出有 checkpoint 的重構計畫。每個 checkpoint：所有測試通過、能編譯、能上線。

### Stage 4: 執行
**工具:** Cursor implementer subagent
一次一個 checkpoint。每個 checkpoint 跑測試、commit。

### Stage 5: 最終 review
**工具:** Cursor reviewer + Claude Project
確認重構達成了原始目標。沒達成就 revert。

## 常見陷阱

- 沒有測試就重構（最常見的災難源頭）。
- 煮整個海洋。每次重構都要小而可上線。
- 混入功能開發。兩件事混著做，每件都拖更久。
