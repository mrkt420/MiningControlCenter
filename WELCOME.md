Mining Control Center Setup: Step-by-Step
1. What You’re Building
A complete mining management suite for Windows:
Monitors your mining software (XMRig, T-Rex, etc.)
Tracks temperature and auto-stops if it gets too hot
Lets you set a mining schedule (mine only at low electricity rates)
Gives you a web dashboard to monitor everything
Easy installer and one-click start

2. What You Need
A Windows PC (Windows 10/11 recommended)
Admin rights (for setup and running scripts)
Node.js installed
XMRig and T-Rex miners downloaded
LibreHardwareMonitor for best temperature readings

4. Create the Folder Structure
Open Windows Explorer
Go to C:\ and create a new folder called MiningControlCenter
Inside it, create these subfolders:logs, status, web, web\public, web\src, guides

5. Add the Files
Use Notepad or VS Code to create each file:
Place the provided code from earlier for each file (for example, config.json, Installer.bat, etc.)
Save the files in their correct locations (for example, Scheduler.ps1 goes in the root, mining_control_center.tsx goes in web\src, etc.)

7. Install Dependencies
A. Node.js & npm
Download and install Node.js LTS
Open Command Prompt and verify install:
Code
node --version
npm --version

B. Express and CORS for Web Server
In Command Prompt, go to the web folder:
Code
cd C:\MiningControlCenter\web
npm init -y
npm install express cors

9. Download Mining Software
XMRig: Download here
T-Rex: Download here
Place their executables at the paths specified in your config.json.

10. Download LibreHardwareMonitor
Download LibreHardwareMonitor
Extract and run LibreHardwareMonitor.exe (leave running for temperature readings)
11. Enable Miner APIs (Required for Dashboard/Auto Control)
XMRig: In its config, ensure:
JSON
"http": {
  "enabled": true,
  "port": 16000
}
Or launch with:
Code
xmrig.exe --http-enabled --http-port=16000
T-Rex: In its config, ensure:
Code
"api-bind-http": "0.0.0.0:4067"
Or launch with:
Code
t-rex.exe -a kawpow --api-bind-http 0.0.0.0:4067
12. Run the Installer
Go to C:\MiningControlCenter
Right-click Installer.bat and choose "Run as Administrator"
Follow the prompts (if any) to set up config and scripts
13. Launch Everything
Double-click Start.bat to start backend + dashboard
Or use StartBackend.bat and StartDashboard.bat separately
14. Open Your Dashboard
Open your browser and go to:
Code
http://localhost:8090
You should see your Mining Control Center dashboard
15. Monitor & Control
The dashboard will show:
Miner status (running/stopped, hashrate, temperature)
Alerts if temperatures are too high
Schedule info (if you set it up)
Pool statistics (if configured)
16. Troubleshooting
Run scripts as Administrator
Make sure LibreHardwareMonitor is running for temp readings
Check logs in C:\MiningControlCenter\logs\ if miners aren’t starting
Review guides in guides/ for more help
Recap: What to Do Right Now
Create folders as above
Copy/paste example files into place
Install Node.js and miners
Run Installer.bat as Admin
Start the suite with Start.bat
Open your browser to http://localhost:8090
