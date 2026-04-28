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
