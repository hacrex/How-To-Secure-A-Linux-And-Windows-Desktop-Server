# Linux Automation with Ansible

This directory contains Ansible playbooks designed to automate various Linux server hardening steps. Ansible allows for idempotent configuration management, ensuring that systems are configured consistently and securely.

## 🚀 Getting Started

### Prerequisites

*   **Ansible**: Installed on your control machine.
*   **SSH Access**: Passwordless SSH access (using SSH keys) from your control machine to the target Linux servers.
*   **Sudo Privileges**: The SSH user on the target servers must have `sudo` privileges.

### Usage

1.  **Define Inventory**: Create an Ansible inventory file (e.g., `inventory.ini`) listing your target servers.
    ```ini
    [linux_servers]
    your_linux_server_ip ansible_user=your_ssh_user
    ```
2.  **Run Playbook**: Execute the desired playbook using the `ansible-playbook` command.
    ```bash
    ansible-playbook -i inventory.ini playbook_name.yml
    ```

## 📚 Available Playbooks

*   **`initial_hardening.yml`**: Automates initial server setup, updates, and basic security configurations.
*   **`user_management.yml`**: Manages user accounts, SSH key deployment, and sudo privileges.
*   **`network_firewall.yml`**: Configures UFW/firewalld and Fail2Ban.
*   **`kernel_hardening.yml`**: Applies `sysctl` parameters for kernel hardening.

## ⚠️ Important Notes

*   **Test Thoroughly**: Always test playbooks in a non-production environment before deploying to production servers.
*   **Review Playbooks**: Understand what each playbook does before running it. Customize variables as needed.
*   **Idempotency**: Ansible playbooks are designed to be idempotent, meaning they can be run multiple times without causing unintended changes beyond the initial configuration.
