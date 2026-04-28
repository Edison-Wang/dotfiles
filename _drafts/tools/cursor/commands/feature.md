# /feature [描述]

啟動完整的新功能 pipeline。

## 步驟

1. 委派 @orchestrator 處理描述的功能需求
2. orchestrator 會依序：Read → Plan → Implement → Test → Review
3. 每個階段之間等用戶確認

## 範例

```
/feature 在 SwapModule 加入確認頁，顯示交易摘要和預估手續費
```

## 備註

- 如果已有 spec/architecture 文件，請告訴 orchestrator 路徑
- 如果沒有，orchestrator 會先產出 implementation plan 再等確認
