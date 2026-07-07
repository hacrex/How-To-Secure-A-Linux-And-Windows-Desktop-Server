# 06 - Linux Auditing and Logging

Effective auditing and logging are essential for detecting security incidents, troubleshooting system issues, and maintaining compliance. This section covers configuring system logging, file integrity monitoring, and rootkit detection.

## 1. System Logging with rsyslog/journald

Linux systems typically use `rsyslog` or `journald` (part of `systemd`) for logging. Proper configuration ensures that critical security events are captured and stored securely.

### Configure `rsyslog`

`rsyslog` is a powerful logging system that can forward logs to a central server. Ensure it's configured to log important security events.

1.  **Review `rsyslog` Configuration**: The main configuration file is `/etc/rsyslog.conf`, with additional configurations in `/etc/rsyslog.d/`.
2.  **Secure Log Permissions**: Ensure log files have restrictive permissions to prevent unauthorized access.
    ```bash
    sudo chmod -R o-rwx /var/log
    ```
3.  **Remote Logging (Optional)**: For enhanced security and centralized management, configure `rsyslog` to send logs to a remote log server (SIEM).
    Add the following line to `/etc/rsyslog.conf` or a new file in `/etc/rsyslog.d/`:
    ```ini
    *.* @remote-log-server:514
    ```

### Configure `journald`

`journald` captures logs from various sources and stores them in a structured binary format. It can be configured to persist logs across reboots.

1.  **Enable Persistent Logging**: Edit `/etc/systemd/journald.conf` and set `Storage=persistent`.
    ```ini
    [Journal]
    Storage=persistent
    ```
2.  **Restart `journald`**: 
    ```bash
    sudo systemctl restart systemd-journald
    ```
3.  **View Logs**: Use `journalctl` to view logs.
    ```bash
    journalctl -u sshd.service
    journalctl -p err -b
    ```

## 2. File Integrity Monitoring (FIM) with AIDE

File Integrity Monitoring (FIM) tools detect unauthorized changes to critical system files, which can indicate a compromise.

### Install and Configure AIDE

AIDE (Advanced Intrusion Detection Environment) creates a database of system files and their attributes, then compares it against the current state to detect changes.

1.  **Install AIDE**:
    ```bash
    sudo apt install aide aide-common -y
    ```
2.  **Initialize AIDE Database**: This creates a baseline of your system's file integrity. **Run this immediately after a fresh installation and hardening, before any changes are made.**
    ```bash
    sudo aide --init
    sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    ```
3.  **Schedule Regular Checks**: Configure a cron job to run AIDE checks periodically (e.g., daily or weekly).
    Edit `sudo crontab -e` and add:
    ```cron
    0 5 * * * /usr/bin/aide --check
    ```
4.  **Update Database After Legitimate Changes**: After applying system updates or making legitimate configuration changes, update the AIDE database.
    ```bash
    sudo aide --update
    sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    ```

## 3. Rootkit Detection with Rkhunter and Chkrootkit

Rootkits are malicious software designed to hide their presence and maintain privileged access on a system. Rootkit detectors scan for common rootkit signatures and behaviors.

### Install and Run Rkhunter

Rkhunter (Rootkit Hunter) scans for rootkits, backdoors, and local exploits.

1.  **Install Rkhunter**:
    ```bash
    sudo apt install rkhunter -y
    ```
2.  **Update Rkhunter Data Files**:
    ```bash
    sudo rkhunter --update
    sudo rkhunter --propupd
    ```
3.  **Run a Scan**:
    ```bash
    sudo rkhunter --check
    ```
    Review the output carefully for any warnings. Schedule regular scans via cron.

### Install and Run Chkrootkit

Chkrootkit (Check Rootkit) is another tool for detecting rootkits.

1.  **Install Chkrootkit**:
    ```bash
    sudo apt install chkrootkit -y
    ```
2.  **Run a Scan**:
    ```bash
    sudo chkrootkit
    ```
    Review the output for any suspicious findings. Schedule regular scans via cron.

## 4. Security Auditing with Lynis

Lynis is a security auditing tool that performs a comprehensive scan of your system to identify potential vulnerabilities, misconfigurations, and provide hardening recommendations.

1.  **Install Lynis**:
    ```bash
    sudo apt install lynis -y
    ```
2.  **Run a Scan**:
    ```bash
    sudo lynis audit system
    ```
    Review the detailed report and follow the suggestions to improve your server's security posture.

## 5. Host-based Intrusion Detection System (HIDS) with OSSEC

OSSEC is a free, open-source Host-based Intrusion Detection System (HIDS) that performs log analysis, file integrity checking, policy monitoring, rootkit detection, real-time alerting, and active response.

1.  **Install OSSEC**: Installation typically involves downloading the source and compiling, or using a package manager if available for your distribution.
    ```bash
    # Example for Debian/Ubuntu (check official documentation for latest instructions)
    sudo apt install ossec-hids-agent -y # For agent
    sudo apt install ossec-hids-server -y # For server
    ```
2.  **Configure OSSEC**: Configure agents to report to a central OSSEC server for centralized monitoring and management.
3.  **Monitor and Respond**: Regularly review OSSEC alerts and configure active responses to automatically block detected threats.
