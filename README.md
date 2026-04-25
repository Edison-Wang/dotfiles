# dotfiles

跨電腦同步的開發環境設定。目前管理：

- **Cursor Rules** (`cursor-rules/`) — Swift、工作流程、通用規則共 15 條

## 結構

```
dotfiles/
└── cursor-rules/
    ├── swift-*.mdc        # Swift 程式碼規範（globs 觸發）
    ├── workflow-*.mdc     # 工作流程規範（alwaysApply）
    └── general-*.mdc      # 跨語言通用規範（alwaysApply）
```

## Cursor Rules 一覽

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

### 工作流程規範（3 條）— `alwaysApply: true`，每次對話都帶入

| 檔案 | 主題 |
|---|---|
| `workflow-dev-plan.mdc` | 開發前必須有計畫，依計畫執行 |
| `workflow-git-commit.mdc` | 必須等用戶測試確認後才能 commit |
| `workflow-language.mdc` | AI 一律以繁體中文回應 |

### 通用規範（2 條）— `alwaysApply: true`，跨所有語言適用

| 檔案 | 主題 |
|---|---|
| `general-security.mdc` | secret 管理、Keychain、洩漏處理 |
| `general-comments.mdc` | 註解寫 why 不寫 what、禁止廢話註解、TODO 規範 |

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

## 日常更新

```bash
cd ~/dotfiles
git pull                  # 拉最新
# ... 編輯規則 ...
git add . && git commit -m "update: <說明>"
git push
```

## 規則作用範圍

- **全域生效**：所有 Cursor 專案都會讀到此 repo 的規則
- **專案覆蓋**：若某專案 `<project>/.cursor/rules/` 有同名檔案，會覆蓋全域版
- **swift-* 系列**：只在打開 `.swift` 檔時觸發，其他語言專案不會被干擾
- **workflow-* 與 general-***：`alwaysApply: true`，所有對話都會帶入 context

## 維護原則

- 改規則後手動 commit + push，新電腦才拿得到
- 每條規則保持單一職責，避免一個檔案塞太多主題
- 強制與選用要清楚標示，避免 AI 把選用當必加
- 廢棄條目用 git rm 移除，不要靠註解標記
