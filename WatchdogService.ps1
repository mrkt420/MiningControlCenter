# WatchdogService.ps1

# Define the list of miners and their executable paths
$miners = @(
    @{ Name = "XMRig"; Path = "C:\Path\To\XMRig.exe" },
    @{ Name = "T-Rex"; Path = "C:\Path\To\T-Rex.exe" },
    @{ Name = "SRBMiner"; Path = "C:\Path\To\SRBMiner.exe" },
    @{ Name = "TeamRedMiner"; Path = "C:\Path\To\TeamRedMiner.exe" },
    @{ Name = "LolMiner"; Path = "C:\Path\To\LolMiner.exe" },
    @{ Name = "GMiner"; Path = "C:\Path\To\GMiner.exe" },
    @{ Name = "NBMiner"; Path = "C:\Path\To\NBMiner.exe" }
)

# Email configuration
$emailSmtpServer = "smtp.example.com"
$emailFrom = "alert@example.com"
$emailTo = "admin@example.com"

# Logging configuration
$logFile = "C:\Path\To\log.txt"
$maxLogSize = 5MB

# Function to send email notifications
function Send-EmailNotification {
    param (
        [string]$subject,
        [string]$body
    )
    # Implement email sending logic here
}

# Function to log events
function Log-Event {
    param ([string]$message)
    if ((Get-Item $logFile).Length -gt $maxLogSize) {
        # Rotate the log file
        Rename-Item $logFile "$logFile.bak"
    }
    # Append the message to the log file
    Add-Content -Path $logFile -Value "$(Get-Date) - $message"
}

# Function to check and restart miners
function Check-And-RestartMiners {
    foreach ($miner in $miners) {
        if (-not (Get-Process -Name $miner.Name -ErrorAction SilentlyContinue)) {
            Log-Event "Process $($miner.Name) not running. Attempting to restart."
            Start-Process $miner.Path
            Send-EmailNotification -subject "Miner Restarted" -body "$($miner.Name) was restarted."
        }
    }
}

# Main loop for monitoring
while ($true) {
    Check-And-RestartMiners
    Start-Sleep -Seconds 60 # Adjust the sleep time as needed
}