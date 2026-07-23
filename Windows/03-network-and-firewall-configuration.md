# 03 - Windows Network and Firewall Configuration

Securing network access is critical for protecting Windows Servers from external and internal threats. This section outlines best practices for configuring network settings and the Windows Firewall.

## 1. Network Configuration

### Disable Unnecessary Protocols

Disable NetBIOS over TCP/IP and LMHosts lookup if not required for legacy software [4].

```powershell
# Disable NetBIOS on all network adapters
Get-NetAdapter | ForEach-Object {
    $adapter = $_
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\Tcpip_$($adapter.InterfaceGuid)"
    Set-ItemProperty -Path $regPath -Name "NetbiosOptions" -Value 2 -ErrorAction SilentlyContinue
    Write-Host "Disabled NetBIOS on: $($adapter.Name)"
}

# Disable LMHOSTS lookup
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableLMHOSTS" -Value 0

# Disable LLMNR (Link-Local Multicast Name Resolution)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 0
```

### Disable SMBv1 (Critical Security Risk)

```powershell
# Check if SMBv1 is enabled
Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol

# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# Disable SMBv1 via Windows Feature
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart
```

## 2. Windows Firewall Configuration

### Verify Firewall Status

```powershell
# Check firewall status for all profiles
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# Ensure all profiles are enabled with block-by-default inbound
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Allow
```

### Create Firewall Rules

```powershell
# Allow inbound RDP (port 3389) only from specific subnet
New-NetFirewallRule -DisplayName "Allow RDP from Management" `
    -Direction Inbound -Protocol TCP -LocalPort 3389 `
    -RemoteAddress "10.0.0.0/24" -Action Allow -Profile Domain

# Allow inbound HTTPS (port 443) for web servers
New-NetFirewallRule -DisplayName "Allow HTTPS Inbound" `
    -Direction Inbound -Protocol TCP -LocalPort 443 `
    -Action Allow -Profile Domain,Private

# Block outbound SMB (port 445) to prevent data exfiltration
New-NetFirewallRule -DisplayName "Block Outbound SMB" `
    -Direction Outbound -Protocol TCP -RemotePort 445 `
    -Action Block -Profile Domain,Private,Public

# Block inbound Telnet (port 23)
New-NetFirewallRule -DisplayName "Block Telnet" `
    -Direction Inbound -Protocol TCP -LocalPort 23 `
    -Action Block -Profile Domain,Private,Public
```

### Review Existing Firewall Rules

```powershell
# List all enabled inbound allow rules
Get-NetFirewallRule -Direction Inbound -Enabled True -Action Allow |
    Select-Object DisplayName, Profile, @{N='LocalPort';E={$_ | Get-NetFirewallPortFilter | Select-Object -ExpandProperty LocalPort}} |
    Sort-Object DisplayName

# Find rules allowing traffic from any source (potential risk)
Get-NetFirewallRule -Direction Inbound -Enabled True -Action Allow |
    Where-Object {($_ | Get-NetFirewallAddressFilter).RemoteAddress -eq "Any"} |
    Select-Object DisplayName, Profile
```

## 3. RDP Security Hardening

```powershell
# Enable Network Level Authentication (NLA)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1

# Set encryption level to High
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MinEncryptionLevel" -Value 3

# Limit number of concurrent RDP sessions
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MaxInstanceCount" -Value 2

# Set idle session limit (15 minutes)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MaxIdleTime" -Value 900000

# Disable clipboard redirection (optional, prevents data exfiltration via RDP)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableClipRedirection" -Value 1

# Disable drive redirection (optional)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableCdm" -Value 1
```

## 4. Network Segmentation

Isolate servers using VLANs or subnets [4].

```powershell
# View current network adapter configuration
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressFamily

# View routing table
Get-NetRoute | Select-Object DestinationPrefix, NextHop, InterfaceAlias, RouteMetric

# View DNS configuration
Get-DnsClientServerAddress | Select-Object InterfaceAlias, ServerAddresses
```

## References

[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
