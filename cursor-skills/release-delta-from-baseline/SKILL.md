---
name: release-delta-from-baseline
description: >-
  Compares a git baseline to a target branch (default dev), summarizes commits,
  and emits paste-ready release notes (heading "# Release v") in the language
  convention of that repo's CHANGELOG. Writes TARGET HEAD to
  .cursor/ai/docs/release-baseline.txt and syncs CHANGELOG 「当前基线」 / baseline line.
  Use for incremental release notes, 補充更新, release delta, or slash command
  release-delta-from-baseline.
disable-model-invocation: true
---

# Release Delta from Baseline

## 概覽 / Overview

**繁中：**本 Skill 說明文件採**繁體中文 + 英文**雙語；實際產出的**發布條列**用語（簡中／繁中／英）須遵循**目標專案**既有的 `CHANGELOG.md` 與團隊慣例（Agent 應先讀取該檔語氣與節名再對齊）。

**EN:** This `SKILL.md` is **Traditional Chinese + English**. The **release bullet text** language (zh-CN / zh-TW / en) must follow the **target repo’s** `CHANGELOG.md` and team norms (read that file first and match tone / section labels).

> **繁中：**適用於倉庫根目錄有 `CHANGELOG.md`、主開發分支常名為 `dev` 的類專案（例如 Expo / React Native）。若各專案維護小節標題不同，Agent 必須以**實際檔案**為準尋找「當前基線」對應的那一行（常見為 `` `**当前基线**：` `` 或專案自訂的同義行）。
>
> **EN:** For repos with root `CHANGELOG.md` and a main branch often named `dev` (e.g. Expo / RN). If maintenance headings differ, locate the **current baseline** line from the real file (often `` `**当前基线**：` `` or a project-specific equivalent).

---

## 何時使用 / When to use

**繁中：**使用者提供**基線**（或可從檔案讀取），要列出相對**目標分支**（預設 `dev`）的增量，並輸出可貼上的對外說明；流程**結尾**須把 **TARGET HEAD** 寫入本地基線檔，並**同步** `CHANGELOG.md` 內約定的「當前基線」那一行。

**EN:** User supplies a **baseline** (or it is read from files). List commits between baseline and **TARGET** (default `dev`), output paste-ready release notes; at the **end**, write **TARGET HEAD** to the local baseline file and **sync** the agreed **current baseline** line in `CHANGELOG.md`.

---

## 基線讀取順序（必須依序嘗試）/ Baseline resolution (strict order)

**繁中：**

1. 使用者在本輪對話中**明確寫出**的 SHA / tag。
2. 讀 **`.cursor/ai/docs/release-baseline.txt`**：取**第一行**非空內容；若為 `待填写` / `待填寫` 或無效 SHA，略過。
3. 讀 **`CHANGELOG.md`**：尋找專案約定的**當前基線**行（例如 `` `**当前基线**：` ``）；無效則略過。
4. 仍無法解析 → **向使用者索取**，禁止臆測。

**EN:**

1. SHA / tag the user states explicitly in this turn.
2. Read **`.cursor/ai/docs/release-baseline.txt`** first line; ignore if placeholder or invalid.
3. Read **`CHANGELOG.md`** for the **current baseline** line (e.g. `` `**当前基线**：` ``); ignore if invalid.
4. If still unknown → **ask the user**; do not guess.

> **繁中：**`release-baseline.txt` 通常在已 gitignore 的 `.cursor/` 下；`CHANGELOG.md` **會進版控**—改完請使用者自行檢視 diff 再 commit。
>
> **EN:** `release-baseline.txt` is usually under gitignored `.cursor/`; `CHANGELOG.md` is **tracked**—user should review diff before commit.

---

## 操作步驟 / Procedure

**繁中：**

1. 在倉庫根目錄：`git fetch origin dev 2>/dev/null`（失敗則略過）。
2. 依上一節得到 **BASELINE**。
3. **TARGET** 預設 `dev`；使用者另指則從之。
4. 執行：`git log -1 --oneline TARGET`、`git log BASELINE..TARGET --oneline --no-decorate`
5. 對影響說明的非 merge commit，必要時 `git show <sha> --stat` / `-p`。
6. 依**功能域**合併同類項（範例：永續合約、流動性、借貸…—實際標籤依專案）。

**EN:**

1. Repo root: `git fetch origin dev 2>/dev/null` (optional).
2. Resolve **BASELINE** as above.
3. **TARGET** defaults to `dev` unless user overrides.
4. Run `git log -1 --oneline TARGET` and `git log BASELINE..TARGET --oneline --no-decorate`.
5. Inspect non-merge commits with `git show` when needed.
6. Group by **feature area** (labels depend on the project).

---

## 輸出格式（必須遵守）/ Output format (required)

**繁中：**標題與區塊結構固定如下；**條列內文字**須與該專案 `CHANGELOG.md` 語言一致（簡中專案用簡中、繁中專案用繁中，以此類推）。若專案全英文則用英文條列。

**EN:** Keep this **structure**; **bullet body language** must match the project’s `CHANGELOG` convention (zh-CN, zh-TW, en, etc.).

```text
# Release vX.Y.Z(build)

（此處一行的標籤依專案慣例，例如「更新内容:」或「更新內容：」或 “What’s changed”）

## 區塊標題 / Section title
• 第一條
• 第二條
```

**繁中規則：**

- 第一行：`# Release v` + 版本 + `(` + build + `)`；未提供則 `# Release v（請填寫版本(build)）` 並提醒補全。
- 標題後空行 → 再寫**專案慣用**的「更新內容」行（可參考該 repo 既有發佈範例）。
- 空行 → `##` 小節；條目用 **`• `**（U+2022），不要用 Markdown `-` 列表。
- 無新 commit：正文寫**無差異**表述（依專案語言），並仍給出 HEAD 供核對。

**EN rules:** Same structure; use **`• `** bullets; no `-` markdown list for the shipped block.

After the block, print one line **Git**: `BASELINE → HEAD` (short SHA ok).

---

## 寫回基線（必須執行）/ Write-back baseline (mandatory)

**繁中：**交付內容後**立刻**完成（順序可調，但須全做）：

1. `git rev-parse TARGET` → 完整 40 字元 **NEW_HEAD**。
2. **覆寫** **`.cursor/ai/docs/release-baseline.txt`**：僅一行 `NEW_HEAD`。
3. **更新根目錄 `CHANGELOG.md`**：在使用者專案約定的小節內，找到**唯一**的「當前基線」行（常見形狀：行首 `**当前基线**：`，後接反引號包住的 SHA），將該**整行**替換為相同形狀且反引號內為 **NEW_HEAD** 的一行。專案若用不同標籤，維持原行 Markdown 結構，只更新 SHA。找不到、多行重複、或尚無此節 → **停手**並向使用者說明；確認前可只更新本地 `release-baseline.txt`。
4. 若缺目錄則建立 `.cursor/ai/docs/`。

**EN:** (1) `git rev-parse TARGET` → **NEW_HEAD**. (2) Overwrite **`.cursor/ai/docs/release-baseline.txt`** with one line. (3) Replace the **single** baseline line in `CHANGELOG.md`, preserving the project’s line shape (e.g. `**当前基线**：` + `` `SHA` ``). (4) Create missing dirs. If ambiguous, stop and ask.

If file writes fail, give copy-paste commands to the user.

---

## Skill 與 Cursor Command 的差異 / Skill vs Command

| | **Skill** | **Command** |
|--|-----------|-------------|
| **繁中** | 定義 Agent **怎麼做** | 使用者快捷提示詞 |
| **EN** | Defines **how** the agent works | Shortcut prompt for the user |

**繁中：**可並存—Command 內引用本 Skill 並重申「寫入 `release-baseline.txt` + 更新 `CHANGELOG` 基線行」。

**EN:** Both can coexist—point the Command at this Skill and repeat the write-back steps.

---

## 與使用者對話的語言 / Language when talking to the user

**繁中：**若專案規則要求（例如 workflow-language），與使用者對話可用繁體；**貼上的發布塊**語言仍依上文「CHANGELOG 慣例」。

**EN:** Follow the project’s AI language rule for **chat**; **release block** language follows **CHANGELOG** convention.

---

## 安裝到 Cursor / Install

```bash
mkdir -p ~/.cursor/skills
ln -sf ~/dotfiles/cursor-skills/release-delta-from-baseline ~/.cursor/skills/release-delta-from-baseline
```

**繁中：**或在各專案使用 `.cursor/skills/release-delta-from-baseline/`（須未忽略該路徑或自行納管）。

**EN:** Or symlink/copy into a project’s `.cursor/skills/` if not gitignored.
