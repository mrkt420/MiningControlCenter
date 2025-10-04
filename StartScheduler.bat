@echo off
REM StartScheduler.bat - Smart Mining Scheduler Launcher
REM Part of MiningControlCenter - Enterprise-Grade Cost Optimization
REM Created: 2025-10-04 07:41:41 UTC - Professional Mining Control System
REM User: mrkt420

title Smart Mining Scheduler - Electricity Cost Optimization
color 0D

echo =========================================================
echo   Smart Mining Scheduler - Cost Optimization System
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

echo Choose scheduler operation:
echo.
echo [1] Start Smart Scheduling (Auto Mode)
echo [2] Configure Electricity Rates
echo [3] View Current Schedule
echo [4] Force Start Mining Now
echo [5] Force Stop Mining Now
echo [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto :start_scheduler
if "%choice%"=="6" goto :exit

:start_scheduler
echo.
echo [INFO] Starting Smart Mining Scheduler...
if exist "MiningScheduler.ps1" (
    powershell -File "MiningScheduler.ps1"
) else (
    echo [ERROR] MiningScheduler.ps1 not found
)
pause
goto :exit

:exit
echo.
echo [INFO] Smart Mining Scheduler finished
color 07
exit /b 0