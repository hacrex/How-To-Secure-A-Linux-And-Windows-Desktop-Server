# Windows Automation with PowerShell

This directory contains PowerShell scripts designed to automate various Windows Server hardening steps. These scripts can be executed directly on Windows Server machines or managed via tools like Group Policy, SCCM, or Azure Automation.

## 🚀 Getting Started

### Prerequisites

*   **PowerShell**: Ensure PowerShell 5.1 or PowerShell Core (7.x) is installed on the target Windows Server.
*   **Administrative Privileges**: Scripts must be run with administrative privileges.
*   **Execution Policy**: Set the PowerShell execution policy to allow script execution (e.g., `Set-ExecutionPolicy RemoteSigned`).

### Usage

1.  **Copy Script**: Transfer the desired PowerShell script to the target Windows Server.
2.  **Execute Script**: Open PowerShell as an Administrator and run the script.
    ```powershell
    .\script_name.ps1
    ```

## 📚 Available Scripts

*   **`Set-InitialHardening.ps1`**: Automates initial server setup, Windows Update configuration, and basic security settings.
*   **`Manage-UserAccounts.ps1`**: Manages local user accounts, password policies, and LAPS configuration.
*   **`Configure-WindowsFirewall.ps1`**: Configures Windows Firewall rules for essential services.
*   **`Enable-BitLocker.ps1`**: Automates BitLocker drive encryption.
*   **`Install-WindowsUpdates.ps1`**: Automates Windows Update configuration and installation (parity with Linux unattended-upgrades).
*   **`Configure-WindowsAuditPolicy.ps1`**: Configures comprehensive audit policies for security logging (parity with Linux auditing_logging.yml).
*   **`Configure-WindowsSecurityBaseline.ps1`**: Applies security baseline settings including network hardening and system hardening (parity with Linux kernel_hardening.yml and network_firewall.yml).

## ⚠️ Important Notes

*   **Test Thoroughly**: Always test scripts in a non-production environment before deploying to production servers.
*   **Review Scripts**: Understand what each script does before running it. Customize variables and parameters as needed.
*   **Idempotency**: While efforts are made to make scripts idempotent, always verify the state after execution.
