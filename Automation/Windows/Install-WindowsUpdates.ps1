# Install-WindowsUpdates.ps1
# Automates Windows Update configuration and installation
# Equivalent to Linux initial_hardening.yml and unattended-upgrades

param(
    [switch]$InstallNow,
    [switch]$ConfigureAutoUpdate,
    [string]$ScheduleTime = "03:00"
)

$ErrorActionPreference = "Stop"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Log "This script must be run as Administrator" "ERROR"
    exit 1
}

Write-Log "Starting Windows Update Automation"

# Configure Windows Update Settings via Registry
if ($ConfigureAutoUpdate -or $InstallNow) {
    Write-Log "Configuring Windows Update settings..."
    
    # Create WindowsUpdate policy keys if they don't exist
    $wuPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    if (-not (Test-Path $wuPath)) {
        New-Item -Path $wuPath -Force | Out-Null
    }
    
    if (-not (Test-Path $auPath)) {
        New-Item -Path $auPath -Force | Out-Null
    }
    
    # Configure Automatic Updates
    Set-ItemProperty -Path $auPath -Name "NoAutoUpdate" -Value 0
    Set-ItemProperty -Path $auPath -Name "AUOptions" -Value 4  # Auto download and schedule install
    Set-ItemProperty -Path $auPath -Name "ScheduledInstallDay" -Value 0  # Every day
    Set-ItemProperty -Path $auPath -Name "ScheduledInstallTime" -Value 3  # 3 AM
    
    # Configure update behavior
    Set-ItemProperty -Path $wuPath -Name "DoNotConnectToWindowsUpdateInternetLocations" -Value 0
    
    Write-Log "Windows Update auto-update configured successfully"
}

# Install Updates Now
if ($InstallNow) {
    Write-Log "Checking for and installing updates..."
    
    try {
        # Use PSWindowsUpdate module if available, otherwise use built-in methods
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            Import-Module PSWindowsUpdate
            Write-Log "Installing updates using PSWindowsUpdate module..."
            Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
        } else {
            Write-Log "PSWindowsUpdate module not found. Using built-in update client..."
            
            # Create update session
            $updateSession = New-Object -ComObject Microsoft.Update.Session
            $updateSearcher = $updateSession.CreateUpdateSearcher()
            
            # Search for pending updates
            $searchResult = $updateSearcher.Search("IsInstalled=0")
            
            if ($searchResult.Updates.Count -eq 0) {
                Write-Log "No pending updates found" "INFO"
            } else {
                Write-Log "Found $($searchResult.Updates.Count) pending updates"
                
                # Download and install updates
                $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
                foreach ($update in $searchResult.Updates) {
                    if ($update.IsDownloaded -eq $false) {
                        $updatesToInstall.Add($update) | Out-Null
                    }
                }
                
                if ($updatesToInstall.Count -gt 0) {
                    $installer = $updateSession.CreateUpdateInstaller()
                    $installer.Updates = $updatesToInstall
                    $installationResult = $installer.Install()
                    
                    if ($installationResult.ResultCode -eq 2) {
                        Write-Log "Updates installed successfully. Reboot may be required."
                    } else {
                        Write-Log "Update installation completed with code: $($installationResult.ResultCode)" "WARN"
                    }
                }
            }
        }
    } catch {
        Write-Log "Error during update installation: $_" "ERROR"
    }
}

Write-Log "Windows Update Automation completed"
Write-Host "`nUsage Examples:"
Write-Host "  .\Install-WindowsUpdates.ps1 -ConfigureAutoUpdate  # Configure automatic updates"
Write-Host "  .\Install-WindowsUpdates.ps1 -InstallNow           # Install pending updates now"
Write-Host "  .\Install-WindowsUpdates.ps1 -InstallNow -ConfigureAutoUpdate  # Both"
