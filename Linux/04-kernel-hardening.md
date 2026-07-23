# 04 - Linux Kernel Hardening

Hardening the Linux kernel is crucial for enhancing the overall security of your server. This involves configuring kernel parameters, securing the `/proc` filesystem, and understanding Linux Security Modules (LSMs).

## 1. `sysctl` Parameter Hardening

The `sysctl` utility allows administrators to modify kernel parameters at runtime. These parameters can significantly impact system security and performance. It is recommended to configure these settings persistently in `/etc/sysctl.conf` or `/etc/sysctl.d/*.conf`.

### Recommended `sysctl` Settings

Below is a comprehensive list of `sysctl` parameters commonly used for hardening a Linux kernel. After adding these to your configuration file, apply them using `sudo sysctl -p`.

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

# Disable IPv6 if not used (optional, but recommended if not needed)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# Randomize virtual memory region placement (ASLR)
kernel.randomize_va_space = 2

# Protect against symlink/hardlink attacks
fs.protected_hardlinks = 1
fs.protected_symlinks = 1

# Disable core dumps for SUID programs
fs.suid_dumpable = 0

# Restrict access to kernel pointers in /proc/kallsyms
kernel.kptr_restrict = 2

# Restrict kernel log access to root only
kernel.dmesg_restrict = 1

# Disable SysRq key (magic SysRq key) to prevent system debugging by unauthorized users
kernel.sysrq = 0

# Disable unprivileged BPF to prevent eBPF-based attacks
kernel.unprivileged_bpf_disabled = 1

# Increase system file descriptor limit
fs.file-max = 65535

# Network performance and buffer tuning (optional, adjust for your workload)
# These are not strictly security-related but are commonly hardened together
net.core.default_qdisc = fq
net.core.dev_weight = 64
net.core.netdev_max_backlog = 16384
net.core.optmem_max = 65535
net.core.rmem_default = 262144
net.core.rmem_max = 16777216
net.core.somaxconn = 32768
net.core.wmem_default = 262144
net.core.wmem_max = 16777216
net.ipv4.conf.all.bootp_relay = 0
net.ipv4.conf.all.forwarding = 0
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.forwarding = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.ip_forward = 0

# ARP spoofing protection
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.default.arp_ignore = 1
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.ipfrag_high_thresh = 262144
net.ipv4.ipfrag_low_thresh = 196608
net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_thresh1 = 32
net.ipv4.neigh.default.gc_thresh2 = 1024
net.ipv4.neigh.default.gc_thresh3 = 2048
net.ipv4.neigh.default.proxy_qlen = 96
net.ipv4.neigh.default.unres_qlen = 6
net.ipv4.route.flush = 1
net.ipv4.tcp_congestion_control = htcp
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_max_orphans = 16384
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_orphan_retries = 0
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_rfc1337 = 1
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.all.autoconf = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.default.accept_ra_defrtr = 0
net.ipv6.conf.default.accept_ra_pinfo = 0
net.ipv6.conf.default.accept_ra_rtr_pref = 0
net.ipv6.conf.default.accept_ra=0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv6.conf.default.autoconf = 0
net.ipv6.conf.default.forwarding = 0
```

**Disclaimer**: Some of these settings can impact system behavior or network connectivity. Always test changes in a non-production environment before applying them to production systems.

> **Warning**: `net.ipv4.icmp_echo_ignore_all = 1` (disabled above for security) breaks Path MTU Discovery, which can cause connectivity issues with VPNs, large file transfers, and certain cloud services. If you experience these issues, remove this line and rely on `icmp_echo_ignore_broadcasts` instead.

## 2. Securing the `/proc` Filesystem

The `/proc` filesystem provides an interface to kernel data structures. Restricting access to certain parts of `/proc` can prevent information disclosure that could be used by attackers.

### Mount `/proc` with `hidepid`

By default, all users can see all running processes in `/proc`. Mounting `/proc` with the `hidepid` option can restrict this visibility.

Add the following line to `/etc/fstab`:

```
proc /proc proc defaults,hidepid=2 0 0
```

*   `hidepid=0`: Default behavior, all users can see all processes.
*   `hidepid=1`: Users can only see their own processes. Processes owned by others are hidden.
*   `hidepid=2`: Users can only see their own processes. All other processes are hidden, even their existence. This is generally the most secure option.

After modifying `/etc/fstab`, remount `/proc` (or reboot):

```bash
sudo mount -o remount /proc
```

### Restrict Access to Kernel Configuration Files

Ensure that sensitive kernel configuration files are not world-readable. While `/proc` entries are often read-only for non-root users, it's good practice to verify permissions.

## 3. Linux Security Modules (LSMs)

Linux Security Modules (LSMs) provide a framework for the Linux kernel to support various security models, including Mandatory Access Control (MAC). The most common LSMs are SELinux and AppArmor.

*   **SELinux (Security-Enhanced Linux)**: Provides a flexible Mandatory Access Control (MAC) system built into the Linux kernel. It allows administrators to define fine-grained permissions for processes, files, and users based on security contexts. SELinux is known for its granular control but has a steeper learning curve.
*   **AppArmor**: A simpler MAC system that confines programs to a limited set of resources. It uses path-based rules and is generally easier to configure and manage than SELinux. AppArmor is often preferred for its ease of use while still providing significant security benefits.

A dedicated section (`07-mac-selinux-apparmor.md`) will delve deeper into the comparison, configuration, and usage of SELinux and AppArmor.
