# Windows Automation with PowerShell: Detailed Guide

This guide provides detailed instructions on how to use the PowerShell scripts located in the `Automation/Windows/` directory to automate the hardening of your Windows Server environments. It covers prerequisites, setup, and usage for each script.

## 🚀 Prerequisites

Before you begin, ensure you have the following:

*   **Windows Server**: A target Windows Server machine (e.g., Windows Server 2019, 2022, 2025).
*   **PowerShell**: PowerShell 5.1 (default on most modern Windows Servers) or PowerShell Core (7.x) installed. Some cmdlets might require specific PowerShell versions.
*   **Administrative Privileges**: The user executing the scripts must have local administrator privileges on the target server.
*   **PowerShell Execution Policy**: The PowerShell execution policy must allow script execution. You can set it using:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    ```
    This allows scripts created on the local machine or signed by a trusted publisher to run.

## 🛠️ Setup and Configuration

1.  **Clone the Repository**: If you haven't already, clone the `How-To-Secure-A-Linux-And-Windows-Server` repository to your Windows Server or a management workstation:
    ```powershell
    # Using Git (if installed)
    git clone https://github.com/hacrex/How-To-Secure-A-Linux-And-Windows-Server.git
    Set-Location How-To-Secure-A-Linux-And-Windows-Server\Automation\Windows

    # Alternatively, download the scripts manually.
    ```

2.  **Review and Customize Scripts**: Open each `.ps1` script in a text editor (like VS Code or Notepad++) and review its contents. Customize any parameters or logic to fit your specific environment and security requirements. Pay close attention to parameters like `NewAdministratorName` or `AllowedRDPips`.

## 📚 Script Usage

Navigate to the `Automation/Windows/` directory in your PowerShell console (run as Administrator).

### 1. `Set-InitialHardening.ps1`

This script automates initial server setup, Windows Update configuration, and basic security settings.

**What it does:**
*   Configures Windows Update to automatically download and schedule the installation of updates.
*   Disables the built-in Guest account.
*   Optionally renames the built-in Administrator account to a less predictable name (default: `SecAdmin`).
*   Configures basic audit policies (e.g., for logon/logoff events).

**How to run:**
```powershell
.\Set-InitialHardening.ps1 -RenameAdministrator $true -NewAdministratorName "MySecureAdmin"
```
*   To skip renaming the Administrator account: `.\Set-InitialHardening.ps1 -RenameAdministrator $false`

### 2. `Manage-UserAccounts.ps1`

This script automates user and service account management, including password policies and LAPS configuration.

**What it does:**
*   Configures local password policies (minimum length, complexity, history, maximum age).
*   Configures account lockout policies (threshold, duration, reset counter).
*   Includes a placeholder to disable unused local accounts (requires customization to identify accounts).
*   Provides guidance for LAPS configuration (LAPS itself requires Active Directory deployment).

**How to run:**
```powershell
.\Manage-UserAccounts.ps1 -MinimumPasswordLength 14 -PasswordComplexityEnabled $true -MaximumPasswordAgeDays 90 -AccountLockoutThreshold 5
```
*   To configure LAPS (after domain deployment): `.\Manage-UserAccounts.ps1 -ConfigureLAPS $true`

### 3. `Configure-WindowsFirewall.ps1`

This script configures Windows Firewall rules for essential services.

**What it does:**
*   Sets the default inbound policy to `Block` for all firewall profiles (Domain, Private, Public).
*   Ensures Windows Firewall is enabled for all profiles.
*   Creates rules to allow inbound RDP (port 3389), HTTP (port 80), and HTTPS (port 443) traffic.
*   Allows specifying allowed source IP addresses for RDP.

**How to run:**
```powershell
.\Configure-WindowsFirewall.ps1 -AllowRDP $true -AllowedRDPips ("192.168.1.100", "10.0.0.0/8") -AllowHTTP $true -AllowHTTPS $true
```
*   To only allow RDP from specific IPs: `.\Configure-WindowsFirewall.ps1 -AllowRDP $true -AllowedRDPips ("192.168.1.10", "172.16.0.0/16")`
*   To disable HTTP: `.\Configure-WindowsFirewall.ps1 -AllowHTTP $false`

### 4. `Enable-BitLocker.ps1`

This script enables BitLocker encryption on a specified data volume and saves the recovery key.

**What it does:**
*   Checks if the BitLocker Drive Encryption feature is installed.
*   Enables BitLocker on a specified data drive (e.g., `D:`).
*   Saves the BitLocker recovery key to a specified path.

**How to run:**
```powershell
.\Enable-BitLocker.ps1 -DriveLetter 'D' -RecoveryKeyPath 'C:\BitLockerRecoveryKeys'
```
*   **Important**: Ensure the BitLocker feature is installed (`Install-WindowsFeature -Name BitLocker -IncludeAllSubFeature -IncludeManagementTools`) before running this script.
*   This script is primarily for *data volumes*. Encrypting the OS volume is typically done during OS installation and is more complex.

## ⚠️ Important Considerations

*   **Testing**: Always test these scripts in a development or staging environment before deploying them to production servers.
*   **Customization**: Review each script and adjust parameters or logic to fit your specific server roles, applications, and security policies.
*   **Backup**: Ensure you have proper backups of your server configurations and data before running any automation scripts.
*   **Idempotency**: While efforts are made to make scripts idempotent, always verify the desired state after running scripts, especially for complex configurations.
*   **Group Policy**: For domain-joined Windows Servers, many of these settings are best managed via Group Policy Objects (GPOs) for centralized control and enforcement. These scripts are most suitable for standalone servers or as a baseline for GPO configuration.
