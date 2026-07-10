# Manage-UserAccounts.ps1
# This script automates user and service account management for Windows Server.

<#
.SYNOPSIS
    Automates user and service account management, including password policies and LAPS configuration.
.DESCRIPTION
    This script performs the following actions:
    - Configures local password policy (minimum length, complexity, history, age).
    - Configures account lockout policy.
    - (Optional) Installs and configures LAPS for local administrator password management.
    - Disables unused local user accounts.
.PARAMETER MinimumPasswordLength
    Sets the minimum password length. Default is 14.
.PARAMETER PasswordComplexityEnabled
    Enables or disables password complexity requirements. Default is $true.
.PARAMETER PasswordHistorySize
    Sets the number of unique new passwords that must be used before an old password can be reused. Default is 24.
.PARAMETER MaximumPasswordAgeDays
    Sets the maximum number of days a password can be used. Default is 90.
.PARAMETER AccountLockoutThreshold
    Sets the number of failed logon attempts before an account is locked out. Default is 5.
.PARAMETER AccountLockoutDurationMinutes
    Sets the duration in minutes that a locked-out account remains locked. Default is 30.
.PARAMETER ResetAccountLockoutCounterMinutes
    Sets the time in minutes after which the failed logon attempts counter is reset. Default is 30.
.PARAMETER ConfigureLAPS
    Specifies whether to configure LAPS. Default is $false. LAPS requires Active Directory and specific GPO settings.
.NOTES
    Always test in a non-production environment first.
    Requires administrative privileges to run.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param
(
    [int]$MinimumPasswordLength = 14,
    [bool]$PasswordComplexityEnabled = $true,
    [int]$PasswordHistorySize = 24,
    [int]$MaximumPasswordAgeDays = 90,
    [int]$AccountLockoutThreshold = 5,
    [int]$AccountLockoutDurationMinutes = 30,
    [int]$ResetAccountLockoutCounterMinutes = 30,
    [bool]$ConfigureLAPS = $false
)

function Set-LocalSecurityPolicy {
    param
    (
        [string]$PolicyName,
        [string]$PolicyValue
    )
    Write-Host "Setting local security policy: $PolicyName to $PolicyValue"
    # Using secedit for local policy changes
    # Note: For domain-joined machines, Group Policy should be used.
    try {
        $command = "secedit /configure /db C:\Windows\Temp\temp.sdb /cfg $($env:TEMP)\secedit.inf /areas SECURITYPOLICY"
        $infContent = "[Unicode]
Unicode=yes
[System Access]
$PolicyName = $PolicyValue
"
        Set-Content -Path "$($env:TEMP)\secedit.inf" -Value $infContent
        Invoke-Expression $command
        Remove-Item -Path "$($env:TEMP)\secedit.inf"
        Write-Host "Policy '$PolicyName' set successfully."
    } catch {
        Write-Warning "Failed to set policy '$PolicyName': $($_.Exception.Message)"
    }
}

function Configure-PasswordPolicy {
    Write-Host "Configuring password policy..."
    if ($PSCmdlet.ShouldProcess("Password Policy", "Configure")) {
        Set-LocalSecurityPolicy -PolicyName "MinimumPasswordLength" -PolicyValue $MinimumPasswordLength
        Set-LocalSecurityPolicy -PolicyName "PasswordComplexity" -PolicyValue ([int]$PasswordComplexityEnabled)
        Set-LocalSecurityPolicy -PolicyName "PasswordHistorySize" -PolicyValue $PasswordHistorySize
        Set-LocalSecurityPolicy -PolicyName "MaximumPasswordAge" -PolicyValue $MaximumPasswordAgeDays
        Write-Host "Password policy configured."
    }
}

function Configure-AccountLockoutPolicy {
    Write-Host "Configuring account lockout policy..."
    if ($PSCmdlet.ShouldProcess("Account Lockout Policy", "Configure")) {
        Set-LocalSecurityPolicy -PolicyName "LockoutBadCount" -PolicyValue $AccountLockoutThreshold
        Set-LocalSecurityPolicy -PolicyName "LockoutDuration" -PolicyValue $AccountLockoutDurationMinutes
        Set-LocalSecurityPolicy -PolicyName "ResetLockoutCount" -PolicyValue $ResetAccountLockoutCounterMinutes
        Write-Host "Account lockout policy configured."
    }
}

function Disable-UnusedLocalAccounts {
    Write-Host "Disabling unused local accounts..."
    # This is a placeholder. In a real scenario, you would need a list of unused accounts.
    # For demonstration, let's assume we want to disable a hypothetical 'TestUser'.
    $unusedAccountName = "TestUser"
    try {
        $account = Get-LocalUser -Name $unusedAccountName -ErrorAction SilentlyContinue
        if ($account -and $account.Enabled) {
            if ($PSCmdlet.ShouldProcess($unusedAccountName, "Disable account")) {
                Disable-LocalUser -InputObject $account
                Write-Host "Account '$unusedAccountName' disabled successfully."
            }
        } elseif ($account -and -not $account.Enabled) {
            Write-Host "Account '$unusedAccountName' is already disabled."
        } else {
            Write-Host "Account '$unusedAccountName' not found. Skipping."
        }
    } catch {
        Write-Warning "Failed to disable account '$unusedAccountName': $($_.Exception.Message)"
    }
}

function Configure-LAPS {
    Write-Host "Configuring LAPS... (Requires Active Directory and LAPS client installation)"
    Write-Warning "LAPS configuration is complex and typically involves Active Directory schema extensions and Group Policy Objects. This script can only perform client-side installation if LAPS is already deployed in your domain."
    # Placeholder for LAPS client installation if needed
    # Example: Install-WindowsFeature -Name "LAPS" -IncludeManagementTools
    # Further configuration would involve GPO application.
    Write-Host "Please ensure LAPS is properly configured in your Active Directory environment."
}

# Main execution
if ($PSCmdlet.ShouldProcess("Windows Server User Accounts", "Manage")) {
    Configure-PasswordPolicy
    Configure-AccountLockoutPolicy
    Disable-UnusedLocalAccounts # This needs to be adapted for actual unused accounts

    if ($ConfigureLAPS) {
        Configure-LAPS
    }
    Write-Host "Windows Server user and account management steps completed."
}
