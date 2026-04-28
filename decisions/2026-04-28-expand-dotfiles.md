# ADR 2026-04-28: 擴充 dotfiles 而非開新 repo

## 狀態
提案中

> 等實際使用 1-2 週後，根據體感再決定改為「已接受」或「已棄用」。

## 脈絡
需要一個地方存放 AI agent 工作流程資產（prompt 模板、工具配置、workflow 文件）。

考慮過的方案：

1. **開新 repo `agent-toolkit`**（最初建議）
   - 優點：關注點分離、可以分別控制可見性
   - 缺點：實際檢視 dotfiles 內容後發現，dotfiles 已經是一個 AI 配置 repo（只有 Cursor rules），與 agent-toolkit 的消費者、更新頻率、本質完全相同。分開反而製造維護負擔。

2. **擴充現有 dotfiles**（最終選擇）
   - 優點：cursor-rules/ 和 prompts/ 是同一類東西（告訴 AI 怎麼工作的文本），經常在同一個思考脈絡下一起修改。
   - 採用 `_drafts/` 結構解決 cargo culting 風險（見「決定」段）。

## 決定

在現有 dotfiles repo 中新增以下目錄，保持 `cursor-rules/` 不動：

- `prompts/` — 工具無關的 prompt 模板
- `tools/` — 各 AI 工具的配置說明
- `workflows/` — 跨工具的端到端工作流程
- `assets/` — 可複用的模板和 checklist
- `decisions/` — 本 repo 自身的 ADR

採用 `_drafts/` 結構：未實際用過的範本放在 `_drafts/` 下，啟用時 `mv` 到對應主目錄。理由：
- 避免 cargo culting（堆貨物拜祭）— 主目錄只放真正用過的東西
- 不丟失內容 — 所有規劃過的範本都在 git 中
- 啟用成本最低 — 一行 `mv` 指令

## 後果

正面：
- 一個 repo 管理所有 AI 相關資產
- 同一個 git 歷史追蹤所有改動
- 不需要跨 repo 同步
- 主目錄視覺乾淨，`_drafts/` 提供「規劃倉庫」

負面：
- 如果未來加入傳統 dotfile（.zshrc、.gitconfig），repo 會變雜。屆時可考慮拆分。
- repo 名稱 `dotfiles` 不完全反映內容，但改名成本 > 收益。
- `_drafts/` 結構需要紀律維護，避免變成「永遠不會啟用的清單」。

## 重新檢視的條件

- 如果 `_drafts/` 兩個月後仍 90% 沒啟用 → 砍掉沒啟用的、收斂為「實用主義」原則
- 如果加入大量傳統 dotfile 導致 repo 變雜 → 考慮拆分為兩個 repo
- 如果需要讓別人 fork AI workflow 部分但不含個人設定 → 考慮拆分
- 如果 1 個月後體感良好 → 將狀態從「提案中」改為「已接受」
