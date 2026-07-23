# 05 - Windows Auditing and Monitoring

Continuous monitoring and auditing are essential for detecting and responding to security incidents in Windows Server environments.

## 1. Enable Comprehensive Audit Policies

Configure audit policies to capture all critical security events [3].

```powershell
# Enable advanced audit policy configuration (replaces legacy audit policy)
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Logoff" /success:enable
auditpol /set /subcategory:"Account Lockout" /success:enable /failure:enable
auditpol /set /subcategory:"Special Logon" /success:enable
auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable /failure:enable

# Account Management
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
auditpol /set /subcategory:"Computer Account Management" /success:enable /failure:enable

# Policy Changes
auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable
auditpol /set /subcategory:"Authentication Policy Change" /success:enable
auditpol /set /subcategory:"Authorization Policy Change" /success:enable

# Privilege Use
auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable /failure:enable

# Object Access
auditpol /set /subcategory:"File System" /success:enable /failure:enable
auditpol /set /subcategory:"Registry" /success:enable /failure:enable
auditpol /set /subcategory:"Kernel Object" /success:enable /failure:enable
auditpol /set /subcategory:"SAM" /success:enable /failure:enable
auditpol /set /subcategory:"Certification Services" /success:enable /failure:enable

# Process Tracking
auditpol /set /subcategory:"Process Creation" /success:enable
auditpol /set /subcategory:"Process Termination" /success:enable

# System
auditpol /set /subcategory:"Security State Change" /success:enable
auditpol /set /subcategory:"Security System Extension" /success:enable
auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable

# Verify all audit settings
auditpol /get /category:*
```

## 2. Critical Windows Event IDs to Monitor

These are the most important Event IDs for security monitoring:

### Authentication Events

| Event ID | Description | Risk Level |
|----------|-------------|------------|
| **4624** | Successful logon | Monitor for unusual sources/times |
| **4625** | Failed logon | Brute-force indicator |
| **4634** | Logoff | Baseline |
| **4648** | Explicit credential logon (runas) | Lateral movement indicator |
| **4672** | Special privileges assigned (admin logon) | High-privilege usage |
| **4776** | NTLM authentication attempt | Credential theft indicator |

### Account Management Events

| Event ID | Description | Risk Level |
|----------|-------------|------------|
| **4720** | User account created | Monitor unauthorized creation |
| **4722** | User account enabled | Monitor changes to disabled accounts |
| **4724** | Password reset attempt | Monitor who resets passwords |
| **4728** | Member added to security group | Privilege escalation |
| **4732** | Member added to local group | Local privilege escalation |
| **4756** | Member added to universal group | Domain-wide escalation |

### Process and Object Events

| Event ID | Description | Risk Level |
|----------|-------------|------------|
| **4688** | New process created | Track process execution (enable command-line logging) |
| **4689** | Process terminated | Baseline |
| **4697** | Service installed | Persistence mechanism |
| **4698** | Scheduled task created | Persistence mechanism |
| **4702** | Scheduled task updated | Task modification |
| **5140** | Network share accessed | Lateral movement |
| **5156** | Windows Filtering Platform allowed connection | Network activity |

## 3. Enable Command-Line Logging

Command-line logging captures the full command executed in process creation events, critical for detecting malicious activity.

```powershell
# Enable command-line process creation logging
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1 -PropertyType DWord -Force

# Enable PowerShell script block logging
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1

# Enable PowerShell module logging
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging" -Value 1
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Name "*" -Value "*" -Force

# Enable PowerShell transcription (logs full session to file)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableTranscripting" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "OutputDirectory" -Value "C:\PSTranscripts"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableInvocationHeader" -Value 1
```

## 4. Centralized Logging

For multi-server environments, centralize logs using a SIEM solution [4].

```powershell
# Forward Security event log to a remote SIEM server
wevtutil set-log Security /remote:SIEM-SERVER /enabled:true

# Configure Windows Event Forwarding (WEF) as a collector
# On the SIEM/collector server:
wecutil qc /q

# On target servers, subscribe to forwarded events
# Use Group Policy: Computer Configuration > Administrative Templates > Windows Components > Event Forwarding
```

## 5. Monitor for Suspicious Activity

```powershell
# Query recent failed logons
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 20 |
    Select-Object TimeCreated, @{N='TargetUser';E={$_.Properties[5].Value}}, @{N='SourceIP';E={$_.Properties[19].Value}}, @{N='LogonType';E={$_.Properties[10].Value}}

# Query new process creation with command lines
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 20 |
    Select-Object TimeCreated, @{N='Process';E={$_.Properties[5].Value}}, @{N='CommandLine';E={$_.Properties[8].Value}}

# Query scheduled task creation
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4698} -MaxEvents 10 |
    Select-Object TimeCreated, @{N='TaskName';E={$_.Properties[1].Value}}

# Query service installations
Get-WinEvent -FilterHashtable @{LogName='System'; ID=7045} -MaxEvents 10 |
    Select-Object TimeCreated, @{N='ServiceName';E={$_.Properties[0].Value}}, @{N='ImagePath';E={$_.Properties[1].Value}}
```

## 6. Regular Risk Assessments

Proactively identify vulnerabilities and threats [4].

```powershell
# Run Windows built-in security scanner
mrt /scan

# Check Windows Defender status
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusEnabled, AntispywareEnabled, QuickScanEndTime, FullScanEndTime

# Review local security policy
secedit /export /cfg "$env:TEMP\secpol.cfg"
Get-Content "$env:TEMP\secpol.cfg"
```

## References

[3] [Security baseline for Windows Server 2025, version 2602](https://techcommunity.microsoft.com/blog/microsoft-security-baselines/security-baseline-for-windows-server-2025-version-2602/4496468)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
