# 01 - Windows Initial Server Preparation and Updates

Before and immediately after deploying a Windows Server, several foundational steps are crucial for establishing a secure environment.

## 1. Inventory and Network Isolation

*   **Inventory Management**: Maintain a detailed inventory of all servers to track their purpose, configuration, and security status [4].
*   **Network Isolation**: Isolate new servers from untrusted networks until they are fully hardened to prevent early exposure to threats [4].

## 2. BIOS/Firmware Security

*   Secure the BIOS/firmware with strong passwords and configure the boot order to prevent booting from unauthorized media [4].
*   Enable Secure Boot in UEFI settings to verify digital signatures of boot components.

## 3. Apply Windows Updates

Immediately apply all available updates and enable automatic updates. For multiple servers, use WSUS, SCCM, or Azure Update Management [2] [4].

```powershell
# Check for available updates
Install-Module PSWindowsUpdate -Force
Get-WindowsUpdate

# Install all pending updates
Install-WindowsUpdate -AcceptAll -AutoReboot

# Enable automatic updates via registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 4
```

## 4. Remove Unnecessary Features and Roles

Minimize the attack surface by removing components not required for the server's function.

```powershell
# List installed features
Get-WindowsFeature | Where-Object {$_.Installed -eq $true}

# Remove unnecessary features (examples)
Remove-WindowsFeature -Name Telnet-Server, TFTP-Client, XPS-Viewer

# List installed roles
Get-WindowsFeature | Where-Object {$_.InstallState -eq "Installed" -and $_.FeatureType -eq "Role"}
```

## 5. Disable Unnecessary Services

```powershell
# List running services
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object Name, DisplayName, StartType

# Disable common unnecessary services on servers
# (Review each before disabling based on server role)
Disable-Service -Name "XblAuthManager" -Force       # Xbox Live Auth (not needed on servers)
Disable-Service -Name "XblGameSave" -Force           # Xbox Game Save
Disable-Service -Name "MapsBroker" -Force            # Downloaded Maps Manager
Disable-Service -Name "lfsvc" -Force                 # Geolocation Service
Disable-Service -Name "SharedAccess" -Force           # ICS (Internet Connection Sharing)
```

## 6. Configure Windows Update for Non-Deferral

```powershell
# Set updates to auto-download and auto-install
$AU = (New-Object -ComObject Microsoft.Update.AutoUpdate)
$AU.Results

# Verify update settings
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue
```

## 7. OS Version Management

Ensure Windows Servers are running supported versions. Unsupported versions no longer receive security updates and should be upgraded immediately [2].

```powershell
# Check current OS version
systeminfo | Select-String "OS Name|OS Version|System Type"

# Check Windows Server licensing status
slmgr /dli
```

## References

[2] [Windows Server 2025 Security Hardening | IT Blog](https://www.informaticar.net/windows-server-2025-security-hardening/)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
