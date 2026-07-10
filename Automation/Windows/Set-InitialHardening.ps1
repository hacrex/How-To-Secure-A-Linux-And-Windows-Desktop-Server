# Set-InitialHardening.ps1
# This script automates initial hardening steps for Windows Server.

<#
.SYNOPSIS
    Automates initial hardening steps for Windows Server, including Windows Update configuration and basic security settings.
.DESCRIPTION
    This script performs the following actions:
    - Configures Windows Update to automatically download and install updates.
    - Disables the Guest account.
    - Renames the Administrator account (optional).
    - Configures basic audit policies.
.PARAMETER RenameAdministrator
    Specifies whether to rename the built-in Administrator account. Default is $true.
.PARAMETER NewAdministratorName
    The new name for the Administrator account if RenameAdministrator is $true. Default is 'SecAdmin'.
.NOTES
    Always test in a non-production environment first.
    Requires administrative privileges to run.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param
(
    [bool]$RenameAdministrator = $true,
    [string]$NewAdministratorName = 'SecAdmin'
)

function Set-WindowsUpdateConfiguration {
    Write-Host "Configuring Windows Update..."
    # Configure Windows Update to automatically download and install updates
    # 4 = Auto download and schedule the install
    # 5 = Auto download, install, and restart if necessary
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "AUOptions" -Value 4 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "ScheduledInstallDay" -Value 0 # Every day
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "ScheduledInstallTime" -Value 3 # 3 AM
    Write-Host "Windows Update configured for automatic downloads and scheduled installation."
}

function Disable-GuestAccount {
    Write-Host "Disabling Guest account..."
    try {
        $guestAccount = Get-LocalUser -Name "Guest" -ErrorAction Stop
        if ($guestAccount.Enabled) {
            if ($PSCmdlet.ShouldProcess("Guest", "Disable account")) {
                Disable-LocalUser -InputObject $guestAccount
                Write-Host "Guest account disabled successfully."
            }
        } else {
            Write-Host "Guest account is already disabled."
        }
    } catch {
        Write-Warning "Could not find or disable Guest account: $($_.Exception.Message)"
    }
}

function Rename-AdministratorAccount {
    param
    (
        [string]$NewName
    )
    Write-Host "Renaming Administrator account to '$NewName'..."
    try {
        $adminAccount = Get-LocalUser -Name "Administrator" -ErrorAction Stop
        if ($adminAccount.Name -ne $NewName) {
            if ($PSCmdlet.ShouldProcess("Administrator", "Rename account to '$NewName'")) {
                Rename-LocalUser -InputObject $adminAccount -NewName $NewName
                Write-Host "Administrator account renamed to '$NewName' successfully."
            }
        } else {
            Write-Host "Administrator account is already named '$NewName'."
        }
    } catch {
        Write-Warning "Could not rename Administrator account: $($_.Exception.Message)"
    }
}

function Configure-BasicAuditPolicy {
    Write-Host "Configuring basic audit policies..."
    # Example: Enable auditing for successful and failed logon events
    # This is a simplified example. For full hardening, use GPOs or Security Templates.
    auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
    Write-Host "Basic audit policy for Logon/Logoff configured."
}

# Main execution
if ($PSCmdlet.ShouldProcess("Windows Server", "Perform initial hardening")) {
    Set-WindowsUpdateConfiguration
    Disable-GuestAccount
    if ($RenameAdministrator) {
        Rename-AdministratorAccount -NewName $NewAdministratorName
    }
    Configure-BasicAuditPolicy
    Write-Host "Initial Windows Server hardening steps completed."
}
