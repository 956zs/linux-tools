#!/bin/bash

# 設定變數
DEVICE=""                           # 請輸入要檢測的磁碟裝置，例如 /dev/sda, /dev/sdb
WEBHOOK_URL=""                      # 請輸入 Discord Webhook URL
REPORT_FILE="/tmp/smart_report.txt" # 報告檔案路徑 預設為 /tmp/smart_report.txt

# 檢查並安裝必要的依賴
function install_dependencies {
    if ! command -v smartctl &>/dev/null; then
        echo "smartctl 未安裝，正在安裝..."
        if [[ -x "$(command -v apt)" ]]; then
            sudo apt update && sudo apt install -y smartmontools
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install -y smartmontools
        elif [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y smartmontools
        else
            echo "無法自動安裝 smartctl，請手動安裝 smartmontools."
            exit 1
        fi
    fi

    if ! command -v curl &>/dev/null; then
        echo "curl 未安裝，正在安裝..."
        if [[ -x "$(command -v apt)" ]]; then
            sudo apt update && sudo apt install -y curl
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install -y curl
        elif [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y curl
        else
            echo "無法自動安裝 curl，請手動安裝 curl."
            exit 1
        fi
    fi

    if ! command -v whiptail &>/dev/null; then
        echo "whiptail 未安裝，正在安裝..."
        if [[ -x "$(command -v apt)" ]]; then
            sudo apt update && sudo apt install -y whiptail
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install -y newt
        elif [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y newt
        else
            echo "無法自動安裝 whiptail，請手動安裝 whiptail."
            exit 1
        fi
    fi
}

# 安裝依賴
install_dependencies

# 啟動 long self-test
echo "啟動 SMART 長時間自我檢測..."
sudo smartctl -t long "$DEVICE" >/dev/null 2>&1

# 顯示測試啟動提示
whiptail --title "SMART Test" --msgbox "開始對 $DEVICE 執行 long 測試。\n這會花約 2 小時。\n\n視窗會自動關閉，過程中會每 5 分鐘檢查一次進度。" 12 60

# 等待測試完成
echo "Checking SMART test status every 5 mins..."

while true; do
    STATUS=$(sudo smartctl -a "$DEVICE" | grep "Self-test execution status")

    if echo "$STATUS" | grep -q "Self-test routine in progress"; then
        echo "Still running... $(date)"
        sleep 300
    else
        echo "Test finished!"
        break
    fi
done

# 產生報告
sudo smartctl -a "$DEVICE" >"$REPORT_FILE"

# 檢查報告是否生成成功
if [[ ! -f "$REPORT_FILE" ]]; then
    echo "報告生成失敗，請檢查 $DEVICE 的 SMART 設定與狀態。"
    exit 1
fi

# 傳送報告到 Discord
curl -F "file=@${REPORT_FILE}" \
    -F "payload_json={\"content\": \"✅ SMART 檢測完成，報告如下：\"}" \
    "$WEBHOOK_URL"

# 顯示測試完成提示
whiptail --title "SMART Test Completed" --msgbox "測試已完成，報告已上傳至 Discord。\n\n報告位置：$REPORT_FILE" 10 60
