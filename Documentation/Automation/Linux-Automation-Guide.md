# Linux Automation with Ansible: Detailed Guide

This guide provides detailed instructions on how to use the Ansible playbooks located in the `Automation/Linux/` directory to automate the hardening of your Linux servers. It covers prerequisites, setup, and usage for each playbook.

## 🚀 Prerequisites

Before you begin, ensure you have the following:

*   **Ansible Control Machine**: A Linux machine with Ansible installed. You can install Ansible using your distribution's package manager (e.g., `sudo apt install ansible` for Debian/Ubuntu, `sudo yum install ansible` for RHEL/CentOS).
*   **SSH Access**: The Ansible control machine must have SSH access to your target Linux servers. It is highly recommended to use SSH key-based authentication for security. Ensure the SSH user on the target servers has `sudo` privileges without requiring a password (configured via `/etc/sudoers`).
*   **Python**: Python 3 must be installed on the target Linux servers, as Ansible modules rely on it.

## 🛠️ Setup and Configuration

1.  **Clone the Repository**: If you haven't already, clone the `How-To-Secure-A-Linux-And-Windows-Server` repository to your Ansible control machine:
    ```bash
    git clone https://github.com/hacrex/How-To-Secure-A-Linux-And-Windows-Server.git
    cd How-To-Secure-A-Linux-And-Windows-Server/Automation/Linux
    ```

2.  **Create an Inventory File**: Create an `inventory.ini` file in the `Automation/Linux/` directory. This file lists your target servers.
    ```ini
    # inventory.ini
    [linux_servers]
    your_linux_server_ip_1 ansible_user=your_ssh_user
    your_linux_server_ip_2 ansible_user=your_ssh_user
    # Add more servers as needed

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
    ```
    *   Replace `your_linux_server_ip_x` with the actual IP addresses or hostnames of your Linux servers.
    *   Replace `your_ssh_user` with the username you use to SSH into these servers.

3.  **Customize Playbooks (Optional)**: Review the playbooks (`.yml` files) and `jail.local` to customize variables or settings according to your specific environment and security requirements.

## 📚 Playbook Usage

Navigate to the `Automation/Linux/` directory in your terminal.

### 1. `initial_hardening.yml`

This playbook performs initial server setup, updates, and basic security configurations.

**What it does:**
*   Updates package cache and upgrades all installed packages.
*   Installs and enables `unattended-upgrades` (Debian/Ubuntu) for automatic security updates.
*   Removes unused packages.

**How to run:**
```bash
ansible-playbook -i inventory.ini initial_hardening.yml
```

### 2. `user_management.yml`

This playbook manages user accounts, deploys SSH keys, and configures sudo privileges.

**What it does:**
*   Enforces strong password policies using `pam_pwquality`.
*   Configures password expiration in `/etc/login.defs`.
*   Creates specified SSH users and deploys their public keys.
*   Disables password authentication and root login for SSH.
*   Adds users to the `sudo` or `wheel` group.

**How to run:**
Before running, edit the `ssh_users` variable in `user_management.yml` to define your users and their SSH public keys.
```yaml
# Example in user_management.yml
  vars:
    ssh_users:
      - username: alice
        ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... alice@example.com"
      - username: bob
        ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... bob@example.com"
```
Then execute:
```bash
ansible-playbook -i inventory.ini user_management.yml
```

### 3. `network_firewall.yml`

This playbook configures the firewall (UFW for Debian/Ubuntu, firewalld for RHEL/CentOS) and installs/configures Fail2Ban.

**What it does:**
*   Installs and enables UFW or firewalld.
*   Sets default firewall policies (deny incoming, allow outgoing).
*   Allows SSH, HTTP, and HTTPS traffic.
*   Installs and configures Fail2Ban to protect SSH from brute-force attacks.

**How to run:**
Ensure the `jail.local` file is in the same directory as the playbook if you customized it.
```bash
ansible-playbook -i inventory.ini network_firewall.yml
```

### 4. `kernel_hardening.yml`

This playbook applies various `sysctl` parameters for kernel hardening and secures the `/proc` filesystem.

**What it does:**
*   Applies a comprehensive set of `sysctl` parameters to enhance network and kernel security.
*   Ensures `/proc` is mounted with `hidepid=2` to restrict process visibility.

**How to run:**
```bash
ansible-playbook -i inventory.ini kernel_hardening.yml
```

### 5. `application_security.yml`

This playbook focuses on hardening the Nginx web server.

**What it does:**
*   Ensures Nginx is installed.
*   Disables Nginx server tokens.
*   Adds various HTTP security headers (CSP, X-Frame-Options, X-XSS-Protection, Referrer-Policy, Permissions-Policy, X-Content-Type-Options).
*   Sets `client_max_body_size`.

**How to run:**
```bash
ansible-playbook -i inventory.ini application_security.yml
```

### 6. `auditing_logging.yml`

This playbook configures auditing and logging tools.

**What it does:**
*   Ensures `rsyslog` is installed and secures `/var/log` permissions.
*   Installs and initializes AIDE for file integrity monitoring and schedules daily checks.
*   Installs and configures Rkhunter and Chkrootkit for rootkit detection and schedules daily checks.
*   Installs Lynis for security auditing and schedules weekly audits.

**How to run:**
```bash
ansible-playbook -i inventory.ini auditing_logging.yml
```

## ⚠️ Important Considerations

*   **Testing**: Always test these playbooks in a development or staging environment before deploying them to production servers.
*   **Customization**: Review each playbook and adjust variables or tasks to fit your specific server roles, applications, and security policies.
*   **Backup**: Ensure you have proper backups of your server configurations and data before running any automation scripts.
*   **Idempotency**: While Ansible is idempotent, always verify the desired state after running playbooks, especially for complex configurations.
