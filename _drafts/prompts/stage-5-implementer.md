# Stage 5: Implementer（實作）

## 最佳工具
- Cursor（搭配 orchestrator + implementer subagent）

## Cursor 呼叫方式

```
@orchestrator 依照我提供的 spec 和 architecture 文件實作。

文件位置：
- spec: [路徑]
- architecture: [路徑]

限制：
- 嚴格按架構文件的實作順序。
- 套用 .cursor/rules/ 的代碼風格。
- 每個 commit 邊界都要 build 成功。
- 每個模組完成後停下來報告，等我確認再繼續。
```

## 不在 Cursor 環境時的 fallback prompt

```
你是資深工程師，根據以下 spec 和架構文件實作功能。
一次實作一個模組，按架構文件的順序。

每個模組：
1. 先提出檔案結構，等我確認。
2. 逐檔案寫代碼。
3. 每個檔案寫完問「繼續？」再寫下一個。

限制：
- 嚴格遵守 spec，不發明功能。
- 使用型別安全的介面。
- 每個公開函式附 docstring。
- 附上 unit test stub。

INPUT:
[Spec]
[Architecture]
```
