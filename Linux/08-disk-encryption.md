# 08 - Linux Disk Encryption

Disk encryption is a critical security measure that protects data at rest from unauthorized access, even if the physical storage device is stolen or compromised. This section covers methods for encrypting disks in Linux environments.

## 1. Full Disk Encryption (FDE) with LUKS

Linux Unified Key Setup (LUKS) is the standard for disk encryption on Linux. It provides a platform-independent on-disk format for encrypting block devices and is widely supported by Linux distributions.

### Encrypting a New Partition/Disk

**Warning**: This process will erase all data on the target partition/disk. Ensure you have backups before proceeding.

1.  **Identify the Target Device**: Use `lsblk` or `fdisk -l` to identify the partition or disk you want to encrypt (e.g., `/dev/sdb1`).

2.  **Install `cryptsetup`**:
    ```bash
    sudo apt install cryptsetup -y  # Debian/Ubuntu
    sudo yum install cryptsetup -y  # RHEL/CentOS
    ```

3.  **Encrypt the Device with LUKS2**: LUKS2 is the modern standard, offering improved metadata handling and support for Argon2 key derivation. Use `--type luks2` explicitly for clarity.
    ```bash
    sudo cryptsetup -y --type luks2 luksFormat /dev/sdb1
    ```

4.  **Open the LUKS Device**: This makes the encrypted volume accessible.
    ```bash
    sudo cryptsetup luksOpen /dev/sdb1 myencryptedvolume
    ```
    This will create a decrypted device mapper entry at `/dev/mapper/myencryptedvolume`.

5.  **Create a Filesystem on the Decrypted Volume**: Format the decrypted volume with your desired filesystem (e.g., ext4).
    ```bash
    sudo mkfs.ext4 /dev/mapper/myencryptedvolume
    ```

6.  **Mount the Filesystem**: Create a mount point and mount the encrypted volume.
    ```bash
    sudo mkdir /mnt/encrypted
    sudo mount /dev/mapper/myencryptedvolume /mnt/encrypted
    ```

7.  **Configure Automatic Mounting at Boot (Optional, with risks)**:
    For servers, you might need to configure automatic decryption and mounting at boot. This typically involves adding entries to `/etc/crypttab` and `/etc/fstab`.

    **`/etc/crypttab` entry**:
    ```
    myencryptedvolume /dev/sdb1 none luks
    ```

    **`/etc/fstab` entry**:
    ```
    /dev/mapper/myencryptedvolume /mnt/encrypted ext4 defaults 0 2
    ```
    **Note**: For unattended reboots, you would need to use a keyfile instead of a passphrase, which introduces its own security considerations (e.g., securing the keyfile).

### Encrypting the Root Filesystem

Encrypting the root filesystem is more complex and typically done during the operating system installation process. Most modern Linux installers (e.g., Ubuntu, Debian, Fedora) offer an option for full disk encryption during setup. This is the recommended approach for root filesystem encryption.

## 2. Encrypting Specific Directories/Files with fscrypt

For encrypting individual user directories or specific sensitive files, `fscrypt` provides a modern, native solution for ext4, F2FS, and UBIFS filesystems. It is the recommended replacement for the deprecated `eCryptfs`.

### Encrypting a User's Home Directory

1.  **Install `fscrypt`**:
    ```bash
    sudo apt install fscrypt -y
    ```

2.  **Set Up fscrypt**:
    ```bash
    sudo fscrypt setup
    ```
    When prompted, agree to load the `fscrypt` kernel module and set up a `/etc/fscrypt.conf`.

3.  **Encrypt the Home Directory**:
    ```bash
    fscrypt encrypt /home/your_username --source=pam_passphrase
    ```
    You will be prompted to set a passphrase. This passphrase is separate from your login password and protects the encryption key.

4.  **Verify Encryption**:
    ```bash
    fscrypt status /home/your_username
    ```

### Manual fscrypt Mount

You can also encrypt any directory on an fscrypt-supported filesystem:

```bash
# Create and encrypt a directory
mkdir ~/Private
fscrypt encrypt ~/Private --source=pam_passphrase

# The directory is automatically unlocked on login if using pam_passphrase
# To lock it manually:
fscrypt lock ~/Private
```

> **Note**: `eCryptfs` (the older stacking filesystem) was removed from Ubuntu 18.04+ and is no longer maintained. Use `fscrypt` for new deployments.

## 3. Considerations for Disk Encryption

*   **Performance Impact**: Encryption and decryption operations consume CPU resources, which can introduce a performance overhead. Modern CPUs often have AES-NI instructions to accelerate cryptographic operations, minimizing this impact.
*   **Key Management**: Securely managing encryption keys or passphrases is paramount. Loss of keys means loss of data. Consider using a Hardware Security Module (HSM) or Trusted Platform Module (TPM) for key storage in high-security environments.
*   **Backup Strategy**: Ensure your backup strategy accounts for encrypted data. Backups should ideally be encrypted as well, or you must ensure the ability to decrypt them during restoration.
*   **Boot Process**: For full disk encryption, the system will require a passphrase or keyfile during boot, potentially requiring physical access or a secure remote unlocking mechanism.
