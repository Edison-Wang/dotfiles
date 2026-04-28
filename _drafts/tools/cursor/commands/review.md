# /review

對當前 uncommitted 改動執行 code review。

## 步驟

1. 委派 @reviewer 檢查 `git diff` 的所有改動
2. 產出 Blocker / Major / Minor 分類的 review report

## 備註

- 如果有對應的 spec 文件，一併提供可以得到更好的 review
- reviewer 是唯讀的，只會指出問題不會修改
