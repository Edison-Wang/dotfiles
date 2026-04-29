---
name: codebase-onboarding
description: Analyze unfamiliar codebase and produce a markdown report SAVED TO DISK for cross-model verification and later reference. Use when the user takes over a new project, mentions "接手 / onboarding / 分析這個專案 / 看一下這個 codebase / review 整個專案", or asks for a structured overview of an existing repository they didn't write themselves.
---

# Codebase Onboarding

Help the user systematically analyze an unfamiliar codebase and produce a structured onboarding report **saved to a markdown file** so it can be revisited, shared, or fed to other AI models for cross-verification.

## When to apply

- User just received / opened an unfamiliar project
- User says they need to "接手", "review", "分析", "理解" a project
- User asks for an overview / health check / tech debt assessment of existing code
- Use **Ask mode** style behavior: read-only analysis, no source code edits

## When NOT to apply

- User wrote the code themselves (suggest cross-model-review skill instead)
- Project has < 20 files (just read them directly)
- User is asking about a specific file / function (just answer directly)

## Workflow checklist

Track this checklist explicitly during execution. Every step must be done.

```
Onboarding Progress:
- [ ] Step 1: Confirm save destination (MANDATORY ASK)
- [ ] Step 2: Confirm scope (only if unclear)
- [ ] Step 3: Parallel exploration via explore subagent
- [ ] Step 4: Produce structured report
- [ ] Step 5: SAVE REPORT TO FILE (MANDATORY)
- [ ] Step 6: Confirm written path back to user
- [ ] Step 7: Suggest next step
```

### Step 1: Confirm save destination (MANDATORY ASK)

**Always ask this question first. Do NOT skip even if user seems to want to start immediately.**

Ask exactly:

> 我會把分析報告存成 markdown 檔，預設路徑 `docs/onboarding-analysis.md`，這樣可以嗎？或要改其他位置？

Suggest these alternatives if the user is unsure:

| 路徑 | 用途 |
|---|---|
| `docs/onboarding-analysis.md` | 進版控、團隊共享 |
| `ai/codebase-analysis.md` | 在 ai/，已被 git ignore，個人筆記用 |
| `notes/<YYYY-MM-DD>-onboarding.md` | 帶日期，多次 onboarding 不會覆蓋 |

Lock in the path before any analysis begins. Save the chosen path to memory for Step 5.

### Step 2: Confirm scope (only if unclear)

If the project is large or has multiple sub-projects, ask once:

> 是要「整個 repo 全面分析」還是「focus 在某個子模組」？

If the scope is obvious (small to medium repo, single product), skip this question.

### Step 3: Parallel exploration

Use the `explore` subagent (`Task` tool with `subagent_type: explore`) to gather information in parallel across these areas. **Don't read files sequentially — fan out.**

1. Tech stack (package files, build configs, lockfiles)
2. Folder structure & entry points
3. Recent git activity (commit log, contributors, last activity)
4. Test coverage signals (test/ directory density)
5. Outdated / vulnerable dependencies

### Step 4: Produce structured report

Output the report using exactly these seven sections. **Be specific: cite file paths and line numbers. No sugar-coating.**

```markdown
# Codebase Onboarding: <project-name>

## 1. 專案概要
- 做什麼（一段話，白話）
- 主要使用者 / 業務領域猜測
- 規模（檔案數、主語言行數、git 歷史長度）
- 開發活躍度（最近 commit 頻率、最後活動時間）

## 2. 技術棧
- 主語言 + 版本
- 框架 + 版本
- 建置 / 套件管理 / 測試 / Lint 工具
- CI/CD（.github/workflows、.gitlab-ci 等）
- 部署目標

## 3. 架構
- 資料夾結構策略（feature-based / layer-based / domain-based）
- 模組劃分、進入點
- 對外介面（API / CLI / GUI）組織
- 全域狀態 / 設定管理
- 跨層通訊方式

## 4. 程式碼慣例與品質
- 命名慣例
- 抽象風格（OOP / FP / 混用）
- 型別覆蓋率粗估
- 測試覆蓋率粗估
- Lint / Format 設定嚴格度

## 5. 技術債與風險（最重要，不能省）
- 三個最嚴重的技術債（檔案 + 行號）
- 過時 / 有漏洞的依賴（lockfile 對照 deprecation）
- 反模式（巨大檔案、深層巢狀、重複代碼、any 滿天飛、神類別）
- 安全顧慮（暴露的 key、缺少驗證、SQL injection、XSS、不安全 deserialize）
- 測試 / 文檔的明顯缺口

## 6. 進入順序（onboarding path）
- 先讀哪三個檔案理解整體架構
- 先跑哪個指令看效果
- 哪個模組是核心商業邏輯必須懂
- 哪個模組可以先不碰
- 任何「禁區」（容易炸的、改了會牽連很多的）

## 7. 給新接手者的 5 個立即建議
- 具體、可執行、排優先級
- 例如「跑 X 看是否能 build」「修 Y 處明顯 bug 熱身」「先不要動 Z」
```

### Step 5: SAVE REPORT TO FILE (MANDATORY)

**This step is non-negotiable. The skill is NOT complete until the file is on disk.**

Write the entire report (Step 4 content) to the path confirmed in Step 1 using the `Write` tool.

Edge cases:
- If the parent directory doesn't exist (e.g., `docs/` missing) → create it first using `mkdir -p`, then write
- If the file already exists → ask user before overwriting
- If write fails for any reason → report the error and **do not** declare completion

### Step 6: Confirm written path back to user

Reply with this exact format:

```
✅ 報告已存到 `<absolute-or-relative-path>`
- 行數：<N>
- 主要發現：<1-2 句濃縮，例如「React 18 + Vite，主要技術債在狀態管理」>
```

This message is the explicit signal that Step 5 succeeded.

### Step 7: Suggest next step

Tell the user one of:

- 「想拿給其他模型 cross-check 找盲點？用 Claude System Architect 或 `/cross-model-review` skill」
- 「實際 build run 一次驗證 onboarding path 是否合理」
- 「報告太長想精簡？挑前 3 個立即建議先做」

## Language-specific adapters

Add these extra questions to Step 4 based on detected stack:

- **React / Vue / Angular**: bundle size、SSR/CSR/SSG、SEO、a11y、瀏覽器相容
- **Node.js / Python / Go backend**: DB schema 演進、API 版本、auth flow、observability
- **iOS / Android Native**: 最低支援版本、套件數、deprecated API、權限聲明
- **monorepo**: workspace 工具、套件邊界、共用型別、CI 平行化
- **CLI / library**: API 穩定性承諾（semver）、文檔覆蓋、breaking change 歷史

## Quality gates (self-check before declaring complete)

- ❌ **沒寫入檔案就宣稱完成** → 不算完成，必須回去執行 Step 5
- ❌ **沒先問存檔路徑就開始分析** → 違反 Step 1 強制要求
- ❌ 「技術債」是空的 → retry，要嘛太淺要嘛專案完美（罕見）
- ❌ 「進入順序」只列檔案沒講為什麼 → 沒做到 onboarding 本質
- ❌ 沒有檔案路徑 / 行號引用 → 太抽象，retry
- ❌ 「立即建議」全部是「重構整個專案」這類大話 → 失敗
- ✅ 看完報告能說出「我這週要做的三件事」 → 成功
- ✅ 用戶可以打開 markdown 檔案查看 → 成功

## Reference

For human-readable longer prompt with rationale, see [~/dotfiles/prompts/codebase-onboarding.md](~/dotfiles/prompts/codebase-onboarding.md).
