Mining Control Center
Mining Control Center is a complete Windows suite for automated crypto mining management. It includes watchdog monitoring, temperature protection, smart scheduling, and a real-time web dashboard.

🚀 Features
Automated miner restart and crash recovery
Temperature monitoring with auto-shutdown and alerts
Schedule mining for off-peak electricity rates
Web dashboard for live stats and remote monitoring
Pool stats for XMRig and T-Rex miners
Easy one-click installer and batch launchers
🛠️ Quick Installation
Download or clone this repository.
Extract to C:\MiningControlCenter.
Run Installer.bat as Administrator.
Follow prompts to configure miners, wallets, and temperature limits.
Start all systems with Start.bat.
For full instructions, see SETUP.md.

⚡ Requirements
Windows 10/11
Node.js (LTS)
XMRig and T-Rex
LibreHardwareMonitor for temperature sensors
📊 Dashboard
After starting, open http://localhost:8090 in your browser.
Monitor your mining stats, temperature, and profits in real time.
🔧 Troubleshooting
Run all scripts as Administrator.
If temps do not show, run LibreHardwareMonitor.exe.
Review logs in C:\MiningControlCenter\logs\
See SETUP.md for advanced setup and troubleshooting.
📂 Folder Structure
C:\MiningControlCenter
├── Installer.bat           # Main installer wizard
├── Start.bat               # Unified launcher
├── StartBackend.bat        # Backend service launcher
├── StartDashboard.bat      # Web dashboard launcher
├── Scheduler.ps1           # Mining scheduler
├── TempMonitor.ps1         # Temperature alert system
├── WatchdogService.ps1     # Watchdog service
├── config.json             # Main configuration file
├── logs/                   # Miner and monitor logs
├── status/                 # JSON status files for dashboard
├── web/                    # Node.js/React dashboard
└── guides/                 # Setup, API, and troubleshooting docs
💡 Support
Issues
See setup guide for community help and troubleshooting tips.
Mine responsibly, monitor constantly, and stay profitable!
