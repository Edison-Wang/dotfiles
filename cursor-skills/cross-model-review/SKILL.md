---
name: cross-model-review
description: Guide a three-model independent review for high-stakes decisions, SAVING the decision brief and final ADR to disk. Use when the user faces a major decision (DB choice, API contract, deployment architecture, framework selection), mentions "重大決策 / 重要選型 / 三模型 / cross-model / 不可逆", or when wrong choice would be expensive to revert.
---

# Cross-Model Review

For high-stakes decisions where being wrong is expensive, run the same brief through three frontier AI models independently, then save the decision as an ADR.

## When to apply

- Decision is **low-reversibility** (changing later costs significant time/money)
- Examples: DB selection, API contract design, deployment architecture, security model, framework migration
- User explicitly asks for "三模型" / "cross-model" review
- Stakes are clearly business-critical

## When NOT to apply

- Reversible decisions → just pick one and try
- User has enough information already → no need for parallel views
- Daily coding decisions → one tool is enough
- Time-critical → skip parallel, go single best model

## Workflow checklist

This is a **human-in-the-loop** workflow. Cursor agent guides; user runs each model separately.

```
Cross-Model Review Progress:
- [ ] Step 1: 確認 decision slug + 存檔目錄（MANDATORY ASK）
- [ ] Step 2: 與用戶協作寫 decision brief
- [ ] Step 3: SAVE BRIEF TO FILE (MANDATORY)
- [ ] Step 4: 引導用戶把 brief 帶到 Claude / GPT / Gemini 各跑一次
- [ ] Step 5: 收集 3 份回應（用戶貼回對話）
- [ ] Step 6: 並排比較找共識 / 分歧
- [ ] Step 7: 與用戶協作寫最終 decision document
- [ ] Step 8: SAVE FINAL DECISION AS ADR (MANDATORY)
- [ ] Step 9: 確認兩個檔案路徑回報給用戶
```

### Step 1: 確認存檔位置（MANDATORY ASK）

**Always ask first. Do NOT skip.**

Ask exactly:

> 我會把 decision brief 和最終 ADR 都存成 markdown。
> 1. 給這次決策一個 slug（例如 `select-database`、`api-versioning-strategy`）
> 2. 預設存到 `decisions/<YYYY-MM-DD>-<slug>-brief.md` 和 `decisions/<YYYY-MM-DD>-<slug>.md`，可以嗎？

Suggest alternatives if user prefers:

| 路徑 | 場景 |
|---|---|
| `decisions/<date>-<slug>.md` | 進版控、團隊共享（推薦） |
| `ai/decisions/<date>-<slug>.md` | 個人筆記、不進版控 |
| `docs/adr/<date>-<slug>.md` | 已有 ADR 慣例的專案 |

Lock in `BRIEF_PATH` and `ADR_PATH` for later steps.

### Step 2: 與用戶寫 brief

Co-author the brief using this template (keep < 1000 words):

```markdown
# Decision Brief: <one-line title>

## The Decision
One sentence: what choice is being made.

## Why It Matters
Consequences of getting it wrong. Specific, not generic.

## Hard Constraints
What cannot change (budget, deadline, existing tech, team skill, regulation).

## Candidate Options
At least 2 options, briefly described. Each option:
- Description (1-2 sentences)
- Known pros (1-2 bullets)
- Known cons (1-2 bullets)

## Evaluation Criteria
What "good" looks like, ranked by importance.
```

Push back if user's brief lacks "Why It Matters" or "Candidate Options" — those are non-negotiable.

### Step 3: SAVE BRIEF TO FILE (MANDATORY)

**Non-negotiable.** Write the entire brief to `BRIEF_PATH` using `Write` tool.

Edge cases:
- Parent directory missing → `mkdir -p` first
- File already exists → ask user before overwriting

Then confirm:

```
✅ Brief 已存到 `<BRIEF_PATH>`
- 接下來請你把這個檔案內容（或上傳檔案）分別貼到 3 個模型，每個模型獨立詢問
```

### Step 4: 引導用戶跑 3 個模型

Tell the user explicitly:

> 請你把 `<BRIEF_PATH>` 的內容分別貼到下列 3 個模型（**獨立**，不要互相看答案）：
>
> - Claude（最新 Opus）
> - ChatGPT（最新版，Thinking 變體優先）
> - Gemini（最新 Pro）
>
> 每個模型加上這 5 個問題：
>
> 1. 你的建議和理由
> 2. 反對你自己建議的最強論點
> 3. 成本最低的驗證實驗
> 4. 你的建議依賴什麼假設
> 5. 什麼條件下你會改主意
>
> 跑完 3 家後，把 3 份回應貼回來給我。

### Step 5: 收集回應

Wait for user to paste back 3 responses. Confirm receiving each one before moving to comparison:

```
✅ 收到 Claude 回應
✅ 收到 GPT 回應
✅ 收到 Gemini 回應
```

If user only gets 1-2 responses (skipped a model), stop and ask: 「跑完三家才有意義，要不要先把第三家補完？」

### Step 6: 並排比較

Produce a comparison table:

```markdown
## 三模型比較

| 維度 | Claude | GPT | Gemini |
|---|---|---|---|
| 推薦選項 | ... | ... | ... |
| 主要理由 | ... | ... | ... |
| 反對論點 | ... | ... | ... |
| 驗證實驗 | ... | ... | ... |
| 假設 | ... | ... | ... |

## 結構分析
- **共識**（3 家都同意）：[列出]
- **2 vs 1**：[少數方是誰、為什麼不同意 — 通常它看到別人遺漏的]
- **三方分裂**：[列出 — 表示問題本質開放，用戶 context 是決定因素]
```

### Step 7: 與用戶寫最終 decision

Co-author final decision document. The **user is the final decider**, AI's job is to help articulate the reasoning. Template:

```markdown
# Decision: <one-line title>

**Date**: <YYYY-MM-DD>
**Status**: Accepted
**Brief**: [<filename>](./...-brief.md)

## Decision
What we chose, in one sentence.

## Reasoning
Why we chose this. Cite which model raised which insight:
- "Claude pointed out X..."
- "GPT's strongest concern was Y..."
- "Gemini suggested Z trade-off..."

## Trade-offs Accepted
What we knowingly gave up by choosing this.

## Validation Plan
The cheapest experiment we'll run to validate (from Stage 4 question 3).

## Reversibility Plan
If we're wrong, what's the cost to switch? When will we re-evaluate?
```

### Step 8: SAVE FINAL DECISION AS ADR (MANDATORY)

**Non-negotiable.** Write the decision document to `ADR_PATH` using `Write` tool.

### Step 9: 確認雙檔路徑

Reply exactly:

```
✅ Cross-model review 完成
- Brief: `<BRIEF_PATH>`
- Decision (ADR): `<ADR_PATH>`
- 共識度：[高 / 中 / 低]
- 主要決定：<1 句濃縮>
- 下一步：執行 Validation Plan
```

## What Cursor agent does vs. user does

| Cursor agent | User |
|---|---|
| 寫 brief（協作）+ 存檔 | 把 brief 帶到 3 個模型 |
| 比較 3 份回應 | 獨立執行 3 模型查詢 |
| 寫最終 ADR（協作）+ 存檔 | 做最終決定 |

## Constraints

- **Independence is critical.** Models cross-contaminate easily; never show one model another's answer
- **Don't substitute one strong model for three.** The point is divergent training data, not just multiple opinions
- **Avoid same-family different-size** (e.g. Opus + Sonnet) — blind spots overlap

## Quality gates

- ❌ 沒寫 brief 檔案 → 用戶無法獨立帶到 3 個模型，失去 cross-model 意義
- ❌ 沒寫 ADR 檔案 → 整個 review 沒留下 artifact，等於沒做
- ❌ 用戶只跑 1-2 家就跳過 → 沒達到三模型門檻，停下要求補齊
- ❌ 把一家答案給另一家看 → 違反獨立性，整個 review 作廢
- ✅ 兩個檔案都在磁碟上、ADR 標註每個 insight 來自哪家

## Reference

Long-form workflow doc: [~/dotfiles/workflows/cross-model-review.md](~/dotfiles/workflows/cross-model-review.md)
