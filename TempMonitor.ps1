# TempMonitor.ps1 - Professional Temperature Monitoring System
# Part of MiningControlCenter - Enterprise-Grade Mining Safety
# Created: 2025-10-04 - Professional Mining Control System
# User: mrkt420

param(
    [string]$ConfigPath = "config-temperature.json",
    [switch]$Service,
    [switch]$Install,
    [switch]$Uninstall
)

# Load configuration
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
} else {
    Write-Host "Creating default temperature configuration..." -ForegroundColor Yellow
    $Config = @{
        thresholds = @{
            warning_cpu = 80
            critical_cpu = 90
            warning_gpu = 85
            critical_gpu = 95
            check_interval = 5
        }
        actions = @{
            warning_alert = $true
            critical_shutdown = $true
            email_notifications = $false
            desktop_notifications = $true
        }
        email = @{
            smtp_server = "smtp.gmail.com"
            smtp_port = 587
            username = ""
            password = ""
            to_address = ""
        }
        logging = @{
            enabled = $true
            log_file = "logs/temperature.log"
            max_log_size = 10485760
            retention_days = 30
        }
    }
    $Config | ConvertTo-Json -Depth 10 | Out-File $ConfigPath
}

# Ensure logs directory exists
$LogDir = Split-Path $Config.logging.log_file -Parent
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# Logging function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    if ($Config.logging.enabled) {
        $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $LogEntry = "[$Timestamp] [$Level] $Message"
        Add-Content -Path $Config.logging.log_file -Value $LogEntry
        
        # Rotate logs if needed
        if ((Get-Item $Config.logging.log_file).Length -gt $Config.logging.max_log_size) {
            $BackupFile = $Config.logging.log_file -replace '\.log$','_$(Get-Date -Format 'yyyyMMdd_HHmmss').log'
            Move-Item $Config.logging.log_file $BackupFile
        }
    }
    Write-Host "[$Level] $Message" -ForegroundColor $(if($Level -eq "ERROR"){"Red"} elseif($Level -eq "WARN"){"Yellow"} else{"Green"})
}

# Get CPU temperature
function Get-CPUTemperature {
    try {
        $temps = Get-WmiObject -Namespace "root/OpenHardwareMonitor" -Class Sensor | Where-Object {$_.SensorType -eq "Temperature" -and $_.Name -like "*CPU*"}
        if ($temps) {
            return ($temps | Measure-Object -Property Value -Maximum).Maximum
        }
        
        # Fallback to WMI thermal zone
        $thermal = Get-WmiObject -Namespace "root/wmi" -Class MSAcpi_ThermalZoneTemperature
        if ($thermal) {
            return [math]::Round(($thermal.CurrentTemperature / 10) - 273.15, 1)
        }
        
        return $null
    } catch {
        Write-Log "Error getting CPU temperature: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Get GPU temperatures
function Get-GPUTemperatures {
    $gpuTemps = @()
    
    try {
        # NVIDIA GPU temperatures
        $nvidiaTemps = nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>$null
        if ($nvidiaTemps) {
            $nvidiaTemps | ForEach-Object {
                $gpuTemps += [PSCustomObject]@{
                    Name = "NVIDIA GPU $($gpuTemps.Count + 1)"
                    Temperature = [int]$_
                    Type = "NVIDIA"
                }
            }
        }
        
        # AMD GPU temperatures via WMI
        $amdTemps = Get-WmiObject -Namespace "root/OpenHardwareMonitor" -Class Sensor | Where-Object {$_.SensorType -eq "Temperature" -and $_.Name -like "*GPU*"}
        $amdTemps | ForEach-Object {
            $gpuTemps += [PSCustomObject]@{
                Name = $_.Name
                Temperature = [math]::Round($_.Value, 1)
                Type = "AMD"
            }
        }
        
    } catch {
        Write-Log "Error getting GPU temperatures: $($_.Exception.Message)" "ERROR"
    }
    
    return $gpuTemps
}

# Send email notification
function Send-EmailAlert {
    param([string]$Subject, [string]$Body)
    
    if (-not $Config.actions.email_notifications -or -not $Config.email.username) {
        return
    }
    
    try {
        $SecurePassword = ConvertTo-SecureString $Config.email.password -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential($Config.email.username, $SecurePassword)
        
        Send-MailMessage -SmtpServer $Config.email.smtp_server -Port $Config.email.smtp_port -UseSsl -Credential $Credential -From $Config.email.username -To $Config.email.to_address -Subject $Subject -Body $Body
        Write-Log "Email alert sent: $Subject" "INFO"
    } catch {
        Write-Log "Failed to send email alert: $($_.Exception.Message)" "ERROR"
    }
}

# Send desktop notification
function Send-DesktopAlert {
    param([string]$Title, [string]$Message, [string]$Type = "Warning")
    
    if (-not $Config.actions.desktop_notifications) {
        return
    }
    
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $icon = [System.Windows.Forms.ToolTipIcon]::Warning
        if ($Type -eq "Critical") { $icon = [System.Windows.Forms.ToolTipIcon]::Error }
        
        $notification = New-Object System.Windows.Forms.NotifyIcon
        $notification.Icon = [System.Drawing.SystemIcons]::Warning
        $notification.BalloonTipTitle = $Title
        $notification.BalloonTipText = $Message
        $notification.BalloonTipIcon = $icon
        $notification.Visible = $true
        $notification.ShowBalloonTip(5000)
        
        Start-Sleep -Seconds 6
        $notification.Dispose()
    } catch {
        Write-Log "Failed to send desktop notification: $($_.Exception.Message)" "ERROR"
    }
}

# Stop mining processes
function Stop-MiningProcesses {
    Write-Log "CRITICAL TEMPERATURE REACHED - Stopping mining processes" "ERROR"
    
    $miners = @("xmrig", "t-rex", "srbminer", "teamredminer", "lolminer", "gminer", "nbminer")
    
    foreach ($miner in $miners) {
        $processes = Get-Process -Name $miner -ErrorAction SilentlyContinue
        foreach ($process in $processes) {
            try {
                $process.Kill()
                Write-Log "Stopped miner process: $($process.Name) (PID: $($process.Id))" "WARN"
            } catch {
                Write-Log "Failed to stop process $($process.Name): $($_.Exception.Message)" "ERROR"
            }
        }
    }
    
    # Send critical alerts
    Send-DesktopAlert -Title "MINING EMERGENCY SHUTDOWN" -Message "Critical temperatures detected! Mining stopped to prevent hardware damage." -Type "Critical"
    Send-EmailAlert -Subject "CRITICAL: Mining Emergency Shutdown" -Body "Critical temperatures detected on mining rig. All miners have been stopped to prevent hardware damage. Please check cooling systems immediately."
}

# Main monitoring loop
function Start-TemperatureMonitoring {
    Write-Log "Starting temperature monitoring service..." "INFO"
    Write-Log "Configuration: Warning CPU: $($Config.thresholds.warning_cpu)°C, Critical CPU: $($Config.thresholds.critical_cpu)°C" "INFO"
    Write-Log "Configuration: Warning GPU: $($Config.thresholds.warning_gpu)°C, Critical GPU: $($Config.thresholds.critical_gpu)°C" "INFO"
    
    $emergencyShutdownTriggered = $false
    $lastWarningTime = @{}
    
    while ($true) {
        try {
            # Check CPU temperature
            $cpuTemp = Get-CPUTemperature
            if ($cpuTemp) {
                Write-Log "CPU Temperature: $cpuTemp°C" "INFO"
                
                if ($cpuTemp -ge $Config.thresholds.critical_cpu -and $Config.actions.critical_shutdown) {
                    if (-not $emergencyShutdownTriggered) {
                        $emergencyShutdownTriggered = $true
                        Stop-MiningProcesses
                    }
                } elseif ($cpuTemp -ge $Config.thresholds.warning_cpu -and $Config.actions.warning_alert) {
                    $now = Get-Date
                    if (-not $lastWarningTime["CPU"] -or ($now - $lastWarningTime["CPU"]).TotalMinutes -ge 5) {
                        Write-Log "WARNING: CPU temperature high: $cpuTemp°C" "WARN"
                        Send-DesktopAlert -Title "Temperature Warning" -Message "CPU temperature is high: $cpuTemp°C"
                        Send-EmailAlert -Subject "Temperature Warning: CPU" -Body "CPU temperature has reached $cpuTemp°C. Warning threshold: $($Config.thresholds.warning_cpu)°C"
                        $lastWarningTime["CPU"] = $now
                    }
                } else {
                    $emergencyShutdownTriggered = $false
                }
            }
            
            # Check GPU temperatures
            $gpuTemps = Get-GPUTemperatures
            foreach ($gpu in $gpuTemps) {
                Write-Log "$($gpu.Name) Temperature: $($gpu.Temperature)°C" "INFO"
                
                if ($gpu.Temperature -ge $Config.thresholds.critical_gpu -and $Config.actions.critical_shutdown) {
                    if (-not $emergencyShutdownTriggered) {
                        $emergencyShutdownTriggered = $true
                        Stop-MiningProcesses
                    }
                } elseif ($gpu.Temperature -ge $Config.thresholds.warning_gpu -and $Config.actions.warning_alert) {
                    $now = Get-Date
                    $gpuKey = $gpu.Name
                    if (-not $lastWarningTime[$gpuKey] -or ($now - $lastWarningTime[$gpuKey]).TotalMinutes -ge 5) {
                        Write-Log "WARNING: $($gpu.Name) temperature high: $($gpu.Temperature)°C" "WARN"
                        Send-DesktopAlert -Title "GPU Temperature Warning" -Message "$($gpu.Name) temperature is high: $($gpu.Temperature)°C"
                        Send-EmailAlert -Subject "Temperature Warning: $($gpu.Name)" -Body "$($gpu.Name) temperature has reached $($gpu.Temperature)°C. Warning threshold: $($Config.thresholds.warning_gpu)°C"
                        $lastWarningTime[$gpuKey] = $now
                    }
                }
            }
            
            # Write temperature data for web dashboard
            $tempData = @{
                timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                cpu_temp = $cpuTemp
                gpu_temps = $gpuTemps
                status = if ($emergencyShutdownTriggered) { "EMERGENCY" } else { "NORMAL" }
            }
            
            $tempData | ConvertTo-Json -Depth 10 | Out-File "web/data/current-temps.json" -Force
            
        } catch {
            Write-Log "Error in monitoring loop: $($_.Exception.Message)" "ERROR"
        }
        
        Start-Sleep -Seconds $Config.thresholds.check_interval
    }
}

# Windows Service functions
function Install-Service {
    Write-Log "Installing temperature monitoring service..." "INFO"
    
    $serviceName = "MiningTempMonitor"
    $serviceDisplayName = "Mining Temperature Monitor"
    $serviceDescription = "Professional temperature monitoring for cryptocurrency mining operations"
    $servicePath = """$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe"" -File ""$(Resolve-Path $PSCommandPath)"" -Service"
    
    # Stop and remove existing service
    $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($existingService) {
        Stop-Service -Name $serviceName -Force
        Remove-Service -Name $serviceName
    }
    
    # Create new service
    New-Service -Name $serviceName -DisplayName $serviceDisplayName -Description $serviceDescription -BinaryPathName $servicePath -StartupType Automatic
    Start-Service -Name $serviceName
    
    Write-Log "Service installed and started successfully" "INFO"
}

function Uninstall-Service {
    Write-Log "Uninstalling temperature monitoring service..." "INFO"
    
    $serviceName = "MiningTempMonitor"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    
    if ($service) {
        Stop-Service -Name $serviceName -Force
        Remove-Service -Name $serviceName
        Write-Log "Service uninstalled successfully" "INFO"
    } else {
        Write-Log "Service not found" "WARN"
    }
}

# Main execution
if ($Install) {
    Install-Service
} elseif ($Uninstall) {
    Uninstall-Service
} elseif ($Service) {
    Start-TemperatureMonitoring
} else {
    Write-Host "Mining Temperature Monitor - Professional Hardware Protection" -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Cyan
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\TempMonitor.ps1                 # Run interactive monitoring"
    Write-Host "  .\TempMonitor.ps1 -Service        # Run as service"
    Write-Host "  .\TempMonitor.ps1 -Install        # Install Windows service"
    Write-Host "  .\TempMonitor.ps1 -Uninstall      # Uninstall Windows service"
    Write-Host "" -ForegroundColor Yellow
    
    if (-not $Install -and -not $Uninstall -and -not $Service) {
        Start-TemperatureMonitoring
    }
}