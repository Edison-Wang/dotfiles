# Workflow: Bug 修復

## 觸發
Bug report（自己發現、客戶回報、或告警）。

## 階段

### Stage 1: 重現
工具：你的本地環境
- 確認能重現。不能重現就先收集更多資訊，不要叫 AI 幫你。

### Stage 2: 假設
**工具:** ChatGPT Thinking 或 Claude
**Prompt:** 提供重現步驟 + 相關代碼 + log。問：
```
列出最可能的 5 個假設，按可能性排序。
每個假設附上成本最低的驗證實驗。
```

### Stage 3: 調查
**工具:** Cursor（唯讀模式調查）
- 搜索相關邏輯。
- 跑實驗確認/排除假設。

### Stage 4: 修復
**工具:** Cursor implementer subagent
- Root cause 確認後實作修復。
- 加一個 regression test（如果這個 bug 存在，此測試會失敗）。

### Stage 5: Review
**工具:** Cursor reviewer subagent
- 確認修復精準（無 scope creep）。
- 確認 regression test 在未修復的代碼上確實會失敗。

## 常見陷阱

- 只修症狀，不修根因。
- 跳過 regression test（bug 會回來的）。
- Agent 趁機擴大 scope（「既然我在這了，順便也...」）。
