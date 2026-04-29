# Codebase Onboarding（接手陌生專案分析）

## 最佳工具

- **Cursor Ask 模式 + explore subagent**（看得到檔案系統，唯讀，最安全）
- 不要用 Agent 模式（這是分析，不需要改檔）
- 不要走自主迴圈（那是開發用，不是探索用）

## 使用時機

- 接手別人寫的 / 外包遺留的專案
- 很久沒碰、要回去維護的舊專案
- 評估「要不要接這個案子」之前先做健康檢查
- 大型 PR 要 review 前，先理解整個 codebase 上下文

## 不適用

- 自己親手寫的專案（直接用 `workflows/cross-model-review.md` 找盲點）
- 極小專案（< 20 檔案，直接讀 README + 主檔即可）
- 純 config / 文檔 repo（沒什麼好 onboarding 的）

## Prompt

```
請對這個專案做完整的接手分析。優先用 explore subagent 平行探索不同面向。

請依下列七個面向產出報告（用 Markdown 結構化）：

## 1. 專案概要
- 這個專案做什麼（一段話，白話）
- 主要使用者 / 業務領域猜測
- 程式碼規模（檔案數、行數估算、git 歷史長度）
- 開發活躍度（看 git log 最近 commit 頻率、最後活動時間）

## 2. 技術棧
依語言 / 框架調整，但至少要回答：
- 主語言 + 版本（看 package.json / Package.swift / go.mod / requirements.txt）
- 框架 + 版本
- 建置 / 打包工具
- 套件管理器
- 狀態管理 / 資料層
- 測試框架
- Lint / Format 工具
- CI / CD（看 .github/workflows、.gitlab-ci 等）
- 部署目標（雲端 / 本地 / app store）

## 3. 架構
- 資料夾結構策略（feature-based / layer-based / domain-based）
- 模組劃分（核心 / 共用 / utils）
- 進入點在哪
- 對外介面（API / CLI / GUI）怎麼組織
- 全域狀態 / 設定怎麼管理
- 跨層通訊方式

## 4. 程式碼慣例與品質
- 命名慣例（檔名、變數、函式）
- 抽象風格（OOP / FP / 混用）
- 型別覆蓋率粗估（如果是有型別的語言）
- 測試覆蓋率粗估（看 test/ 目錄密度 vs src/）
- 註解 / 文檔密度
- Lint 設定嚴格度

## 5. 技術債與風險（最重要，不要省略）
- 三個最嚴重的技術債（具體指出檔案 / 模組 / 行號）
- 過時 / 有漏洞的依賴（看 lockfile + 對照 deprecation）
- 反模式（巨大檔案、深層巢狀、重複代碼、any/Object 滿天飛、神類別）
- 安全顧慮（暴露的 key、缺少驗證、SQL injection、XSS、不安全的 deserialize）
- 測試 / 文檔的明顯缺口

## 6. 進入順序（onboarding path）
- 我應該先讀哪三個檔案來理解整體架構
- 我應該先跑哪個指令看效果（npm run dev / make / xcodebuild...）
- 哪個模組是「核心商業邏輯」必須懂
- 哪個模組可以「先不碰」（例如成熟穩定的工具層）
- 有沒有任何「禁區」（容易炸的、改了會牽連很多的）

## 7. 給新接手者的 5 個立即建議
- 具體、可執行、排優先級
- 例如「跑 X 看看是否能 build」「修 Y 處明顯 bug 熱身」「先不要動 Z 系統」

## 限制
- 不要美化、不要 sugar-coat。看到爛代碼直接說
- 不要修任何檔案（你在 Ask 模式）
- 找不到資訊就說「找不到」，不要猜
- 引用代碼時附上檔案路徑 + 行號
```

## 進階：跨模型驗證

如果這專案是要長期維護或商業重要，加一步：

1. 把 Cursor 產出的分析貼到 **Claude Project「System Architect」**
2. 問：
   ```
   這是某 [語言/框架] 專案的接手分析，請從架構師視角找出：
   - 分析中可能的盲點
   - 沒提到但應該注意的事
   - 哪些建議的優先級可能排錯
   - 從架構角度看最該擔心什麼
   ```
3. 把兩份合併成最終接手報告

## 變體（依語言調整重點）

### React / Vue / Angular 前端
額外問：bundle size、SSR/CSR/SSG 策略、SEO、a11y、響應式斷點、瀏覽器相容、CSP 設定

### Node.js / Python / Go 後端
額外問：DB schema 演進策略、API 版本、auth flow、observability（logs/metrics/traces）、scaling 假設

### iOS / Android Native
額外問：最低支援版本、SPM/Cocoapods/Gradle 套件數、UIKit vs SwiftUI 比例、deprecated API 使用、權限聲明

### 全端 / monorepo
額外問：workspace 工具（pnpm/turbo/nx）、套件邊界、共用型別策略、CI 平行化

### CLI / library 專案
額外問：API 穩定性承諾（semver 嚴格度）、文檔覆蓋、breaking change 歷史

## 完成後

把報告存下來：

```
把上面的分析存到 docs/onboarding-analysis.md（或你習慣的位置）
```

存成檔案的價值：
- 一個月後忘了當時的判斷，可以回去看
- 跟團隊分享時直接給連結
- 之後做 refactor 計畫時當輸入

## 品質檢查（產出後自我驗收）

- ❌ 「技術債」是空的 → 要嘛專案完美（罕見），要嘛分析太淺，請 AI 重做
- ❌ 「進入順序」只列檔案沒講「為什麼先讀這個」 → 沒做到 onboarding 的本質
- ❌ 沒有任何檔案路徑 / 行號引用 → 太抽象，沒有可操作性
- ❌ 「立即建議」全部是「建議重構整個專案」這類大話 → 失敗，要可執行小步
- ✅ 看完報告後你能說出「我接下來這週要做的三件事」 → 成功
