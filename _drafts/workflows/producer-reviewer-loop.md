# Workflow: Producer-Reviewer Loop

## 觸發
要產出**單一高品質產物**（plan、spec、ADR、refactor design、複雜代碼變更），且**錯了代價大**。

## 跟 cross-model-review 的差別

| 維度 | cross-model-review | producer-reviewer-loop（本 workflow）|
|---|---|---|
| 適用 | 高風險**決策**（選 A 還是 B）| 高風險**產出物**（這份 plan 對嗎）|
| 模式 | 平行 — 三家獨立答 → 人類綜整 | 串行迭代 — A 產 → B 挑 → A 修 → B 確認 |
| 終止 | 人類綜整完即結束 | reviewer 不再有 blocker 即結束 |
| 輸出 | 帶 risk 的決策 | 經 review 過的單一產物 |

## 角色分工

### Producer
- **強項**：架構思維、長程邏輯、創意、整合
- **盲點**：對自己的產出過度樂觀（false completion 傾向）
- **建議模型**：Claude（Opus 4.7 或當下旗艦）

### Reviewer
- **必須跟 Producer 不同家族**（避免 self-review 盲點）
- **強項**：嚴謹、找盲點、捕捉隱含依賴
- **建議模型**：GPT-5.5 Thinking、Gemini 3.1 Pro 之類
- **不要用同一家族的不同 size**（例如 Opus + Sonnet），盲點會雷同

## 流程

### Stage 1: Producer 產出
給 Producer 任務 + 上下文 + 成功標準。要求結構化輸出（Markdown）。

### Stage 2: Reviewer 挑刺（第一輪）
把 Producer 產出**完整丟給 Reviewer**，附下方的 review prompt。

```
你正在審核一份 [類型：implementation plan / spec / refactor design / ...]。
請扮演資深架構師，嚴格找出問題：

1. 隱含依賴 / 假設（沒講清楚但會影響結果的）
2. 邊界情況 / 失敗模式（happy path 之外的）
3. 替代方案（為什麼不選別的，有論述嗎）
4. 系統崩潰風險（會在 production 炸的）
5. 偏離既定 spec / 規範的地方

不要客氣。用 Blocker / Major / Minor 分類。
每個問題附上「為什麼是問題」+「建議修法」。

如果你覺得整體沒問題，明確說「No blockers found, proceed」 — 但要先檢查確實沒漏。

INPUT:
[貼上 Producer 產出]
[貼上 spec / 規範文件]
```

### Stage 3: Producer 修訂
把 Reviewer 的 finding 丟回 Producer，要求逐項回應：
- 接受 → 修
- 不接受 → 說理由
- 需要更多資訊 → 列出問題

### Stage 4: Reviewer 確認（第二輪）
把修訂後的版本 + Reviewer 第一輪的 finding 一起丟給 Reviewer：

```
這是 Producer 對你第一輪 review 的修訂版本。
請逐項確認：
- Blocker 是否都已處理？
- 修訂過程有沒有引入新問題？
- 還有沒有第一輪沒看出的問題？

如果 OK，明確說「Approved, ready for human review」。
```

### Stage 5: 人類拍板
看雙方的對話 + 最終產出。如果你看不出問題就執行；看出問題自己決定要不要再一輪。

## 預設參數

- **預設兩輪迭代**（Gary Chen 經驗法則，邊際效益最高）
- **超過三輪**：產出物或 prompt 設計有問題，停下來重新校準
- **Reviewer 一致 No blockers found**：可能 reviewer 太鬆，下次換更嚴格的 prompt

## 驗收：埋陷阱測試

定期驗證這個 workflow **真的有效**，不是 rubber-stamp。

做法：在 Producer 的 input 裡**故意埋一個小錯誤**：
- 過時的 API 名稱
- 邏輯矛盾（例如「先驗證 token 再解析 token」）
- 違反既定規範的決策（例如 spec 說不要用 X，plan 用了 X）
- 數字錯誤（例如預算是 100k，計畫寫 1M）

**Reviewer 應該抓到。**沒抓到 → 換 reviewer model 或加強 review prompt。

頻率：每月一次，或每次換 Producer/Reviewer 組合時。

## 不適用的場景

- **可逆的決定** → 直接挑一個試
- **日常 coding** → 一個工具就夠（不要每次寫個 utility 都跑 loop）
- **時間極趕** → 一輪也比沒有強
- **產出物本身不重要** → 不值得這個工夫

## 與既有 workflow 的關係

- **`new-feature.md` 的 Stage 3 (Spec) 和 Stage 4 (Architecture)**：可以用本 workflow 強化
- **`refactor.md`（draft）的 Stage 3 (計畫)**：refactor plan 是高風險產出物，適用本 workflow
- **`tech-evaluation.md`（draft）的 Stage 4**：當 Stage 4 的「三模型交叉檢查」改用串行迭代時，就是用本 workflow

## 何時啟用

放 `_drafts/` 是因為這個 pattern 比較重型，**不是每次都要跑**。等下次碰到一個高風險的 spec / plan 時再啟用。

啟用後第一次跑：建議刻意做一次「埋陷阱」驗收，建立對自己 reviewer 配置的信心。
