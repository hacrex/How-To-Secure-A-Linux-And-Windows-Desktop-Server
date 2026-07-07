# 03 - Linux Network Security

Network security is a critical component of server hardening, protecting your Linux server from external and internal network-based threats. This section covers firewall configuration, intrusion detection, and network service hardening.

## 1. Firewall Configuration

A firewall controls incoming and outgoing network traffic based on predefined security rules. It is essential to have a properly configured firewall to restrict access to only necessary services.

### Using UFW (Uncomplicated Firewall)

UFW is a user-friendly frontend for `iptables` that simplifies firewall management, especially for single servers.

1.  **Install UFW**:
    ```bash
    sudo apt install ufw -y
    ```
2.  **Enable UFW and Set Default Policies**:
    ```bash
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw enable
    ```
3.  **Allow Essential Services**:
    Allow SSH (port 22), HTTP (port 80), and HTTPS (port 443). Adjust ports as per your server's services.
    ```bash
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    # Or by port number
    # sudo ufw allow 22/tcp
    # sudo ufw allow 80/tcp
    # sudo ufw allow 443/tcp
    ```
4.  **Check UFW Status**:
    ```bash
    sudo ufw status verbose
    ```

### Using `iptables`

`iptables` is a powerful, low-level firewall utility. While more complex than UFW, it offers granular control. For persistent `iptables` rules, you typically save them and restore them on boot.

**Example Basic `iptables` Rules (for IPv4)**:

```bash
# Flush all existing rules
sudo iptables -F
sudo iptables -X
sudo iptables -Z

# Set default policies to DROP incoming and FORWARD, ALLOW outgoing
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback interface
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (port 22)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP (port 80)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow HTTPS (port 443)
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Save iptables rules (distribution-dependent, e.g., for Debian/Ubuntu)
sudo apt install iptables-persistent -y
sudo netfilter-persistent save
```

## 2. Intrusion Detection and Prevention Systems (IDPS)

IDPS solutions monitor network traffic and system logs for suspicious activity and can automatically block malicious sources.

### Fail2Ban

Fail2Ban scans log files (e.g., `/var/log/auth.log`, `/var/log/apache/access.log`) for suspicious patterns like repeated failed login attempts and bans the offending IP addresses using firewall rules.

1.  **Install Fail2Ban**:
    ```bash
    sudo apt install fail2ban -y
    ```
2.  **Configure Fail2Ban**:
    Copy the default configuration file to a local version to avoid overwrites during updates:
    ```bash
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    ```
    Edit `/etc/fail2ban/jail.local` to enable and configure jails. For example, to enable SSH protection:
    ```ini
    [sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```
3.  **Restart Fail2Ban**:
    ```bash
    sudo systemctl restart fail2ban
    ```

### CrowdSec

CrowdSec is a modern, collaborative, and open-source IPS that detects and responds to various attacks by leveraging a global IP reputation database.

1.  **Install CrowdSec**:
    Follow the official installation instructions for your distribution (e.g., for Debian/Ubuntu):
    ```bash
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
    sudo apt install crowdsec crowdsec-firewall-bouncer-iptables -y
    ```
2.  **Configure and Start CrowdSec**:
    CrowdSec typically starts automatically after installation. You can check its status:
    ```bash
    sudo systemctl status crowdsec
    sudo systemctl status crowdsec-firewall-bouncer
    ```
3.  **Explore Scenarios and Collections**:
    CrowdSec uses scenarios to detect attacks. You can install additional collections for specific services (e.g., Nginx, Apache, WordPress):
    ```bash
    sudo cscli collections install crowdsecurity/nginx
    sudo cscli collections install crowdsecurity/apache2
    ```

## 3. Network Service Hardening

Beyond firewalls and IDPS, individual network services should be hardened to minimize vulnerabilities.

### Disable Unused Network Services

As mentioned in the initial hardening section, disable any network services that are not actively used. This reduces the attack surface by closing unnecessary ports.

### Secure DNS Resolution

Configure your server to use trusted and secure DNS resolvers (e.g., your organization's internal DNS, or public resolvers like Cloudflare DNS, Google DNS) and ensure DNSSEC is used if possible.

### Restrict Network Access to Sensitive Services

For services that should only be accessible from specific internal networks or trusted IPs, configure their respective configuration files or firewall rules to enforce these restrictions. For example, a database server should typically only accept connections from application servers, not the entire internet.

### Implement VPN for Remote Administration

Instead of directly exposing services like SSH or RDP to the internet, consider setting up a Virtual Private Network (VPN). This creates an encrypted tunnel, allowing remote administrators to securely access internal network resources as if they were on the local network. Only the VPN server needs to be exposed to the internet, significantly reducing the attack surface. Examples include OpenVPN or WireGuard.
