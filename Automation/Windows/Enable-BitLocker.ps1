# Enable-BitLocker.ps1
# This script enables BitLocker encryption on a specified data volume.

<#
.SYNOPSIS
    Enables BitLocker encryption on a specified data volume.
.DESCRIPTION
    This script enables BitLocker on a target volume and saves the recovery key.
    It is intended for data volumes, not the OS volume, as OS volume encryption
    typically requires a TPM or startup key and is often configured during OS installation.
.PARAMETER DriveLetter
    The drive letter of the volume to encrypt (e.g., 'D').
.PARAMETER RecoveryKeyPath
    The path where the BitLocker recovery key will be saved (e.g., 'C:\BitLockerKeys').
.NOTES
    Always test in a non-production environment first.
    Requires administrative privileges to run.
    Requires the BitLocker Drive Encryption feature to be installed.
    This script focuses on data volumes. Encrypting the OS volume is more complex.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param
(
    [Parameter(Mandatory=$true)]
    [char]$DriveLetter,

    [Parameter(Mandatory=$true)]
    [string]$RecoveryKeyPath
)

function Test-BitLockerFeatureInstalled {
    Write-Host "Checking if BitLocker Drive Encryption feature is installed..."
    try {
        $feature = Get-WindowsFeature -Name BitLocker -ErrorAction Stop
        if ($feature.Installed) {
            Write-Host "BitLocker Drive Encryption feature is installed."
            return $true
        } else {
            Write-Warning "BitLocker Drive Encryption feature is not installed. Please install it using: Install-WindowsFeature -Name BitLocker -IncludeAllSubFeature -IncludeManagementTools"
            return $false
        }
    } catch {
        Write-Warning "Could not check BitLocker feature: $($_.Exception.Message)"
        return $false
    }
}

function Enable-BitLockerOnVolume {
    param
    (
        [char]$DriveLetter,
        [string]$RecoveryKeyPath
    )

    $volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction SilentlyContinue

    if (-not $volume) {
        Write-Warning "Drive letter '$DriveLetter' not found. Please ensure the drive exists."
        return
    }

    if ($volume.DriveType -ne 'Fixed') {
        Write-Warning "BitLocker is typically enabled on fixed data drives. Drive '$DriveLetter' is of type '$($volume.DriveType)'. Proceed with caution."
    }

    if ($volume.EncryptionStatus -eq 'Encrypted') {
        Write-Host "Drive '$DriveLetter' is already encrypted. Skipping."
        return
    }

    Write-Host "Enabling BitLocker on drive '$DriveLetter'..."
    if ($PSCmdlet.ShouldProcess("Drive $DriveLetter", "Enable BitLocker")) {
        try {
            # Create recovery key path if it doesn't exist
            if (-not (Test-Path $RecoveryKeyPath)) {
                New-Item -Path $RecoveryKeyPath -ItemType Directory -Force | Out-Null
                Write-Host "Created recovery key path: $RecoveryKeyPath"
            }

            # Enable BitLocker and save recovery key to file
            Enable-BitLocker -MountPoint "$($DriveLetter):" -RecoveryKeyPath $RecoveryKeyPath -SkipHardwareCheck -ErrorAction Stop
            Write-Host "BitLocker enabled on drive '$DriveLetter'. Recovery key saved to '$RecoveryKeyPath'."
        } catch {
            Write-Error "Failed to enable BitLocker on drive '$DriveLetter': $($_.Exception.Message)"
        }
    }
}

# Main execution
if ($PSCmdlet.ShouldProcess("BitLocker Encryption", "Configure")) {
    if (Test-BitLockerFeatureInstalled) {
        Enable-BitLockerOnVolume -DriveLetter $DriveLetter -RecoveryKeyPath $RecoveryKeyPath
    }
    Write-Host "BitLocker configuration process completed."
}
