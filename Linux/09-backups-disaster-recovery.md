# 09 - Linux Backups and Disaster Recovery

Regular backups and a well-defined disaster recovery plan are crucial components of any robust security strategy. They ensure business continuity and data availability in the event of data loss, system failure, or a security incident.

## 1. Backup Strategy Fundamentals

### 1.1. The 3-2-1-1-0 Backup Rule

The 3-2-1 rule is a widely accepted baseline. The modern 3-2-1-1-0 variant adds critical protections against ransomware and data corruption:

*   **3 copies of your data**: The original data plus at least two backups.
*   **2 different media types**: Store backups on different types of storage (e.g., internal disk, NAS, cloud).
*   **1 offsite copy**: Keep at least one backup copy in a separate geographical location.
*   **1 immutable or air-gapped copy**: At least one copy should be immutable (write-once, cannot be modified or deleted) or air-gapped (physically disconnected from the network). This protects against ransomware that targets backup systems.
*   **0 errors after verification**: Regularly test and verify your backups by performing test restores. An untested backup is not a backup.

### 1.2. What to Back Up

Prioritize backing up critical data and configurations:

*   **User Data**: `/home` directories, application data.
*   **System Configuration Files**: `/etc` directory, especially `/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/sudoers`, `/etc/fstab`, and application-specific configurations.
*   **Databases**: Export database dumps regularly.
*   **Web Server Content**: `/var/www` or similar directories.
*   **Logs**: If not already sent to a centralized logging system, consider backing up critical logs.

### 1.3. Backup Frequency and Retention

Determine how often backups should occur and how long they should be retained based on the criticality of the data and recovery point objectives (RPO).

*   **Full Backups**: Periodically (e.g., weekly or monthly) create a complete copy of all data.
*   **Incremental/Differential Backups**: More frequently (e.g., daily) back up only the data that has changed since the last full or incremental backup.

## 2. Backup Tools for Linux

Several tools are available for performing backups on Linux, ranging from simple archiving utilities to comprehensive backup solutions.

### 2.1. `tar` for Archiving

`tar` is a fundamental utility for creating archives of files and directories.

```bash
# Create a compressed archive of /home and /etc
sudo tar -czvf /mnt/backup/home_etc_$(date +%Y%m%d).tar.gz /home /etc

# Exclude specific directories (e.g., large caches)
sudo tar -czvf /mnt/backup/home_etc_$(date +%Y%m%d).tar.gz --exclude=\*/.cache --exclude=\*/.local/share/Trash /home /etc
```

### 2.2. `rsync` for Incremental Backups

`rsync` is excellent for efficient incremental backups, synchronizing files and directories between locations.

```bash
# Local incremental backup
sudo rsync -avz --delete /source/path/ /destination/path/

# Remote incremental backup via SSH
sudo rsync -avz --delete -e ssh /source/path/ user@remote_host:/destination/path/
```

### 2.3. `BorgBackup` for Deduplicated and Encrypted Backups

`BorgBackup` is a powerful deduplicating archiver with optional encryption and compression. It is highly recommended for robust backup solutions.

1.  **Install BorgBackup**:
    ```bash
    sudo apt install borgbackup -y
    ```
2.  **Initialize a Repository**:
    ```bash
    # Recommended: authenticated and encrypted (repokey,auth)
    # The repository key encrypts data; the auth key prevents tampering
    borg init --encryption=repokey,auth /path/to/backup/repo
    ```
3.  **Create a Backup Archive**:
    ```bash
    borg create --stats --progress /path/to/backup/repo::
{hostname}-{now} /source/data
    ```

4.  **Restore Data**:
    ```bash
    borg extract /path/to/backup/repo::{archive_name} /destination/path
    ```

### 2.4. Cloud Backups

Integrate with cloud storage providers (e.g., AWS S3, Google Cloud Storage, Azure Blob Storage) for offsite backups. Tools like `rclone` can facilitate this.

## 3. Disaster Recovery Planning

A disaster recovery plan (DRP) outlines the procedures to restore business operations after a disruptive event. It should be regularly tested and updated.

### 3.1. Key Components of a DRP

*   **Recovery Point Objective (RPO)**: The maximum acceptable amount of data loss, measured in time (e.g., 1 hour of data loss).
*   **Recovery Time Objective (RTO)**: The maximum acceptable downtime before services must be restored.
*   **Inventory**: A detailed list of all hardware, software, network configurations, and data.
*   **Roles and Responsibilities**: Clearly defined roles and responsibilities for the disaster recovery team.
*   **Communication Plan**: How stakeholders will be informed during and after a disaster.
*   **Backup Restoration Procedures**: Step-by-step instructions for restoring data from backups.
*   **System Rebuild Procedures**: Instructions for rebuilding servers from scratch if necessary.
*   **Testing Schedule**: Regular testing of the DRP to identify gaps and ensure its effectiveness.

### 3.2. Testing Your Disaster Recovery Plan

Regularly test your DRP to ensure it is effective and that personnel are familiar with the procedures. Testing can range from tabletop exercises to full-scale simulations.

*   **Tabletop Exercises**: Discuss the DRP with the team to identify potential issues.
*   **Simulated Restores**: Periodically restore data from backups to a test environment to verify their integrity and the restoration process.
*   **Full Disaster Simulations**: Simulate a complete system failure and attempt to recover services using the DRP. This is the most comprehensive test.

## 4. Secure Backup Storage

*   **Encryption**: Ensure backups are encrypted both in transit and at rest to protect sensitive data.
*   **Access Control**: Implement strict access controls to backup storage, limiting access to authorized personnel only.
*   **Immutability**: Consider using immutable storage for critical backups to protect against ransomware and accidental deletion.
