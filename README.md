# dotfiles

跨電腦同步的開發環境設定與 AI agent 工作流程資產。

## 結構

```
dotfiles/
├── cursor-rules/          # Cursor 全域規則（15 條 .mdc，symlink 到 ~/.cursor/rules/）
├── prompts/               # 工具無關的 prompt 模板（按 SDLC 階段）
├── tools/                 # 工具特定配置（Claude Projects、Custom GPTs、Cursor agents）
├── workflows/             # 跨工具的端到端工作流程
├── assets/                # 可複用模板與 checklist
├── decisions/             # ADR（本 repo 自身的決策記錄）
└── _drafts/               # 未啟用的範本「冷藏庫」（避免 cargo culting）
```

> `_drafts/` 是有意設計的：規劃過但未實戰用過的範本放這裡，啟用時 `mv` 到對應主目錄。
> 詳見 `decisions/2026-04-28-expand-dotfiles.md`。

## Cursor Rules 一覽（`cursor-rules/`）

### Swift 程式碼規範（10 條）— `globs: "**/*.swift"`，僅編 Swift 時觸發

| 檔案 | 主題 |
|---|---|
| `swift-conventions.mdc` | 一般 Swift 慣例（Commit、文檔、品質） |
| `swift-mvvm.mdc` | MVVM 架構（Modern @Observable / Classic ObservableObject、資料流、依賴注入） |
| `swift-project-structure.mdc` | 資料夾結構與導覽慣例 |
| `swift-safety.mdc` | 安全性與非同步（禁強制解包、線程安全） |
| `swift-theme.mdc` | AppColors / AppFonts 使用規範 |
| `swift-testing.mdc` | 測試規範（XCTest/Swift Testing、Mock、SwiftUI 四種測試型態） |
| `swift-error-handling.mdc` | 錯誤處理（自定 LocalizedError、throws/Result/Optional 選用） |
| `swift-concurrency.mdc` | 進階併發（actor、Sendable、Task、AsyncSequence） |
| `swift-accessibility.mdc` | 無障礙（VoiceOver、Dynamic Type、對比、Reduce Motion） |
| `swift-dependencies.mdc` | 套件管理（SPM、評估標準、版本鎖定） |

### 工作流程規範（4 條）— `alwaysApply: true`，每次對話都帶入

| 檔案 | 主題 |
|---|---|
| `workflow-dev-plan.mdc` | 開發前必須有計畫，依計畫執行 |
| `workflow-git-commit.mdc` | 必須等用戶測試確認後才能 commit |
| `workflow-language.mdc` | AI 一律以繁體中文回應 |
| `workflow-completion-evidence.mdc` | 完成主張必須附帶具體證據（檔案範圍、驗證結果、下一步） |

### 通用規範（2 條）— `alwaysApply: true`，跨所有語言適用

| 檔案 | 主題 |
|---|---|
| `general-security.mdc` | secret 管理、Keychain、洩漏處理 |
| `general-comments.mdc` | 註解寫 why 不寫 what、禁止廢話註解、TODO 規範 |

## Prompts（`prompts/`）

工具無關的 prompt 模板，可直接貼進 Claude、ChatGPT、Gemini 使用。

| 檔案 | 階段 | 最佳工具 |
|---|---|---|
| `stage-1-ideation.md` | 需求發想 | ChatGPT Custom GPT |
| `stage-3-spec.md` | 技術規格 | Claude Project |

未啟用：stage-2/4/5/6/7（在 `_drafts/prompts/`）

## Workflows（`workflows/`）

跨工具的端到端工作流程。

| 檔案 | 觸發情境 |
|---|---|
| `new-feature.md` | 從發想到部署的完整新功能流程 |
| `cross-model-review.md` | 三模型交叉檢查（重大決策用） |

未啟用：bug-fix、refactor、tech-evaluation、producer-reviewer-loop（在 `_drafts/workflows/`）

## Assets（`assets/`）

| 檔案 | 用途 |
|---|---|
| `decision-tree.md` | 工具路由決策樹（什麼任務用什麼工具） |

未啟用：handoff-templates、checklists（在 `_drafts/assets/`）

## Tools（`tools/`）

各 AI 工具的設定說明。已啟用 4 個工具配置，其餘等實戰需要時再啟用。

### 已啟用（4 個）

| 檔案 | 用途 |
|---|---|
| `tools/claude/projects/system-architect.md` | Claude Project: 累積架構知識，跨對話保留上下文 |
| `tools/claude/projects/code-reviewer.md` | Claude Project: 累積代碼風格偏好，做 code review |
| `tools/chatgpt/custom-gpts/product-thinker.md` | Custom GPT: 模糊想法釐清為 Problem Statement |
| `tools/chatgpt/custom-gpts/tech-evaluator.md` | Custom GPT: 系統化技術選型評估 |

### 目錄結構

| 路徑 | 用途 |
|---|---|
| `tools/claude/projects/` | Claude Project 的 Custom Instructions |
| `tools/chatgpt/custom-gpts/` | ChatGPT Custom GPT 配置 |
| `tools/gemini/` | NotebookLM 與 Deep Research 使用指南 |
| `tools/cursor/agents/` | Cursor Subagent 定義 |
| `tools/cursor/commands/` | Cursor 自定義 `/` 指令 |

未啟用：cursor agents/commands、gemini 配置（在 `_drafts/tools/`）

## Decisions（`decisions/`）

本 repo 自身的 ADR（Architecture Decision Records）。

| 檔案 | 主題 | 狀態 |
|---|---|---|
| `2026-04-28-expand-dotfiles.md` | 擴充 dotfiles 而非開新 repo | 提案中 |

## 新電腦初次設置

```bash
# 1. Clone 到家目錄
git clone git@github-personal:Edison-Wang/dotfiles.git ~/dotfiles

# 2. 建立 Cursor rules symlink（若 ~/.cursor/rules 已存在請先備份或刪除）
mkdir -p ~/.cursor
ln -s ~/dotfiles/cursor-rules ~/.cursor/rules

# 3. 驗證
ls ~/.cursor/rules/
```

> 注意：使用 `git@github-personal:` 而非 `git@github.com:`，這樣 SSH 才會用個人帳號 key（見 `~/.ssh/config`）。
> 新電腦也需先設定 SSH config 與 key（未來若把 ssh config 也納管到本 repo 就能完全自動化）。

`prompts/`、`tools/`、`workflows/`、`assets/`、`decisions/`、`_drafts/` 不需要 symlink，直接在 repo 內查看與編輯即可。

## 日常更新

```bash
cd ~/dotfiles
git pull                  # 拉最新
# ... 編輯規則 / prompts / workflows ...
git add . && git commit -m "update: <說明>"
git push
```

## Cursor Rules 作用範圍

- **全域生效**：所有 Cursor 專案都會讀到此 repo 的規則
- **專案覆蓋**：若某專案 `<project>/.cursor/rules/` 有同名檔案，會覆蓋全域版
- **swift-* 系列**：只在打開 `.swift` 檔時觸發，其他語言專案不會被干擾
- **workflow-* 與 general-***：`alwaysApply: true`，所有對話都會帶入 context

## 維護原則

- 改規則後手動 commit + push，新電腦才拿得到
- 每條規則保持單一職責，避免一個檔案塞太多主題
- 強制與選用要清楚標示，避免 AI 把選用當必加
- 廢棄條目用 git rm 移除，不要靠註解標記
- Prompt / workflow 範本在實戰中不斷迭代，發現更好的 pattern 就更新
- 重大變更記錄在 `decisions/` 作為 ADR
- `_drafts/` 的範本啟用前不修改（git 歷史夠了）
