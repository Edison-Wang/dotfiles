# Workflow State

> 這個檔案是 Cursor 自主開發迴圈的「動態大腦」。
> AI 會在每個階段轉換時讀寫此檔，請勿手動編輯狀態區塊（除非要重設或中斷流程）。
>
> 規則由 `~/.cursor/rules/workflow-autonomous-loop.mdc` 提供。
> 觸發方式：在對話中 `@ai/workflow-state.md` 引用此檔。

---

## State

```yaml
Phase: ANALYZE          # ANALYZE | BLUEPRINT | CONSTRUCT | VALIDATE | DELIVER | BLOCKED
Status: IN_PROGRESS     # IN_PROGRESS | NEEDS_PLAN_APPROVAL | NEEDS_HUMAN_REVIEW | BLOCKED | ABORTED
CurrentTask: <unset>    # AI 偵測到 <unset> 會主動詢問並自動寫入
ValidateAttempts: 0     # VALIDATE 失敗計數，達 3 強制 BLOCKED
StartedAt: <unset>      # AI 在收到任務時自動填入時間戳
```

## Plan

> BLUEPRINT 階段由 AI 生成 checklist，每項標記依賴關係。
> CONSTRUCT 階段每完成一項打勾並追加證據（檔案 + 行數）。

- [ ] 待 BLUEPRINT 階段填入

## Log

> 階段轉換時 append 一行：`[YYYY-MM-DD HH:MM] PHASE → PHASE | 摘要`
> CONSTRUCT 中發現 plan 有問題退回 BLUEPRINT 時，必須在此標記原因。

- `[YYYY-MM-DD HH:MM]` INIT → ANALYZE | 工作流啟動

---

## 使用慣例

- **新任務開始**：把這個檔案重置為初始狀態（Phase=ANALYZE、Status=IN_PROGRESS、CurrentTask 改寫、ValidateAttempts=0、Plan 清空、Log 保留歷史或開新檔）
- **強制停下點**：Status 為 `NEEDS_PLAN_APPROVAL`、`NEEDS_HUMAN_REVIEW`、`BLOCKED` 時 AI 必須停下等用戶
- **退回機制**：CONSTRUCT 中如發現 BLUEPRINT 有錯，AI 應將 Phase 設回 BLUEPRINT 並在 Log 標記原因，不可擅自改 Plan 繼續
- **中斷**：用戶可隨時把 Status 改為 `ABORTED` 中止流程
