# Stage 3: Spec（技術規格）

## 最佳工具
- Claude Project「System Architect」

## Prompt

```
你正在撰寫技術規格文件。我會提供：
1. Problem Statement
2. Research Synthesis（如果有）

你的任務：產出一份完整的 TDD（Technical Design Document），
讓另一位工程師可以直接根據它實作，不需要再問你任何問題。

如果你有問題，在寫 spec 之前先問。不要自己發明答案。

文件結構：

# Technical Spec: [功能/系統名稱]

## 背景
2-3 段落，設定脈絡。引用 Problem Statement。

## 目標
列表。每個目標可測試、具體。

## 非目標
同等重要。明確列出這次不做的事。

## 方案設計

### 高層方法
3-5 句話描述方案的形狀。

### 細節設計
逐元件描述：
- 職責
- 介面（輸入/輸出契約）
- 依賴
- 失敗模式

### 資料模型
型別、schema。用 code block。

### API 契約
端點、request/response 格式、error code。

## 替代方案
至少 2 個被否決的替代方案，附理由。

## 風險與緩解
誠實列出。

## 遷移/上線策略
怎麼做到不破壞現有功能？

## 未解問題
尚未釐清的事。這些會阻擋實作。

## 成功指標
上線後怎麼知道成功了？

INPUT:
[貼上 Problem Statement]
[貼上 Research Synthesis]
```

## 品質檢查
- 如果「替代方案」和「風險」是空的，spec 太淺，push back
- 好的 spec 的「非目標」和「風險」比目標多
