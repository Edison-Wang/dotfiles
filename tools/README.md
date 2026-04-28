# tools/

各 AI 工具的配置說明與設定步驟。

| 子目錄 | 用途 |
|--------|------|
| `claude/projects/` | Claude Project 的 Custom Instructions |
| `chatgpt/custom-gpts/` | ChatGPT Custom GPT 配置 |
| `gemini/` | NotebookLM 與 Deep Research 使用指南 |
| `cursor/agents/` | Cursor Subagent 定義（部署到專案的 `.cursor/agents/`） |
| `cursor/commands/` | Cursor 自定義指令 |

## 與 cursor-rules/ 的關係

`cursor-rules/` 是全域 Cursor 規則，透過 symlink 部署到 `~/.cursor/rules/`。
`tools/cursor/agents/` 和 `tools/cursor/commands/` 是專案級模板，需要複製到各專案的 `.cursor/` 目錄。

## 啟用狀態

目前所有 `tools/` 子目錄都是空的（具體配置都在 `_drafts/tools/`）。等實戰需要設定 Claude Project、Custom GPT、Cursor subagent 時再啟用對應檔案。
