@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo This script requires administrator privileges. Please run as administrator.
    exit /b
)

:: Check if PowerShell is enabled
powershell.exe -command "exit" >nul 2>&1
if %errorLevel% NEQ 0 (
    echo PowerShell execution is disabled. Please enable it.
    exit /b
)

:: Validate TempMonitor.ps1 existence
if not exist "TempMonitor.ps1" (
    echo TempMonitor.ps1 not found. Please ensure it is in the same directory as this script.
    exit /b
)

:menu
cls
echo Temperature Monitoring System
echo.
echo 1. Start Monitoring
echo 2. Install Windows Service
echo 3. Manage Service State
echo 4. View Configuration
echo 5. Exit
echo.
set /p choice="Select an option (1-5): "

if "%choice%"=="1" (
    call powershell.exe -ExecutionPolicy Bypass -File TempMonitor.ps1
    goto menu
) else if "%choice%"=="2" (
    echo Installing Windows Service...
    :: Add installation logic here
    goto menu
) else if "%choice%"=="3" (
    echo Managing Service State...
    :: Add service management logic here
    goto menu
) else if "%choice%"=="4" (
    echo Viewing Configuration...
    :: Add configuration viewing logic here
    goto menu
) else if "%choice%"=="5" (
    exit /b
) else (
    echo Invalid option. Please try again.
    goto menu
)

ENDLOCAL
