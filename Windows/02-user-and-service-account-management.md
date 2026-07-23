# 02 - Windows User and Service Account Management

Effective management of user and service accounts is paramount to prevent unauthorized access and privilege escalation in Windows Server environments. This section outlines best practices for securing these accounts.

## 1. User Account Security Hardening

### Disable/Rename Default Accounts

Disable the built-in Guest account and rename or disable the Administrator account [2] [4].

```powershell
# Disable the Guest account
Disable-LocalUser -Name "Guest"

# Rename the built-in Administrator account
Rename-LocalUser -Name "Administrator" -NewName "Admin-$(Get-Random -Minimum 1000 -Maximum 9999)"

# Disable the built-in Administrator account (after creating a new admin account)
Disable-LocalUser -Name "Administrator"

# List all local accounts
Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordLastSet
```

### Enforce Strong Password Policies

```powershell
# Set password policy via secedit or Net Accounts
# Minimum 14 characters, max 60 days, 1 password history
net accounts /minpwlen:14 /maxpwage:60 /uniquepw:5

# Or configure via Group Policy (preferred for domain-joined machines)
# Computer Configuration > Windows Settings > Security Settings > Account Policies > Password Policy

# Verify current password policy
net accounts
```

### Configure Account Lockout Policy

```powershell
# Lock after 5 failed attempts, 15-minute lockout duration, reset counter after 15 minutes
net accounts /lockoutthreshold:5 /lockoutduration:15 /lockoutwindow:15

# Verify lockout settings
net accounts
```

### Disable Unused Accounts

```powershell
# Find accounts that have never logged on or haven't logged on in 90 days
Get-LocalUser | Where-Object {
    $_.Enabled -eq $true -and
    $_.Name -notin @("Administrator", "Guest", "DefaultAccount") -and
    ($_.LastLogon -lt (Get-Date).AddDays(-90) -or $_.LastLogon -eq $null)
} | Select-Object Name, LastLogon, PasswordLastSet

# Disable stale accounts
Get-LocalUser | Where-Object {
    $_.Enabled -eq $true -and
    $_.LastLogon -lt (Get-Date).AddDays(-90) -and
    $_.Name -notin @("Administrator", "Guest")
} | Disable-LocalUser
```

### Implement LAPS (Local Administrator Password Solution)

LAPS randomizes and regularly rotates local administrator passwords across domain-joined machines [3].

```powershell
# Install LAPS module (on management workstation)
Install-WindowsFeature -Name "RSAT-AD-PowerShell"

# Import the LAPS module
Import-Module AdmPwd.PS

# View current LAPS password for a computer
Get-ADComputer -Identity "SERVER01" -Properties ms-Mcs-AdmPwd | Select-Object Name, ms-Mcs-AdmPwd

# To deploy LAPS, install the LAPS agent on target machines via Group Policy
# See: https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview
```

## 2. Service Account Management

Using dedicated, non-privileged accounts for services and applications is a critical security practice. Avoid running services under `Local System` or `Administrator` unless absolutely necessary [2].

### Audit Service Account Configurations

```powershell
# Find services running as LocalSystem or high-privilege accounts
Get-CimInstance -ClassName Win32_Service | Where-Object {
    $_.StartName -in @("LocalSystem", "NT AUTHORITY\\SYSTEM")
} | Select-Object Name, DisplayName, StartName, StartMode

# Find services running as specific user accounts (potential service accounts)
Get-CimInstance -ClassName Win32_Service | Where-Object {
    $_.StartName -notlike "LocalSystem" -and
    $_.StartName -notlike "NT AUTHORITY\\*" -and
    $_.StartName -notlike "NT SERVICE\\*"
} | Select-Object Name, DisplayName, StartName
```

### Configure Service Accounts

```powershell
# Change a service to run as a dedicated account (not recommended for LocalSystem)
# First create the service account, then:
Set-Service -Name "YourServiceName" -StartupType Automatic
# Use sc.exe for account configuration:
sc.exe config "YourServiceName" obj= "DOMAIN\ServiceAccount" password= "SecurePassword"

# Restrict interactive logon for service accounts via Group Policy:
# Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment
# Deny log on locally: Add service accounts here
```

## 3. Audit Local Group Memberships

```powershell
# Review members of sensitive groups
Get-LocalGroupMember -Group "Administrators" | Select-Object Name, PrincipalSource, ObjectClass
Get-LocalGroupMember -Group "Remote Desktop Users" | Select-Object Name
Get-LocalGroupMember -Group "Backup Operators" | Select-Object Name

# Find all users with admin privileges
$adminGroups = @("Administrators", "Domain Admins", "Enterprise Admins", "Schema Admins")
foreach ($group in $adminGroups) {
    try {
        Write-Host "`n=== $group ===" -ForegroundColor Yellow
        Get-LocalGroupMember -Group $group -ErrorAction SilentlyContinue | Select-Object Name
    } catch { }
}
```

## References

[1] [Deploy Windows Server 2025 security baselines locally with OSConfig](https://learn.microsoft.com/en-us/windows-server/security/osconfig/osconfig-how-to-configure-security-baselines)
[2] [Windows Server 2025 Security Hardening | IT Blog](https://www.informaticar.net/windows-server-2025-security-hardening/)
[3] [Security baseline for Windows Server 2025, version 2602](https://techcommunity.microsoft.com/blog/microsoft-security-baselines/security-baseline-for-windows-server-2025-version-2602/4496468)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
