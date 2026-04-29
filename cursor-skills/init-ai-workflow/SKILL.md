---
name: init-ai-workflow
description: Bootstrap the ai/ workspace and hand off to the autonomous five-phase development loop. Use when the user wants to set up AI-assisted development, says "啟動工作流 / 開始開發 / 建立 ai workspace / 用自主迴圈做這個", or when they describe a new development task without an existing ai/workflow-state.md.
---

# Initialize AI Workflow

Bootstrap step that prepares `ai/workflow-state.md` and hands off control to `workflow-autonomous-loop.mdc`. This skill **only handles bootstrap** — once `ai/workflow-state.md` exists in context, the autonomous loop rule takes over.

## When to apply

- User wants to start a development task with the autonomous loop
- User mentions wanting AI to manage the dev process
- Project does not yet have `ai/workflow-state.md`
- User says: 「啟動工作流」「開始開發 X」「建立 ai workspace」「用自主迴圈做」

## When NOT to apply

- Project already has `ai/workflow-state.md` and the user wants to continue → skip this skill, just `@ai/workflow-state.md` to invoke the rule directly
- User wants codebase analysis without development → use `codebase-onboarding` skill
- One-off bug fix or trivial change → just do it, don't over-process

## Scope boundary (important)

This skill is responsible for **bootstrap only**:

| Concern | Handled by |
|---|---|
| Create `ai/` directory and `workflow-state.md` | `scripts/init-ai-workspace.sh` |
| Detect `CurrentTask=<unset>` and ask user | `cursor-rules/workflow-autonomous-loop.mdc` (INIT step) |
| State machine, BLUEPRINT/CONSTRUCT/VALIDATE/DELIVER | `cursor-rules/workflow-autonomous-loop.mdc` |
| **Bootstrap and handoff** | **THIS SKILL** |

**Do not duplicate the rule's INIT logic here.** Just run the script and load the file into context — the rule activates automatically via globs.

## Workflow checklist

```
Bootstrap Progress:
- [ ] Step 1: 偵測 ai/workflow-state.md 是否已存在
- [ ] Step 2: 不存在 → 跑 init-ai-workspace.sh
- [ ] Step 3: 已存在 → 確認用戶要新任務還是繼續舊任務
- [ ] Step 4: 載入 workflow-state.md 進入 context（觸發 rule）
- [ ] Step 5: 把控制權交給 rule，本 skill 結束
```

### Step 1: 偵測現況

Run from the project root:

```bash
ls ai/workflow-state.md 2>/dev/null && echo "EXISTS" || echo "NEEDS_INIT"
```

Branch:
- `NEEDS_INIT` → Step 2
- `EXISTS` → Step 3

### Step 2: 跑 init script

```bash
bash ~/dotfiles/scripts/init-ai-workspace.sh
```

Expected output:
- `ai/workflow-state.md` created
- `.git/info/exclude` updated (if git repo)

If script fails:
- Not a git repo + no README → suggest user run `git init` or create README first
- Wrong directory (e.g., `$HOME`, `/`, `~/dotfiles`) → script will reject with reason; redirect user to the actual project root

### Step 3: 處理已存在的情況

If `ai/workflow-state.md` already exists, ask the user:

> 偵測到 `ai/workflow-state.md` 已存在（CurrentTask: `<read from file>`）。
> 是要：
> 1. 繼續這個任務
> 2. 開新任務（會重置 State / Plan，Log 保留歷史）

If user picks (2), reset the relevant fields:
- `Phase: ANALYZE`
- `Status: IN_PROGRESS`
- `CurrentTask: <unset>`
- `ValidateAttempts: 0`
- `StartedAt: <unset>`
- `Plan: - [ ] 待 BLUEPRINT 階段填入`
- Log: keep history, append `[time] RESET | 開新任務`

### Step 4: 觸發 rule

Read `ai/workflow-state.md` so it enters conversation context. The `workflow-autonomous-loop.mdc` rule will activate via globs.

Confirm to the user:

```
✅ Bootstrap 完成
- ai/workflow-state.md：<新建 / 已存在 / 已重置>
- 接下來由 workflow-autonomous-loop 規則接手
```

### Step 5: 交棒

After Step 4, **stop**. Do not start ANALYZE or ask for CurrentTask yourself — the rule's INIT step will handle that.

The next message should come from the rule (asking for CurrentTask if `<unset>`, or starting ANALYZE if already set).

## Quality gates

- ❌ 直接寫 CurrentTask 到 `workflow-state.md` 而沒讓 rule 的 INIT 步驟接手 → 違反分工邊界
- ❌ 進入 ANALYZE 自己跑分析 → 那是 rule 的職責
- ❌ 自動 commit init 後的 ai/ 目錄 → ai/ 預設不進版控
- ✅ Step 4 之後停下，rule 接手詢問 CurrentTask

## Reference

- Script: [~/dotfiles/scripts/init-ai-workspace.sh](~/dotfiles/scripts/init-ai-workspace.sh)
- Rule: [~/dotfiles/cursor-rules/workflow-autonomous-loop.mdc](~/dotfiles/cursor-rules/workflow-autonomous-loop.mdc)
- Template: [~/dotfiles/templates/ai-workspace/workflow-state.md](~/dotfiles/templates/ai-workspace/workflow-state.md)
