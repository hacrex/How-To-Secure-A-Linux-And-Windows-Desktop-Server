# Configure-WindowsFirewall.ps1
# This script configures Windows Firewall rules for essential services.

<#
.SYNOPSIS
    Configures Windows Firewall to block inbound traffic by default and allows essential services.
.DESCRIPTION
    This script performs the following actions:
    - Sets default inbound policy to Block for all profiles (Domain, Private, Public).
    - Enables Windows Firewall for all profiles.
    - Creates rules to allow inbound traffic for specified ports (e.g., RDP, HTTP, HTTPS).
.PARAMETER AllowRDP
    Specifies whether to allow inbound RDP traffic (port 3389). Default is $true.
.PARAMETER AllowHTTP
    Specifies whether to allow inbound HTTP traffic (port 80). Default is $true.
.PARAMETER AllowHTTPS
    Specifies whether to allow inbound HTTPS traffic (port 443). Default is $true.
.PARAMETER AllowedRDPips
    An array of IP addresses or subnets that are allowed to connect via RDP. If empty, RDP is allowed from any IP. Default is an empty array.
.NOTES
    Always test in a non-production environment first.
    Requires administrative privileges to run.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param
(
    [bool]$AllowRDP = $true,
    [bool]$AllowHTTP = $true,
    [bool]$AllowHTTPS = $true,
    [string[]]$AllowedRDPips = @()
)

function Set-DefaultFirewallPolicy {
    Write-Host "Setting default Windows Firewall policies..."
    if ($PSCmdlet.ShouldProcess("Windows Firewall", "Set default inbound policy to Block")) {
        # Set default inbound policy to Block for all profiles
        Set-NetFirewallProfile -Profile Domain,Private,Public -DefaultInboundAction Block -ErrorAction Stop
        Write-Host "Default inbound action set to Block for Domain, Private, Public profiles."

        # Ensure firewall is enabled for all profiles
        Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -ErrorAction Stop
        Write-Host "Windows Firewall enabled for Domain, Private, Public profiles."
    }
}

function Configure-RDPFirewallRule {
    if ($AllowRDP) {
        Write-Host "Configuring Windows Firewall rule for RDP (port 3389)..."
        $ruleName = "Allow RDP Inbound"
        if ($PSCmdlet.ShouldProcess($ruleName, "Create/Modify firewall rule")) {
            # Remove existing RDP rules to avoid conflicts
            Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false

            $remoteAddress = if ($AllowedRDPips.Count -gt 0) { $AllowedRDPips -join "," } else { "Any" }

            New-NetFirewallRule -DisplayName $ruleName `
                                -Direction Inbound `
                                -Action Allow `
                                -Protocol TCP `
                                -LocalPort 3389 `
                                -RemoteAddress $remoteAddress `
                                -Profile Domain,Private,Public `
                                -Enabled True -ErrorAction Stop
            Write-Host "RDP inbound rule created/modified. Allowed from: $remoteAddress."
        }
    } else {
        Write-Host "RDP inbound traffic is not allowed by script parameter. Ensuring RDP rule is absent/disabled."
        $ruleName = "Allow RDP Inbound"
        Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Disable-NetFirewallRule -Confirm:$false
        Write-Host "RDP inbound rule disabled if it existed."
    }
}

function Configure-HTTPFirewallRule {
    if ($AllowHTTP) {
        Write-Host "Configuring Windows Firewall rule for HTTP (port 80)..."
        $ruleName = "Allow HTTP Inbound"
        if ($PSCmdlet.ShouldProcess($ruleName, "Create/Modify firewall rule")) {
            Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false
            New-NetFirewallRule -DisplayName $ruleName `
                                -Direction Inbound `
                                -Action Allow `
                                -Protocol TCP `
                                -LocalPort 80 `
                                -Profile Domain,Private,Public `
                                -Enabled True -ErrorAction Stop
            Write-Host "HTTP inbound rule created."
        }
    } else {
        Write-Host "HTTP inbound traffic is not allowed by script parameter. Ensuring HTTP rule is absent/disabled."
        $ruleName = "Allow HTTP Inbound"
        Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Disable-NetFirewallRule -Confirm:$false
        Write-Host "HTTP inbound rule disabled if it existed."
    }
}

function Configure-HTTPSFirewallRule {
    if ($AllowHTTPS) {
        Write-Host "Configuring Windows Firewall rule for HTTPS (port 443)..."
        $ruleName = "Allow HTTPS Inbound"
        if ($PSCmdlet.ShouldProcess($ruleName, "Create/Modify firewall rule")) {
            Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false
            New-NetFirewallRule -DisplayName $ruleName `
                                -Direction Inbound `
                                -Action Allow `
                                -Protocol TCP `
                                -LocalPort 443 `
                                -Profile Domain,Private,Public `
                                -Enabled True -ErrorAction Stop
            Write-Host "HTTPS inbound rule created."
        }
    } else {
        Write-Host "HTTPS inbound traffic is not allowed by script parameter. Ensuring HTTPS rule is absent/disabled."
        $ruleName = "Allow HTTPS Inbound"
        Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Disable-NetFirewallRule -Confirm:$false
        Write-Host "HTTPS inbound rule disabled if it existed."
    }
}

# Main execution
if ($PSCmdlet.ShouldProcess("Windows Firewall", "Configure")) {
    Set-DefaultFirewallPolicy
    Configure-RDPFirewallRule
    Configure-HTTPFirewallRule
    Configure-HTTPSFirewallRule
    Write-Host "Windows Firewall configuration completed."
}
