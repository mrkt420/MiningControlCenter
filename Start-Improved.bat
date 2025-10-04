@echo off
REM Start-Improved.bat - Enhanced Mining Startup Script
REM Part of MiningControlCenter - Enterprise-Grade Mining Control
REM Created: 2025-01-10 12:54:32 UTC - Professional Mining Control System
REM User: mrkt420

title Professional Mining Startup - Enhanced Control System
color 0E

echo =========================================================
echo   Professional Mining Startup - Enhanced Control
echo =========================================================
echo.

REM Check Administrator privileges
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Administrator privileges required for mining operations!
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

echo [INFO] Administrator privileges confirmed
echo.

REM System requirements check
echo [INFO] Checking system requirements...
for /f "tokens=2 delims==" %%i in ('wmic OS get TotalVisibleMemorySize /value') do set TOTAL_MEMORY=%%i
set /a MEMORY_GB=%TOTAL_MEMORY%/1048576
echo [INFO] Total system memory: %MEMORY_GB% GB

REM Check GPU availability
echo [INFO] Checking GPU availability...
nvidia-smi >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [INFO] NVIDIA GPU detected
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
) else (
    echo [INFO] NVIDIA drivers not detected, checking for AMD...
)

REM Create necessary directories
echo [INFO] Creating mining directories...
if not exist "logs" mkdir logs
if not exist "backup" mkdir backup
if not exist "web\data" mkdir "web\data"

echo.
echo Mining startup options:
echo [1] Start XMRig (Monero CPU Mining)
echo [2] Start T-Rex (NVIDIA GPU Mining) 
echo [3] Start SRBMiner (Multi-Algorithm)
echo [4] Start TeamRedMiner (AMD GPU Mining)
echo [5] Configure Mining Settings
echo [6] Exit
echo.
set /p choice="Select mining option (1-6): "

if "%choice%"=="1" goto :start_xmrig
if "%choice%"=="2" goto :start_trex
if "%choice%"=="6" goto :exit

:start_xmrig
echo [INFO] Starting XMRig CPU Mining...
if exist "miners\xmrig\xmrig.exe" (
    start "XMRig" miners\xmrig\xmrig.exe
    echo [SUCCESS] XMRig started successfully
) else (
    echo [ERROR] XMRig not found
)
pause
goto :exit

:start_trex
echo [INFO] Starting T-Rex GPU Mining...
if exist "miners\t-rex\t-rex.exe" (
    start "T-Rex" miners\t-rex\t-rex.exe
    echo [SUCCESS] T-Rex started successfully
) else (
    echo [ERROR] T-Rex not found
)
pause
goto :exit

:exit
echo [INFO] Enhanced Mining Startup completed
color 07
exit /b 0