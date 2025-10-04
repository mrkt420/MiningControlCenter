@echo off
REM Stop-Improved.bat - Safe Mining Shutdown Script
REM Part of MiningControlCenter - Enterprise-Grade Mining Control
REM Created: 2025-01-10 12:54:32 UTC - Professional Mining Control System
REM User: mrkt420

title Professional Mining Shutdown - Safe Process Termination
color 0C

echo =========================================================
echo   Professional Mining Shutdown - Safe Termination
echo =========================================================
echo.

echo [INFO] Initiating safe mining shutdown sequence...
echo [INFO] This will gracefully stop all mining processes
echo.

REM Safe termination of mining processes
echo [INFO] Stopping XMRig...
taskkill /IM "xmrig.exe" /T >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] XMRig stopped
) else (
    echo [INFO] XMRig not running
)

echo [INFO] Stopping T-Rex...
taskkill /IM "t-rex.exe" /T >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] T-Rex stopped
) else (
    echo [INFO] T-Rex not running
)

echo [INFO] Stopping SRBMiner...
taskkill /IM "srbminer-multi.exe" /T >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] SRBMiner stopped
) else (
    echo [INFO] SRBMiner not running
)

echo [INFO] Stopping TeamRedMiner...
taskkill /IM "teamredminer.exe" /T >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] TeamRedMiner stopped
) else (
    echo [INFO] TeamRedMiner not running
)

echo.
echo [SUCCESS] All mining processes stopped safely
echo [INFO] Mining shutdown completed
echo.

pause
color 07
exit /b 0