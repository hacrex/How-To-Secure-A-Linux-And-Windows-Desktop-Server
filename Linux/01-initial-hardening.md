# 01 - Initial Linux Server Hardening

This section covers the essential steps for hardening a Linux server immediately after installation. These foundational practices are crucial for establishing a secure baseline before deploying any services or applications.

## 1. System Updates and Package Management

Keeping your system up-to-date is paramount for security. Regular updates patch known vulnerabilities and improve system stability.

### Update Your System

Immediately after installation, ensure your system is fully updated. This typically involves two steps: updating the package lists and then upgrading all installed packages to their latest versions.

For Debian/Ubuntu-based systems:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
```

For Red Hat/CentOS-based systems (RHEL 8+/CentOS 8+ use `dnf`):

```bash
# Modern RHEL/CentOS (8+) and Fedora
sudo dnf update -y

# Older RHEL/CentOS (7 and below)
sudo yum update -y
```

### Enable Automatic Security Updates

Configure your system to automatically install security updates to ensure timely patching of critical vulnerabilities. This reduces the window of opportunity for attackers.

For Debian/Ubuntu-based systems, install `unattended-upgrades`:

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Follow the prompts to enable automatic updates. You can further configure `unattended-upgrades` by editing `/etc/apt/apt.conf.d/50unattended-upgrades`.

## 2. Secure Boot and BIOS/UEFI Settings

Physical security and secure boot configurations are the first line of defense for your server hardware.

### Secure BIOS/UEFI with a Strong Password

Set a strong, unique password for your server's BIOS/UEFI settings to prevent unauthorized changes to boot order or hardware configurations.

### Configure Boot Order

Ensure the boot order prioritizes the internal hard drive and disables booting from external media (USB, CD/DVD) unless explicitly required and secured.

### Enable Secure Boot

If supported by your hardware and operating system, enable Secure Boot in your UEFI settings. Secure Boot helps protect against malicious code being loaded during the boot process by verifying the digital signatures of boot components.

## 3. Remove Unnecessary Software and Services

Minimizing the software footprint reduces the attack surface. Uninstall any applications or services that are not essential for the server's intended purpose.

### Identify and Remove Unused Packages

Regularly review installed packages and remove those that are no longer needed. This can be done using your distribution's package manager.

For Debian/Ubuntu-based systems:

```bash
sudo apt autoremove -y
sudo apt purge <package_name>
```

For Red Hat/CentOS-based systems:

```bash
sudo dnf autoremove -y    # RHEL 8+/CentOS 8+
sudo dnf remove <package_name>

# Older systems
sudo yum autoremove -y
sudo yum remove <package_name>
```

### Disable Unnecessary Services

Disable services that are not required to run on your server. Use `systemctl` to manage services.

```bash
# List all enabled services
sudo systemctl list-unit-files --type=service --state=enabled

# Review for unnecessary services (common candidates to disable on servers):
# - bluetooth.service (if no Bluetooth hardware)
# - cups.service (if no printing needed)
# - avahi-daemon.service (if no mDNS needed)
# - postfix.service (if no local mail needed)

sudo systemctl disable --now <service_name>
```

### Audit Running Services

Perform a one-time audit to identify all listening services and close unnecessary ones:

```bash
# List all listening services and their ports
sudo ss -tulnp

# Check for unexpected services
sudo systemctl list-units --type=service --state=running

# Verify no unauthorized services are listening on sensitive ports
sudo ss -tlnp | grep -E ':(22|23|21|25|110|143|3389|5900) '
```

## 4. Hardening the `sysctl` Parameters

The `sysctl` utility allows you to modify kernel parameters at runtime, which can be used to enhance system security. The existing `linux-kernel-sysctl-hardening.md` will be integrated into a dedicated kernel hardening section, but some initial parameters can be set here.

### Example `sysctl` Hardening (Basic)

Add the following lines to `/etc/sysctl.conf` to apply basic network and memory hardening. After editing, apply the changes with `sudo sysctl -p`.

```ini
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcasts to prevent snooping
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Protect against SYN flood attacks
net.ipv4.tcp_syncookies = 1

# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Log martian packets
net.ipv4.conf.all.log_martians = 1

# Disable IPv6 if not used (optional)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# Randomize virtual memory region placement
kernel.randomize_va_space = 2
```

**Note**: These are basic recommendations. A more comprehensive `sysctl` hardening guide will be available in the kernel hardening section.

## 5. File Permission Hardening

Restrict permissions on sensitive system files to prevent unauthorized access and privilege escalation.

### Critical System Files

```bash
# /etc/shadow - only root should read password hashes
sudo chmod 640 /etc/shadow
sudo chown root:shadow /etc/shadow

# /etc/gshadow - group password information
sudo chmod 640 /etc/gshadow
sudo chown root:shadow /etc/gshadow

# /etc/passwd - user database (world-readable is required)
sudo chmod 644 /etc/passwd
sudo chown root:root /etc/passwd

# /etc/group - group database
sudo chmod 644 /etc/group
sudo chown root:root /etc/group

# /etc/sudoers - sudo configuration (use visudo to edit)
sudo chmod 440 /etc/sudoers
sudo chown root:root /etc/sudoers

# SSH directory and keys
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/id_rsa 2>/dev/null
sudo chmod 644 /root/.ssh/id_rsa.pub 2>/dev/null
```

### Verify Permissions

```bash
# Audit permissions on critical files
sudo stat -c '%a %U:%G %n' /etc/shadow /etc/gshadow /etc/passwd /etc/group /etc/sudoers

# Find world-writable files (potential security risk)
sudo find / -xdev -type f -perm -0002 -ls 2>/dev/null

# Find files with SUID/SGID bits (review for necessity)
sudo find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -ls 2>/dev/null
```
