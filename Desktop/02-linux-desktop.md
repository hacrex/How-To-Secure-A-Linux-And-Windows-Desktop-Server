# Linux Desktop Hardening

This guide covers security hardening for Linux desktop systems (Ubuntu, Fedora, Arch, Debian, etc.).

## 1. Automatic Security Updates

```bash
# Debian/Ubuntu
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Fedora
sudo dnf install dnf-automatic -y
sudo systemctl enable --now dnf-automatic.timer

# Arch (using pacman-contrib)
sudo pacman -S pacman-contrib
# Add to crontab: 0 3 * * * pacman -Syu --noconfirm
```

## 2. Firewall

```bash
# Ubuntu/Debian — UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose

# Fedora/RHEL — firewalld
sudo systemctl enable --now firewalld
sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

## 3. Disk Encryption (LUKS)

Full disk encryption should be configured during OS installation. For additional encrypted volumes:

```bash
# Encrypt a USB drive or secondary partition
sudo cryptsetup -y --type luks2 luksFormat /dev/sdb1
sudo cryptsetup luksOpen /dev/sdb1 myencrypted
sudo mkfs.ext4 /dev/mapper/myencrypted
sudo mkdir /mnt/encrypted
sudo mount /dev/mapper/myencrypted /mnt/encrypted
```

## 4. User Account Hardening

```bash
# Set strong password policy
sudo apt install libpam-pwquality -y  # Debian/Ubuntu
# Edit /etc/security/pam_pwquality.conf:
# minlen = 14
# ucredit = -1
# lcredit = -1
# dcredit = -1
# ocredit = -1

# Set password expiration (90 days)
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

# Use a standard user account, not root
# Add user to sudo group if needed
sudo usermod -aG sudo $USER  # Debian/Ubuntu
sudo usermod -aG wheel $USER  # Fedora/RHEL
```

## 5. SSH Hardening (if SSH is enabled)

```bash
# Edit /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
# KbdInteractiveAuthentication no
# MaxAuthTries 3
# ClientAliveInterval 300
# ClientAliveCountMax 3

# Use only strong algorithms:
# KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256
# Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
# MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

sudo systemctl restart sshd
```

## 6. File Permissions

```bash
# Secure home directory
chmod 700 ~

# Secure SSH keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_* 2>/dev/null
chmod 644 ~/.ssh/*.pub 2>/dev/null
chmod 600 ~/.ssh/authorized_keys 2>/dev/null

# Find world-writable files
sudo find / -xdev -type f -perm -0002 -ls 2>/dev/null

# Find SUID/SGID files (review for necessity)
sudo find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -ls 2>/dev/null
```

## 7. Disable Unnecessary Services

```bash
# List running services
systemctl list-units --type=service --state=running

# Common services to disable on desktops:
sudo systemctl disable --now cups.service  # Printing (if not needed)
sudo systemctl disable --now avahi-daemon.service  # mDNS (if not needed)
sudo systemctl disable --now bluetooth.service  # Bluetooth (if not used)
```

## 8. Browser Hardening

- Use Firefox with Enhanced Tracking Protection (Strict mode)
- Enable HTTPS-Only Mode
- Install uBlock Origin for ad/tracker blocking
- Disable or review extensions
- Use privacy-focused DNS (Cloudflare, Quad9)

```bash
# Set DNS to Cloudflare
sudo nmcli con mod "Wi-Fi Connection" ipv4.dns "1.1.1.1 1.0.0.1"
sudo nmcli con mod "Wi-Fi Connection" ipv4.ignore-auto-dns yes
```

## 9. AppArmor / SELinux

```bash
# Check status
aa-status  # AppArmor
sestatus    # SELinux

# Ensure AppArmor is enforcing
sudo aa-enforce /etc/apparmor.d/* 2>/dev/null
```

## 10. USB Device Restrictions

```bash
# Disable USB storage (if not needed)
echo "blacklist usb-storage" | sudo tee /etc/modprobe.d/blacklist-usb-storage.conf
sudo update-initramfs -u  # Debian/Ubuntu
sudo dracut -f  # Fedora/RHEL
```

## Quick Checklist

- [ ] Automatic security updates enabled
- [ ] Firewall enabled (default deny inbound)
- [ ] Full disk encryption (LUKS) enabled
- [ ] Standard user account for daily use
- [ ] Strong password policy configured
- [ ] SSH hardened (if enabled)
- [ ] Home directory permissions set (700)
- [ ] Unnecessary services disabled
- [ ] Browser hardened (HTTPS-only, uBlock Origin)
- [ ] AppArmor/SELinux in enforcing mode
- [ ] USB storage restricted (if not needed)
- [ ] Screen lock configured
