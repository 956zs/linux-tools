# Scripts Collection

A growing collection of useful system administration and monitoring scripts.

## SMART-Watcher

A robust disk health monitoring utility that automates SMART tests and sends reports to Discord.

### Features

- **Automated SMART Testing**: Runs long SMART self-tests on storage devices
- **Cross-Distribution Compatibility**: Works on Debian, Ubuntu, RHEL, Fedora, and other Linux distributions
- **User-Friendly Notifications**: Uses whiptail for graphical notifications during test progress
- **Discord Integration**: Automatically uploads test reports to a Discord webhook
- **Dependency Management**: Automatically installs required tools if missing

### Requirements

- Linux system with root/sudo access
- One of the following package managers: apt, yum, or dnf
- Internet connection for Discord webhook notifications

### Installation

1. Clone the repository or download the script:
   ```bash
   git clone https://github.com/956zs/linux-tools.git
   cd linux-tools/disk
   ```

2. Make the script executable:
   ```bash
   chmod +x smart-watcher.sh
   ```

### Configuration

Edit the script to customize these variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DEVICE` | Target storage device to test | `/dev/sda` |
| `WEBHOOK_URL` | Discord webhook URL for notifications | Discord URL (replace with yours) |
| `REPORT_FILE` | Location to save the SMART report | `/tmp/smart_report.txt` |

### Usage

Run the script with sudo permissions:

```bashs
sudo ./smart-watcher.sh
```

The script will:
1. Install any missing dependencies (smartmontools, curl, whiptail)
2. Initiate a long SMART self-test on the specified device
3. Check test progress every 5 minutes
4. Generate a comprehensive SMART report when complete
5. Upload the report to Discord
6. Display a completion notification

### Extending SMART-Watcher

#### Monitoring Additional Devices

To monitor multiple drives, modify the script to loop through devices:

```bash
DEVICES=("/dev/sda" "/dev/sdb" "/dev/nvme0n1")

for DEVICE in "${DEVICES[@]}"; do
    # Existing script logic
done
```

#### Adding Email Notifications

Extend functionality by implementing email notifications:

```bash
# Add to configuration section
EMAIL="your-email@example.com"

# Add after Discord notification
if command -v mail &>/dev/null; then
    cat "$REPORT_FILE" | mail -s "SMART Test Results for $DEVICE" "$EMAIL"
fi
```

## Future Scripts (Coming Soon)

This repository will grow to include more useful administrative and monitoring scripts, including:

- **Log-Analyzer**: Automated system log analysis and alert generation
- **Backup-Manager**: Scheduled backup creation with rotation and verification
- **Network-Monitor**: Network performance tracking and issue detection
- **Update-Helper**: Safe system update automation with rollback capability

## Contributing

Contributions to expand this script collection are welcome! Please follow these guidelines:

1. Create a descriptive branch name
2. Follow the existing code style
3. Include comprehensive documentation
4. Ensure cross-distribution compatibility where possible

## License

MIT
