# Windows Desktop Hardening

This guide covers security hardening for Windows 10/11 desktop and laptop systems for personal use.

## 1. Windows Update

Keep Windows fully updated. Enable automatic updates to ensure timely patching.

```powershell
# Enable automatic updates
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 4

# Check for updates manually
Settings > Update & Security > Windows Update > Check for updates
```

## 2. User Account Control (UAC)

UAC prevents unauthorized changes to your system. Keep it at the highest level.

```powershell
# Set UAC to always notify (highest level)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1
```

**Settings > Accounts > Family & other users** — Use a standard (non-admin) account for daily use.

## 3. Windows Defender / Antivirus

```powershell
# Verify real-time protection is on
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusEnabled

# Enable cloud-delivered protection
Set-MpPreference -MAPSReporting Advanced

# Enable controlled folder access (anti-ransomware)
Set-MpPreference -EnableControlledFolderAccess Enabled

# Add protected folders
Add-MpPreference -ControlledFolderAccessProtectedFolders "C:\Users\$env:USERNAME\Documents"
Add-MpPreference -ControlledFolderAccessProtectedFolders "C:\Users\$env:USERNAME\Desktop"

# Enable network protection
Set-MpPreference -EnableNetworkProtection Enabled

# Configure ASR (Attack Surface Reduction) rules
Add-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5831943542 -AttackSurfaceReductionRules_Actions Enabled  # Block Office child processes
Add-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 -AttackSurfaceReductionRules_Actions Enabled  # Block email content
```

## 4. Windows Firewall

```powershell
# Ensure firewall is on for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Allow

# Block outbound SMB (prevents data exfiltration)
New-NetFirewallRule -DisplayName "Block Outbound SMB" -Direction Outbound -Protocol TCP -RemotePort 445 -Action Block -Profile Domain,Private,Public
```

## 5. Disk Encryption (BitLocker)

```powershell
# Enable BitLocker on C: drive
Enable-BitLocker -MountPoint "C:" -TpmProtector -EncryptionMethod XtsAes256

# Back up recovery key to file (store securely!)
$protector = (Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"})
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $protector.KeyProtectorId -Path "$env:USERPROFILE\Desktop\BitLocker_RecoveryKey.txt"

# Check status
Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, ProtectionStatus
```

## 6. Disable Telemetry and Privacy

```powershell
# Set telemetry to minimum (Security only)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0

# Disable advertising ID
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

# Disable activity history
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0
```

Also review: **Settings > Privacy & security** and disable permissions you don't need (location, microphone, camera, diagnostics).

## 7. Browser Hardening (Edge/Chrome)

- Enable Enhanced Security Mode (Edge) or HTTPS-Only Mode (Chrome)
- Disable or review extensions — remove unused ones
- Enable Safe Browsing (Enhanced Protection)
- Use a privacy-focused DNS (e.g., Cloudflare 1.1.1.1, Quad9 9.9.9.9)
- Clear cookies regularly or use container tabs

```powershell
# Set DNS to Cloudflare (system-wide)
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses "1.1.1.1","1.0.0.1"
```

## 8. Disable Unnecessary Features

```powershell
# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# Disable Remote Desktop if not needed
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1

# Disable Bluetooth if not used
# Settings > Bluetooth & devices > Bluetooth > Off

# Disable AutoPlay for USB
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 255
```

## 9. PowerShell Logging

Enable logging to detect malicious script execution.

```powershell
# Enable Script Block Logging
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1

# Enable Module Logging
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging" -Value 1
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Name "*" -Value "*" -Force
```

## 10. Lock Screen and Account Security

```powershell
# Set lock screen timeout (5 minutes)
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LockScreen" -Name "ScreenTimeout" -Value 300

# Require password on wake
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 1
powercfg /SETACTIVE SCHEME_CURRENT

# Enable picture password or PIN (in addition to password)
# Settings > Accounts > Sign-in options
```

## Quick Checklist

- [ ] Windows Update enabled and current
- [ ] UAC set to highest level
- [ ] Standard user account for daily use
- [ ] Windows Defender real-time protection on
- [ ] Controlled folder access enabled
- [ ] Firewall enabled (all profiles, block inbound)
- [ ] BitLocker enabled on C: drive
- [ ] Recovery key backed up securely
- [ ] SMBv1 disabled
- [ ] Remote Desktop disabled (if not needed)
- [ ] AutoPlay disabled
- [ ] Telemetry set to minimum
- [ ] Browser hardened (safe browsing, HTTPS-only)
- [ ] PowerShell logging enabled
- [ ] Lock screen timeout set
