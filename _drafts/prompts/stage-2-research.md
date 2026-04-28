# Stage 2: Research（研究綜整）

## 最佳工具
- NotebookLM（有大量文件要消化時）
- Gemini Deep Research 或 ChatGPT Deep Research（需要網路研究時）

## Prompt A: NotebookLM（文件綜整）

```
我上傳了一組關於 [主題] 的文件。我的具體問題是：

[貼上你的問題，源自 Problem Statement 的 Open Questions]

請：
1. 識別與我的問題相關的關鍵主張。
2. 識別來源之間的矛盾點。
3. 識別缺口 — 這些來源沒覆蓋但相關的面向。
4. 產出綜整：

# 研究綜整: [主題]

## 高信心結論
重點列表，每條附來源引用。

## 有爭議的部分
來源之間不一致的地方，簡述雙方觀點。

## 未覆蓋的部分
來源沒涵蓋但我們仍需研究的缺口。

## 對問題定義的影響
這些研究結果如何改變或限制了我的 Problem Statement？
```

## Prompt B: Deep Research（網路研究）

```
針對以下問題進行研究調查：

PROBLEM STATEMENT:
[貼上 Stage 1 產出]

具體研究問題:
[一個聚焦的問題]

限制:
- 優先一手來源（官方文件、peer-reviewed、官方規格）
- 跳過超過 18 個月的部落格文章（除非是開創性的）
- 標記贊助內容或變相行銷
- 指出來源的利益衝突

產出:
上述格式的研究報告。最多 1500 字。開頭附一段 TL;DR。
```

## Pro tip
跑完 Gemini Deep Research 和 ChatGPT Deep Research 各一次，
再把兩份報告都上傳到 NotebookLM，請它做 meta-synthesis。

## Variant: Gemini 抓取 + Claude 整合（pipeline 模式）

當任務是「**整合大量已知來源**」（不是探索性研究）時，用模型強項分工而非 cross-check：

### 何時用這個 variant

- 文獻綜述（已知有 N 篇論文要整理）
- 競品分析（已知要看哪幾家）
- 技術調研報告（範圍清楚的綜合報告）
- 多份規格文件對齊（API 文件、RFC 等）

不適用：探索性研究（你還不知道要看什麼來源）— 那種還是用主流程的 cross-check。

### Stage 1: Gemini Deep Research 抓取

**強項**：網頁搜尋廣度、即時內容、來源引用嚴謹。

```
針對 [主題] 抓取以下來源並做初步摘要：
[列出 URL / 範圍，例如：「ACM 上 2024-2026 關於 X 的論文」]

每個來源產出：
- 標題、作者、年份
- TL;DR（3 句以內）
- 核心主張（重點列表）
- 我提的具體問題在這份來源裡的答案（如果有）
- 跟其他來源的主張差異（如果你已經看過其他來源）

輸出為結構化 Markdown，每個來源一個 H2 段落。
```

存產出為 `research-raw-<主題>.md`。

### Stage 2: Claude Project 結構化整合

**強項**：長文本 coherence、跨段落抽象、結構化輸出。

把 Stage 1 產出 + Problem Statement 一起餵給 Claude Project「System Architect」（或新開一個專門 Project）：

```
我提供：
1. Problem Statement
2. Stage 1 產出（多份來源的初步摘要）

請整合成一份高密度的結構化文獻綜述：

# 文獻綜述: [主題]

## TL;DR
3-5 句話結論。

## 共識
所有來源都同意的點。每條附來源引用。

## 分歧
來源之間意見不一致的地方。
- 雙方論點各自摘要
- 你判斷哪邊較強，理由
- 哪些是真正的開放問題（無法判斷）

## 缺口
這組來源沒覆蓋但相關的面向。建議下一輪研究方向。

## 對 Problem Statement 的影響
這些研究結果如何改變或限制了原本的問題定義？
```

存產出為 `research-synthesis-<主題>.md`。

### 為什麼分兩步

- **Gemini 抓得寬、引用準**，但長文 coherence 不如 Claude
- **Claude 整合好、抽象能力強**，但即時搜尋和引用不如 Gemini
- 兩者互補，不是互相驗證 — 跟主流程的 cross-check **目的不同**

### 跟主流程的選擇規則

| 情境 | 用主流程 | 用 pipeline variant |
|---|---|---|
| 不知道要看什麼來源 | ✅ | ❌ |
| 已知來源範圍 | 也可以 | ✅ |
| 怕單一模型偏見 | ✅ | ❌ |
| 要結構化長文輸出 | 也可以 | ✅ |
| 時間極趕 | ✅（單模型快）| ❌（兩階段慢）|
