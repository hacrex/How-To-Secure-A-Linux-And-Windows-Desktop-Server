# Automation Scripts

This section provides automation scripts to streamline the implementation of security hardening steps outlined in this repository. Scripts are organized by platform:

- **[Linux (Ansible)](./Linux/README.md)** - Ansible playbooks for automated Linux server hardening
- **[Windows (PowerShell)](./Windows/README.md)** - PowerShell scripts for automated Windows Server hardening

## Purpose

Manual security configuration is error-prone and difficult to maintain at scale. These automation scripts help ensure:

- **Consistency** - Same configuration applied across all servers
- **Repeatability** - Run the same hardening steps on new servers
- **Auditability** - Scripts serve as documentation of security configurations
- **Speed** - Reduce hours of manual work to minutes

## Platform-Specific Guides

| Platform | Tool | Directory |
|----------|------|-----------|
| Linux | Ansible | [`Automation/Linux/`](./Linux/README.md) |
| Windows | PowerShell | [`Automation/Windows/`](./Windows/README.md) |

## Getting Started

### Linux (Ansible)

1. Install Ansible on your control machine
2. Set up passwordless SSH access to target servers
3. Define your inventory file
4. Run the desired playbook

See the [Linux Automation Guide](./Linux/README.md) for detailed instructions.

### Windows (PowerShell)

1. Open PowerShell as Administrator
2. Set execution policy: `Set-ExecutionPolicy RemoteSigned`
3. Run the desired script

See the [Windows Automation Guide](./Windows/README.md) for detailed instructions.

## Important Notes

- **Test first**: Always test scripts in a non-production environment before deploying to production servers
- **Review before running**: Understand what each script does and customize variables as needed
- **Back up**: Create a system restore point or backup before applying hardening changes
