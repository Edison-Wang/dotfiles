---
name: producer-reviewer-loop
description: Iterate a single high-quality non-code artifact (plan, spec, ADR, refactor design, architecture doc) through Producer-Reviewer rounds across two different model families, SAVING each iteration to disk for traceability. Use when the user wants a high-stakes single deliverable, says "嚴格 review / producer reviewer / 高品質 spec / 來回迭代 / 找盲點", or when artifact quality is critical.
---

# Producer-Reviewer Loop

Serial iteration on a single artifact: Producer drafts → Reviewer attacks → Producer revises → Reviewer confirms. Each round's artifacts are saved to disk for traceability.

## When to apply

- Output is a **single high-quality non-code artifact** (plan, spec, ADR, refactor design, architecture doc)
- Wrong artifact is expensive (will mislead implementation downstream)
- User says: 「嚴格 review」「找盲點」「高品質 spec」「來回迭代」「producer reviewer」

## When NOT to apply

- **Code review** → use Cursor's built-in Agent Review (Source Control → Find Issues), not this skill
- Reversible decisions → just pick one and try
- Daily artifacts → one tool is enough
- Time-critical → one round is better than nothing
- Artifact itself isn't important → not worth the effort

## How this differs from cross-model-review

| Dimension | cross-model-review | producer-reviewer-loop |
|---|---|---|
| Suited for | High-stakes **decisions** (A vs B) | High-stakes **artifacts** (is this plan correct) |
| Pattern | Parallel — 3 independent answers | Serial iteration — A drafts → B critiques → A revises |
| Termination | Human synthesis complete | Reviewer has no blockers |
| Output | Decision with risk profile | Reviewed single artifact |

## Roles

### Producer
- **Strength**: architectural thinking, long reasoning, creativity, integration
- **Blind spot**: over-confidence in own output (false completion tendency)
- **Recommended model**: Claude (Opus or current flagship). **Cursor agent itself usually plays this role.**

### Reviewer
- **Must be different family from Producer** to avoid self-review blind spots
- **Strength**: rigor, finding gaps, catching implicit dependencies
- **Recommended model**: GPT Thinking, Gemini Pro
- **Avoid**: same family different size (e.g. Opus + Sonnet) — blind spots align

## Directory structure (artifact storage)

All iteration artifacts live in a per-task directory:

```
ai/producer-reviewer/
└── <YYYY-MM-DD>-<slug>/
    ├── producer-v1.md             # First Producer draft
    ├── reviewer-r1-findings.md    # Reviewer round 1 findings
    ├── producer-v2.md             # Producer's revision (response to r1)
    ├── reviewer-r2-findings.md    # Round 2 findings (or approval)
    ├── producer-v3.md             # (only if r2 had blockers)
    └── final.md                   # Final approved artifact (also copied to user's chosen path)
```

`ai/producer-reviewer/` is under the project's `ai/` directory, which is git-ignored by default (per `init-ai-workspace.sh` setup). The **final artifact** is additionally copied to the user-confirmed location (e.g. `docs/specs/...`).

## Workflow checklist

```
Producer-Reviewer Loop Progress:
- [ ] Step 1: 確認任務 slug + 最終 artifact 存檔路徑（MANDATORY ASK）
- [ ] Step 2: 建立 ai/producer-reviewer/<date>-<slug>/ 目錄
- [ ] Step 3: Producer 產出 v1
- [ ] Step 4: SAVE producer-v1.md (MANDATORY)
- [ ] Step 5: 引導用戶把 v1 貼到 reviewer 模型，回貼 findings
- [ ] Step 6: SAVE reviewer-r1-findings.md (MANDATORY)
- [ ] Step 7: Producer 修訂 → v2（item-by-item 回應 findings）
- [ ] Step 8: SAVE producer-v2.md (MANDATORY)
- [ ] Step 9: 引導用戶把 v2 給 reviewer 確認，回貼 round-2 結果
- [ ] Step 10: SAVE reviewer-r2-findings.md (MANDATORY)
- [ ] Step 11: 判斷終止條件
        - approved → Step 12
        - 仍有 blocker 且 round < 3 → 回 Step 7（v3, r3...）
        - round = 3 仍有 blocker → 設 BLOCKED 通知用戶停下重新校準
- [ ] Step 12: SAVE final.md（最終版）+ 複製到用戶確認的最終路徑
- [ ] Step 13: 確認所有檔案路徑回報給用戶
```

### Step 1: 確認 slug + 最終路徑（MANDATORY ASK）

**Always ask first.**

> 我會把每一輪的 Producer 草稿和 Reviewer findings 都存到 `ai/producer-reviewer/<date>-<slug>/`，最終版另外複製一份到你指定的位置。
>
> 1. 給這次 review 一個 slug（例如 `auth-spec`、`migration-plan`）
> 2. 最終版要存到哪？預設 `docs/<slug>.md`，可以嗎？

Lock in `WORK_DIR = ai/producer-reviewer/<YYYY-MM-DD>-<slug>/` and `FINAL_PATH = <user choice>`.

### Step 2: 建立 work dir

```bash
mkdir -p "<WORK_DIR>"
```

If `<WORK_DIR>` already exists (rare unless re-running same day with same slug):
- Ask user: 「目錄已存在，是繼續同一輪還是用新 slug？」
- Continue → load latest version (v2 if exists, else v1) and resume from where it left off

### Step 3: Producer 產出 v1

Cursor agent acts as Producer. Generate v1 based on user's task description + context. Use Markdown structure appropriate to the artifact type:

- **Plan / spec** → use [~/dotfiles/_drafts/assets/handoff-templates/tech-spec.md](~/dotfiles/_drafts/assets/handoff-templates/tech-spec.md)
- **Architecture doc** → use [~/dotfiles/_drafts/assets/handoff-templates/architecture-doc.md](~/dotfiles/_drafts/assets/handoff-templates/architecture-doc.md)
- **ADR** → use [~/dotfiles/decisions/_template.md](~/dotfiles/decisions/_template.md)
- **Other** → ask user for preferred structure

### Step 4: SAVE producer-v1.md (MANDATORY)

**Non-negotiable.** Write to `<WORK_DIR>/producer-v1.md`.

Confirm:

```
✅ Producer v1 已存到 `<WORK_DIR>/producer-v1.md`
- 行數：<N>
- 接下來請把這個檔案內容貼到你選的 Reviewer 模型（建議：GPT Thinking 或 Gemini Pro）
```

### Step 5: 引導用戶跑 Reviewer round 1

Tell the user explicitly:

> 把 `<WORK_DIR>/producer-v1.md` 內容貼到 [GPT Thinking / Gemini Pro] 對話，附上這個 prompt：

```
你正在審核一份 [類型：implementation plan / spec / refactor design / ADR / ...]。
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
[Producer 產出 — 從 producer-v1.md 貼上]
```

Wait for user to paste back Reviewer's findings.

### Step 6: SAVE reviewer-r1-findings.md (MANDATORY)

**Non-negotiable.** Write the Reviewer findings (raw, as user pasted) to `<WORK_DIR>/reviewer-r1-findings.md`.

Add a header noting which model was used:

```markdown
# Reviewer Round 1 Findings

**Model**: <GPT Thinking / Gemini Pro / etc.>
**Date**: <YYYY-MM-DD HH:MM>

---

[user-pasted findings verbatim]
```

### Step 7: Producer 修訂 → v2

Cursor agent (Producer) responds to findings **item-by-item**. For each finding:

- ✅ Accept → fix in v2
- ❌ Reject → state reason in v2 (in a "## Reviewer Round 1 Responses" section)
- ❓ Need clarification → ask user, then proceed

Produce full v2 (not just diff). The "Responses" section can be at the end or inline as comments.

### Step 8: SAVE producer-v2.md (MANDATORY)

Write to `<WORK_DIR>/producer-v2.md`.

```
✅ Producer v2 已存到 `<WORK_DIR>/producer-v2.md`
- 處理了 r1 的 N 個 findings（X accepted, Y rejected, Z need clarification）
- 接下來請把 v2 + r1 findings 一起貼回 Reviewer 確認
```

### Step 9: 引導用戶跑 Reviewer round 2

> 把 `<WORK_DIR>/producer-v2.md` 和 `<WORK_DIR>/reviewer-r1-findings.md` 一起貼回同一個 Reviewer 模型，附上這個 prompt：

```
這是 Producer 對你第一輪 review 的修訂版本。
請逐項確認：
- Blocker 是否都已處理？
- 修訂過程有沒有引入新問題？
- 還有沒有第一輪沒看出的問題？

如果 OK，明確說「Approved, ready for human review」。
否則繼續用 Blocker / Major / Minor 分類。

INPUT:
[Reviewer round 1 findings]
[Producer v2]
```

### Step 10: SAVE reviewer-r2-findings.md (MANDATORY)

Same format as Step 6, write to `<WORK_DIR>/reviewer-r2-findings.md`.

### Step 11: 判斷終止條件

Read `reviewer-r2-findings.md` and branch:

- **Approved** ("No blockers" / "Approved, ready for human review") → Step 12
- **Still has blockers, round count < 3** → Loop back: Producer v3 → Reviewer r3 → repeat
- **Round count = 3 and still blockers** → 設 BLOCKED 並通知用戶：

```
⚠️ BLOCKED：跑了 3 輪迭代仍有 blocker。
這通常代表：
1. 任務本身定義不清，需要人類釐清
2. Producer 或 Reviewer prompt 設計需要調整
3. 任務本身在這兩個模型的能力範圍外

建議停下來重新校準，不要繼續加輪數。
所有歷史在 `<WORK_DIR>/` 可供參考。
```

### Step 12: SAVE final.md + 複製到 FINAL_PATH

Two saves:
1. `<WORK_DIR>/final.md` — 最終定稿，留在 work dir 作歸檔
2. `<FINAL_PATH>` — 複製一份到用戶指定位置（例如 `docs/specs/auth-spec.md`）

Both files content identical. Use `Write` tool twice (or write once then `cp`).

If `<FINAL_PATH>` parent directory missing → `mkdir -p` first.

### Step 13: 確認所有檔案路徑

Reply exactly:

```
✅ Producer-Reviewer Loop 完成
- 工作目錄：`<WORK_DIR>/`
  - producer-v1.md, producer-v2.md, ... (N versions)
  - reviewer-r1-findings.md, reviewer-r2-findings.md, ... (N rounds)
  - final.md
- 最終版：`<FINAL_PATH>`
- 總輪數：<N>
- Reviewer 模型：<which one>
- 主要修訂重點：<1-2 句濃縮>
- 下一步：人類最終 review，如果沒問題就執行
```

## Defaults

- **Default 2 rounds** — diminishing returns after that
- **More than 3 rounds** → artifact or prompt design has issues; stop and recalibrate
- **Reviewer always says "No blockers" on round 1** → reviewer too lax; tighten prompt next time

## Sanity check: trap test

Periodically validate the loop **actually works** (isn't rubber-stamping).

Embed a small intentional error in Producer's input:
- Outdated API name
- Logical contradiction (e.g. "verify token before parsing it")
- Decision violating a stated rule
- Wrong number (budget is 100k, plan says 1M)

**Reviewer should catch it.** If not, switch reviewer model or tighten review prompt.

Frequency: monthly, or whenever changing Producer/Reviewer combination.

## Quality gates

- ❌ **任何一輪沒存檔** → 等於沒做，不算完成
- ❌ **沒先問 slug 和 final path** → 違反 Step 1 強制要求
- ❌ **超過 3 輪繼續硬刷** → 違反防呆，必須 BLOCKED
- ❌ **Producer 偷偷改 Plan 不在 v2 標記** → 失去 traceability
- ❌ **Reviewer 一輪就 approve 卻沒檢查** → rubber stamp，跑 trap test 驗證
- ❌ **Final 沒同時複製到 FINAL_PATH** → 用戶要找最終版很痛苦
- ✅ work dir 內所有 versions 和 findings 都在
- ✅ FINAL_PATH 有最新的 final.md 副本

## Reference

Long-form workflow doc: [~/dotfiles/_drafts/workflows/producer-reviewer-loop.md](~/dotfiles/_drafts/workflows/producer-reviewer-loop.md)
