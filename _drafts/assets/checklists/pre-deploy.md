# 部署前 Checklist

部署到任何環境（含 staging）之前：

- [ ] 所有自動化測試通過
- [ ] Code review 完成且 finding 已處理
- [ ] Migration（如有）可回滾
- [ ] Rollback 計畫已記錄
- [ ] Monitoring / alerting 覆蓋新代碼路徑
- [ ] Feature flag（如漸進式上線）已就位
- [ ] Release notes 已寫
- [ ] 利害關係人知道要上線了

僅限 Production（額外）：

- [ ] Staging 已由人類驗證過（不只是測試）
- [ ] 客戶溝通已準備（如適用）
- [ ] On-call 已知悉
- [ ] Rollback 在 staging 演練過至少一次
- [ ] 不在週末或假日前 N 小時內部署
