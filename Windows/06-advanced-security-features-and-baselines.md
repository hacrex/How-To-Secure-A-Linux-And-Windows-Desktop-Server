# 06 - Windows Advanced Security Features and Baselines

Leveraging advanced security features and established baselines is crucial for achieving a robust security posture in Windows Server environments.

## 1. Microsoft Security Baselines

Microsoft provides security baselines—groups of recommended configuration settings [1] [3].

```powershell
# Download and import security baselines
# See: https://learn.microsoft.com/en-us/windows/security/operating-system-security/device-management/windows-security-configuration-framework/windows-security-baselines

# Apply Windows Server 2025 baseline using LGPO (Local Group Policy Object)
# Download LGPO.exe from Microsoft
lgpo.exe /g "path\to\baseline\folder"

# Verify applied security settings
gpresult /h "$env:TEMP\security_report.html"
Start-Process "$env:TEMP\security_report.html"
```

## 2. CIS Benchmarks

Apply CIS Benchmarks for Windows Server for comprehensive hardening [4].

## 3. Secured-Core Server Features

Enable Secured-Core features if hardware supports it [1].

```powershell
# Verify Secured-Core features status
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard |
    Select-Object VirtualizationBasedSecurityStatus, CodeIntegrityPolicyEnforcementStatus, UsermodeCodeIntegrityPolicyEnforcementStatus

# Check if Secure Boot is enabled
Confirm-SecureBootUEFI

# Check Virtualization-Based Security status
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard |
    Select-Object SecurityServicesRunning
```

## 4. Windows Defender Credential Guard

Credential Guard uses virtualization-based security to isolate LSA secrets, preventing credential theft [1] [3].

```powershell
# Check if Credential Guard is enabled
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard |
    Select-Object SecurityServicesRunning

# Enable Credential Guard via Group Policy or registry
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 1

# Enable via Group Policy (preferred for domain-joined):
# Computer Configuration > Administrative Templates > System > Device Guard
# "Turn On Virtualization Based Security" = Enabled
# "Credential Guard" = Enabled with UEFI lock
```

## 5. Just Enough Administration (JEA)

JEA restricts PowerShell remoting sessions to only the commands and parameters needed for a specific task.

```powershell
# Create a JEA session configuration
New-PSSessionConfigurationFile -Path "C:\JEA\JEAConfig.pssc" -SessionType RestrictedRemoteServer `
    -RunAsVirtualAccount `
    -TranscriptDirectory "C:\JEA\Transcripts" `
    -LanguageMode NoLanguage `
    -ExecutionPolicy Restricted

# Define role capabilities (what commands are allowed)
New-RoleCapabilityFile -Path "C:\JEA\ServerManagement.psrc" -VisibleCmdlets `
    @{Name='Get-Service'}, @{Name='Restart-Service'}, @{Name='Get-Process'},
    @{Name='Get-EventLog'}, @{Name='Get-WinEvent'}

# Register the JEA endpoint
Register-PSSessionConfiguration -Name "ServerManagement" -Path "C:\JEA\JEAConfig.pssc" -Force

# Test JEA connection
Enter-PSSession -ComputerName localhost -ConfigurationName "ServerManagement"

# List registered session configurations
Get-PSSessionConfiguration
```

## 6. Windows Defender Antivirus Hardening

```powershell
# Enable real-time protection
Set-MpPreference -DisableRealtimeMonitoring $false

# Enable cloud protection
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Configure ASR (Attack Surface Reduction) rules
# Block Office applications from creating child processes
Add-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5831943542 -AttackSurfaceReductionRules_Actions Enabled

# Block executable content from email client and webmail
Add-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 -AttackSurfaceReductionRules_Actions Enabled

# Block all Office applications from creating child processes
Add-MpPreference -AttackSurfaceReductionRules_Ids 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84 -AttackSurfaceReductionRules_Actions Enabled

# Verify ASR rules status
Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Ids
```

## 7. PowerShell Constrained Language Mode

Restrict PowerShell to prevent execution of unauthorized scripts.

```powershell
# Enable Constrained Language Mode
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Management" -Name "ProtectionMode" -Value 1

# Or via Group Policy:
# Computer Configuration > Administrative Templates > Windows Components > Windows PowerShell
# "Turn on PowerShell Script Block Logging" = Enabled
# "Turn on Module Logging" = Enabled

# Check current language mode
$ExecutionContext.SessionState.LanguageMode

# Enforce via AppLocker or WDAC (Windows Defender Application Control)
```

## 8. RDP Security Hardening

```powershell
# Enable NLA (Network Level Authentication)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1

# Set encryption to High
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MinEncryptionLevel" -Value 3

# Limit concurrent sessions
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxInstanceCount" -Value 2

# Set idle timeout (15 minutes)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MaxIdleTime" -Value 900000

# Disable clipboard and drive redirection
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableClipRedirection" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableCdm" -Value 1

# Restrict RDP access to specific users/groups via Group Policy:
# Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment
# "Allow log on through Remote Desktop Services" = Add specific users only
```

## References

[1] [Deploy Windows Server 2025 security baselines locally with OSConfig](https://learn.microsoft.com/en-us/windows-server/security/osconfig/osconfig-how-to-configure-security-baselines)
[3] [Security baseline for Windows Server 2025, version 2602](https://techcommunity.microsoft.com/blog/microsoft-security-baselines/security-baseline-for-windows-server-2025-version-2602/4496468)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
