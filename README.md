# dotfiles

跨電腦同步的開發環境設定。目前管理：

- **Cursor Rules** (`cursor-rules/`) — Swift 與工作流程規則

## 結構

```
dotfiles/
└── cursor-rules/
    ├── swift-*.mdc        # Swift 程式碼規範（globs 觸發）
    └── workflow-*.mdc     # 工作流程規範（alwaysApply）
```

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

## 日常更新

```bash
cd ~/dotfiles
git pull                  # 拉最新
# ... 編輯規則 ...
git add . && git commit -m "update: <說明>"
git push
```

## Cursor Rules 規則一覽

| 檔案 | 觸發 | 用途 |
|---|---|---|
| `swift-conventions.mdc` | `*.swift` | 一般 Swift 慣例 |
| `swift-mvvm.mdc` | `*.swift` | MVVM 架構規範 |
| `swift-project-structure.mdc` | `*.swift` | 資料夾結構與導覽 |
| `swift-safety.mdc` | `*.swift` | 安全性與非同步 |
| `swift-theme.mdc` | `*.swift` | AppColors / AppFonts |
| `workflow-dev-plan.mdc` | always | 開發計畫流程 |
| `workflow-git-commit.mdc` | always | Git Commit 流程 |

## 維護

- 修改規則後記得 commit + push，新電腦才拿得到
- 專案內 `.cursor/rules/` 會覆蓋全域同名規則
