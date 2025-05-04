# smart-watcher.sh

`smart-watcher.sh` 是一支用於自動化執行 Linux 磁碟裝置的 SMART 長時間自我檢測（Long Self-Test）的 Bash 腳本。檢測完成後，自動產生完整報告並透過 Discord Webhook 傳送至指定頻道，以利監控與備份管理。

## 📌 功能簡介

- 自動安裝必要套件：`smartmontools`、`curl`、`whiptail`
- 對指定硬碟裝置執行 `smartctl -t long` 測試
- 每 5 分鐘輪詢一次檢查 SMART 測試進度
- 檢測完成後自動產生報告（存於 `/tmp/smart_report.txt`）
- 將報告以檔案形式上傳至 Discord webhook
- 使用 `whiptail` 顯示圖形化提示訊息

---

## 📁 檔案位置

```

linux-tools/
└── disk/
    └── smart-watcher.sh

````

---

## ⚙️ 系統需求

- Linux 發行版（支援 `apt`, `yum`, 或 `dnf` 的任一套件管理工具）
- 權限：需要 sudo 權限以執行 smartctl
- 可用網路連線（上傳報告至 Discord）

---

## 🛠 安裝與設定

### 1. 下載腳本

```bash
git clone https://github.com/956zs/linux-tools.git
cd linux-tools/disk
````

### 2. 設定變數

打開 `smart-watcher.sh`，根據實際硬碟裝置與 Discord webhook 修改下列變數：

```bash
DEVICE="/dev/sdb"      # 目標硬碟裝置
WEBHOOK_URL="https://discord.com/api/webhooks/..."  # 你的 Discord webhook URL
```

---

## 🚀 執行方式

建議在 `tmux` 中執行，避免 SSH 中斷導致腳本終止。

```bash
tmux new -s smart-test
./smart-watcher.sh
```

離開 tmux：
`Ctrl + b` → `d`

重新連接 tmux：

```bash
tmux attach -t smart-test
```

---

## 🧾 腳本執行流程

1. 檢查並安裝 `smartctl`、`curl`、`whiptail`
2. 使用 `smartctl -t long` 對指定裝置啟動 SMART 長時間檢測
3. 使用 `whiptail` 顯示開始測試提示
4. 每 5 分鐘檢查一次測試狀態，直到完成
5. 產出報告並儲存為 `/tmp/smart_report.txt`
6. 使用 Discord Webhook 傳送通知與報告檔案
7. 顯示完成提示訊息

---

## 📝 報告範例

產出格式為標準 `smartctl -a` 輸出內容，包含以下資訊：

* 硬碟基本資訊（型號、序號、介面等）
* 健康指標（Reallocated Sectors Count, Pending Sectors 等）
* 測試結果與狀態（Completed without error / errors）

報告檔案範例位置：

```
/tmp/smart_report.txt
```

---

## 📤 Discord 通知格式

通知內容固定為：

```
✅ SMART 檢測完成，報告如下：
```

報告以 `.txt` 檔案方式作為附件上傳。

---

## 📌 備註

* 測試過程中可自由離開 tmux，背景將繼續執行
* 若 `smartctl` 無法辨識目標裝置，請確認 `DEVICE` 變數設置正確
* 測試時間依硬碟大小與品牌而異，約需 1\~2 小時

---

## 🔒 安全性建議

* 請勿將 Discord Webhook URL 公開於網路上
* 若要長期部署，建議將 webhook URL 改為讀取環境變數或使用 `.env` 檔案管理

---

## 📦 未來規劃

* 支援多顆硬碟同時檢測
* 將報告內容進行分析並標註異常
* 整合 crontab 定期執行
* 發布為 systemd service

---

## 🧑‍💻 作者

此工具由 [956zs](https://github.com/956zs) 開發與維護。
若有功能建議或問題回報，歡迎透過 GitHub Issues 或發 PR 參與貢獻。
