# Stage 7: Deployer（部署）

## 最佳工具
- Cursor deployer subagent（執行）
- 每個不可逆步驟都要人工確認

## 核心原則

**Beta 可以自動。Production 永遠需要人按按鈕。**

## Cursor 呼叫（Beta / Staging）

```
@deployer 準備 staging 部署，對應本次改動。

流程：
1. 確認所有測試通過。
2. 依專案慣例 bump version。
3. 從 git log 產生 release notes。
4. 建置 artifact。
5. 上傳到 staging 環境。
6. 停下來。等我驗證 staging 後才做任何 production 動作。
```

## Cursor 呼叫（Production）

```
@deployer 準備 production release v[版本號]。

流程：
1. 確認 staging 已驗證通過（我會確認）。
2. 確認 release branch 乾淨且已打 tag。
3. 跑 pre-flight 檢查（smoke test、dependency audit）。
4. 產生 release artifact。
5. 停在 submit 步驟之前。我會手動觸發最終部署。
```

## iOS 特別注意

- TestFlight 上傳可由 agent 執行（`fastlane beta`）
- App Store 送審按鈕**永遠由人按**（`submit_for_review: false`）
- Code signing 問題在本機處理，不丟給 cloud agent
