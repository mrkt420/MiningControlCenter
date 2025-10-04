Mining Control Center – Full Setup Guide
1. Prerequisites
Windows 10 or newer
Administrator privileges
Node.js (LTS)
XMRig, T-Rex miner binaries
LibreHardwareMonitor (for temp monitoring)
2. Folder and File Structure
Extract everything to:

C:\MiningControlCenter
├── Installer.bat
├── Start.bat
├── StartBackend.bat
├── StartDashboard.bat
├── Scheduler.ps1
├── TempMonitor.ps1
├── WatchdogService.ps1
├── config.json
├── logs\
├── status\
├── web\
│   ├── server.js
│   ├── package.json
│   ├── public\index.html
│   └── src\
│       ├── mining_control_center.tsx
│       ├── temp_dashboard.tsx
│       └── pool_stats_dashboard.tsx
└── guides\
    ├── SETUP.md
    ├── api_integration_guide.md
    └── mining_quick_reference.md
3. Install Node.js and Dependencies
Download and install Node.js.
Open Command Prompt, then:
cd C:\MiningControlCenter\web
npm init -y
npm install express cors
4. Miner and Sensor Setup
Download XMRig and T-Rex, place their executables as per config.json.
Download and extract LibreHardwareMonitor. Run LibreHardwareMonitor.exe (leave running).
5. Configure Miners for API
XMRig:
In your config, add:

"http": { "enabled": true, "port": 16000 }
Or launch with:

xmrig.exe --http-enabled --http-port=16000
T-Rex:
In config:

"api-bind-http": "0.0.0.0:4067"
Or launch with:

t-rex.exe -a kawpow --api-bind-http 0.0.0.0:4067
6. Run the Installer
Right-click Installer.bat → Run as Administrator
Follow prompts for miner paths, wallets, pools, and temp thresholds.
7. Start the System
Double-click Start.bat to launch backend and dashboard.
Or use StartBackend.bat and StartDashboard.bat individually.
8. Access the Dashboard
Open browser to http://localhost:8090
You should see your mining stats, temperature, and controls.
9. Troubleshooting
Run everything as Administrator
If temperatures do not show, check LibreHardwareMonitor is running
Check logs in logs/ for errors
Use mining_quick_reference.md for emergency commands and fixes
10. Advanced
See api_integration_guide.md for connecting custom APIs, pools, and wallet stats.
Adjust scheduling and temperature limits in config.json or via Scheduler.ps1.
Enjoy safe, automated mining!
