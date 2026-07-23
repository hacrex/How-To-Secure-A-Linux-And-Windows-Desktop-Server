# 04 - Windows Encryption and Data Protection

Protecting data at rest and in transit is fundamental for Windows Server security. This section covers key encryption technologies and best practices.

## 1. BitLocker Drive Encryption

BitLocker provides full volume encryption to protect data even if the physical drive is removed from the server [4].

### Enable BitLocker

```powershell
# Check if TPM is available and ready
Get-Tpm | Select-Object TpmPresent, TpmReady, TpmEnabled

# Enable BitLocker on the OS drive (requires TPM)
Enable-BitLocker -MountPoint "C:" -TpmProtector -EncryptionMethod XtsAes256

# Enable BitLocker with TPM + PIN (more secure)
Enable-BitLocker -MountPoint "C:" -TpmAndPinProtector -EncryptionMethod XtsAes256

# Enable BitLocker on a data drive
Enable-BitLocker -MountPoint "D:" -RecoveryPasswordProtector -EncryptionMethod XtsAes256

# Check BitLocker status
Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, ProtectionStatus, EncryptionPercentage
```

### Manage Recovery Keys

```powershell
# Back up recovery key to Active Directory (domain-joined)
Backup-BitLockerProtector -MountPoint "C:" -KeyProtectorId (Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}).KeyProtectorId

# Back up recovery key to file
$recoveryKey = (Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"})
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $recoveryKey.KeyProtectorId -Path "D:\RecoveryKeys\C_RecoveryKey.txt"

# View current recovery key
Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"} | Select-Object KeyProtectorId, @{N='RecoveryPassword';E={$_.RecoveryPassword}}
```

## 2. Encrypt Sensitive Data with EFS or DPAPI

```powershell
# Encrypt a file using EFS (Encrypting File System)
cipher /e "C:\SensitiveData\confidential.txt"

# Encrypt an entire folder
cipher /e /s:"C:\SensitiveData"

# Verify encryption status
cipher "C:\SensitiveData"

# Decrypt a file
cipher /d "C:\SensitiveData\confidential.txt"
```

## 3. IPsec for Network Traffic Encryption

IPsec encrypts network traffic between servers, ensuring data confidentiality and integrity in transit [4].

```powershell
# Create an IPsec rule to encrypt traffic between two servers
New-NetIPsecRule -DisplayName "Encrypt Server Traffic" `
    -InboundSecurity Require -OutboundSecurity Require `
    -LocalAddress "10.0.1.10" -RemoteAddress "10.0.1.20" `
    -Protocol Any -Action Allow

# Create IPsec rule for a specific subnet
New-NetIPsecRule -DisplayName "Encrypt DB Traffic" `
    -InboundSecurity Require -OutboundSecurity Require `
    -LocalAddress "10.0.2.0/24" -RemoteAddress "10.0.3.0/24" `
    -Protocol TCP -LocalPort 1433 -RemotePort 1433 -Action Allow

# View active IPsec rules
Get-NetIPsecRule | Select-Object DisplayName, Direction, Action, Enabled

# View IPsec main mode settings
Get-NetIPsecMainModeRule | Select-Object DisplayName, Mode, Enabled
```

## 4. TLS/SSL Configuration

Ensure only strong TLS protocols are enabled and weak ones are disabled.

```powershell
# Disable SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1 (weak protocols)
$protocols = @("SSL 2.0", "SSL 3.0", "TLS 1.0", "TLS 1.1")
foreach ($protocol in $protocols) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server"
    New-Item -Path $path -Force | Out-Null
    Set-ItemProperty -Path $path -Name "Enabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $path -Name "DisabledByDefault" -Value 1 -Type DWord
    Write-Host "Disabled $protocol"
}

# Enable TLS 1.2 and TLS 1.3
$strongProtocols = @("TLS 1.2", "TLS 1.3")
foreach ($protocol in $strongProtocols) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server"
    New-Item -Path $path -Force | Out-Null
    Set-ItemProperty -Path $path -Name "Enabled" -Value 1 -Type DWord
    Set-ItemProperty -Path $path -Name "DisabledByDefault" -Value 0 -Type DWord
    Write-Host "Enabled $protocol"
}

# Verify enabled protocols
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" | ForEach-Object {
    $proto = $_.PSChildName
    $server = Get-ItemProperty "$($_.PSPath)\Server" -ErrorAction SilentlyContinue
    Write-Host "$proto - Enabled: $($server.Enabled), DisabledByDefault: $($server.DisabledByDefault)"
}
```

## References

[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
