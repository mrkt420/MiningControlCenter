@echo off
REM Check-SecurityCompliance.bat - Security and Compliance Verification Tool
REM Part of MiningControlCenter - Enterprise-Grade Security Management
REM Created: 2025-10-04 07:41:41 UTC - Professional Mining Control System
REM User: mrkt420

title Security Compliance Checker - Professional Mining Operation
color 0C

echo =========================================================
echo   Security and Compliance Verification Tool
echo =========================================================
echo.

echo [INFO] Running comprehensive security check...
echo.

REM Security Check 1: Windows Firewall Status
echo [CHECK 1] Windows Firewall Status
netsh advfirewall show allprofiles | find "State"
echo.

REM Security Check 2: Critical File Permissions
echo [CHECK 2] Critical File Permissions
if exist "TempMonitor.ps1" (
    echo [INFO] TempMonitor.ps1 found - checking permissions
    icacls "TempMonitor.ps1" | find "Everyone"
    if %ERRORLEVEL% EQU 0 (
        echo [WARN] TempMonitor.ps1 has Everyone permissions - SECURITY RISK
    ) else (
        echo [OK] TempMonitor.ps1 permissions appear secure
    )
) else (
    echo [WARN] TempMonitor.ps1 not found
)
echo.

REM Compliance Check: Required Files
echo [COMPLIANCE] Required File Structure
if exist "SECURITY-DISCLAIMER.md" (
    echo [OK] Security disclaimer present
) else (
    echo [FAIL] SECURITY-DISCLAIMER.md missing - COMPLIANCE VIOLATION
)

echo.
echo [RECOMMENDATIONS] Security Best Practices
echo ================================================
echo [1] CRITICAL: Ensure SECURITY-DISCLAIMER.md is present
echo [2] IMPORTANT: Run mining with limited privileges
echo [3] RECOMMENDED: Enable Windows Defender protection
echo [4] RECOMMENDED: Regular backup of configurations
echo.

pause
color 07
exit /b 0