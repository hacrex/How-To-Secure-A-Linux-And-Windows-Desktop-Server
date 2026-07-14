# Configure-WindowsAuditPolicy.ps1
# Automates Windows Audit Policy configuration for security logging
# Equivalent to Linux auditing_logging.yml

param(
    [switch]$ConfigureAll,
    [switch]$AccountLogon,
    [switch]$AccountManagement,
    [switch]$DSAccess,
    [switch]$LogonLogoff,
    [switch]$ObjectAccess,
    [switch]$PolicyChange,
    [switch]$PrivilegeUse,
    [switch]$System,
    [switch]$DetailedTracking
)

$ErrorActionPreference = "Stop"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Log "This script must be run as Administrator" "ERROR"
    exit 1
}

Write-Log "Starting Windows Audit Policy Configuration"

# Define audit policy categories and their subcategories
$auditPolicies = @{
    "AccountLogon" = @(
        "Credential Validation",
        "Kerberos Authentication Service",
        "Kerberos Service Ticket Operations"
    )
    "AccountManagement" = @(
        "Computer Account Management",
        "Distribution Group Management",
        "Other Account Management Events",
        "Security Group Management",
        "User Account Management"
    )
    "DSAccess" = @(
        "Detailed Directory Service Replication",
        "Directory Service Access",
        "Directory Service Changes",
        "Directory Service Replication"
    )
    "LogonLogoff" = @(
        "Account Lockout",
        "Group Membership",
        "IPsec Extended Mode",
        "IPsec Main Mode",
        "IPsec Quick Mode",
        "Logoff",
        "Logon",
        "Network Policy Server",
        "Other Logon/Logoff Events",
        "Special Logon",
        "User / Device Claims"
    )
    "ObjectAccess" = @(
        "Application Generated",
        "Central Policy Staging",
        "Certification Services",
        "Detailed File Share",
        "File Share",
        "Filtering Platform Connection",
        "Filtering Platform Packet Drop",
        "Handle Manipulation",
        "Kernel Object",
        "Other Object Access Events",
        "Registry",
        "Removable Storage",
        "SAM"
    )
    "PolicyChange" = @(
        "Audit Policy Change",
        "Authentication Policy Change",
        "Authorization Policy Change",
        "MPSSVC Rule-Level Policy Change",
        "Other Policy Change Events",
        "Non Sensitive Privilege Use",
        "Sensitive Privilege Use"
    )
    "PrivilegeUse" = @(
        "Non Sensitive Privilege Use",
        "Sensitive Privilege Use"
    )
    "System" = @(
        "IPsec Driver",
        "Other System Events",
        "Security State Change",
        "Security System Extension",
        "System Integrity"
    )
    "DetailedTracking" = @(
        "DPAPI Activity",
        "PNP Activity",
        "Process Creation",
        "Process Termination",
        "RPC Events",
        "Token Right Adjusted Events"
    )
}

function Set-AuditSubcategory {
    param(
        [string]$Subcategory,
        [string]$Setting = "success and failure"
    )
    
    try {
        # Map setting to audit flags
        $auditFlags = switch ($Setting.ToLower()) {
            "success" { 1 }
            "failure" { 2 }
            "success and failure" { 3 }
            "none" { 0 }
            default { 3 }
        }
        
        auditpol /set /subcategory:"$Subcategory" /success:$([bool]($auditFlags -band 1)) /failure:$([bool]($auditFlags -band 2)) | Out-Null
        Write-Log "Configured: $Subcategory -> $Setting"
    } catch {
        Write-Log "Failed to configure: $Subcategory - $_" "WARN"
    }
}

# Determine which policies to configure
$policiesToConfigure = @()

if ($ConfigureAll) {
    $policiesToConfigure = $auditPolicies.Keys
} else {
    if ($AccountLogon) { $policiesToConfigure += "AccountLogon" }
    if ($AccountManagement) { $policiesToConfigure += "AccountManagement" }
    if ($DSAccess) { $policiesToConfigure += "DSAccess" }
    if ($LogonLogoff) { $policiesToConfigure += "LogonLogoff" }
    if ($ObjectAccess) { $policiesToConfigure += "ObjectAccess" }
    if ($PolicyChange) { $policiesToConfigure += "PolicyChange" }
    if ($PrivilegeUse) { $policiesToConfigure += "PrivilegeUse" }
    if ($System) { $policiesToConfigure += "System" }
    if ($DetailedTracking) { $policiesToConfigure += "DetailedTracking" }
    
    # Default to essential policies if none specified
    if ($policiesToConfigure.Count -eq 0) {
        $policiesToConfigure = @("AccountLogon", "AccountManagement", "LogonLogoff", "System", "PolicyChange")
        Write-Log "No specific policies selected. Configuring essential policies by default."
    }
}

# Configure each selected policy category
foreach ($policyCategory in $policiesToConfigure) {
    if ($auditPolicies.ContainsKey($policyCategory)) {
        Write-Log "Configuring $policyCategory policies..."
        foreach ($subcat in $auditPolicies[$policyCategory]) {
            Set-AuditSubcategory -Subcategory $subcat -Setting "success and failure"
        }
    }
}

# Configure Advanced Audit Policy via Group Policy (optional)
Write-Log "`nConfiguring Advanced Audit Policy settings..."

$advAuditPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvancedAuditConfiguration"
if (-not (Test-Path $advAuditPath)) {
    New-Item -Path $advAuditPath -Force | Out-Null
}

# Enable audit policy override
Set-ItemProperty -Path $advAuditPath -Name "SCENoApplyLegacyAuditPolicy" -Value 1 -Type DWORD

Write-Log "`nAudit Policy Configuration completed successfully!"
Write-Host "`nTo verify current audit policy settings, run: auditpol /get /category:*"
Write-Host "`nRecommended next steps:"
Write-Host "  1. Configure Event Log retention policies"
Write-Host "  2. Set up centralized log collection (SIEM)"
Write-Host "  3. Monitor critical event IDs (4624, 4625, 4672, 4720, etc.)"
