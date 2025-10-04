@echo off
REM StartWatchdog.bat - Professional Watchdog Service Launcher
REM Part of MiningControlCenter - Enterprise-Grade Mining Reliability
REM Created: 2025-10-04 07:08:38 UTC - Professional Mining Control System
REM User: mrkt420

title Mining Watchdog Service - Professional 24/7 Process Monitoring
color 0B

echo =========================================================
echo   Mining Watchdog Service - 24/7 Process Monitoring  
echo =========================================================
echo.

REM Check Administrator privileges
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Administrator privileges required!
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

echo [INFO] Administrator privileges confirmed
echo.

REM Verify WatchdogService.ps1 exists
if not exist "WatchdogService.ps1" (
    echo [ERROR] WatchdogService.ps1 not found!
    pause
    exit /b 1
)

echo [INFO] WatchdogService.ps1 found
echo.

:main_menu
echo Choose watchdog operation:
echo.
echo [1] Start Interactive Watchdog Monitoring
echo [2] Install Watchdog as Windows Service
echo [3] Start Watchdog Service
echo [4] Stop Watchdog Service
echo [5] View Service Status
echo [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto :interactive
if "%choice%"=="2" goto :install_service
if "%choice%"=="3" goto :start_service
if "%choice%"=="4" goto :stop_service
if "%choice%"=="5" goto :view_status
if "%choice%"=="6" goto :exit

:interactive
echo.
echo [INFO] Starting Interactive Watchdog Monitoring...
powershell -File "WatchdogService.ps1"
pause
goto :main_menu

:install_service
echo.
echo [INFO] Installing Mining Watchdog Windows Service...
powershell -File "WatchdogService.ps1" -Install
pause
goto :main_menu

:start_service
echo.
echo [INFO] Starting Mining Watchdog Service...
sc start MiningWatchdog
pause
goto :main_menu

:stop_service
echo.
echo [INFO] Stopping Mining Watchdog Service...
sc stop MiningWatchdog
pause
goto :main_menu

:view_status
echo.
echo [INFO] Mining Watchdog Service Status
sc query MiningWatchdog
pause
goto :main_menu

:exit
echo.
echo [INFO] Mining Watchdog Launcher finished
color 07
exit /b 0