# 02 - Linux User and Account Management

Effective user and account management is fundamental to securing any Linux server. This section outlines best practices for creating, managing, and securing user accounts, as well as implementing strong authentication mechanisms.

## 1. Strong Password Policies

Enforcing strong password policies is the first line of defense against unauthorized access. This involves setting minimum length requirements, complexity rules, and password expiration.

### Configure `pam_pwquality`

`pam_pwquality` (or `pam_cracklib` on older systems) is a PAM module that enforces password complexity rules. Edit `/etc/security/pwquality.conf` (or `/etc/pam.d/common-password` for `pam_cracklib`) to set parameters like minimum length, required character classes, and dictionary checks.

Example `pwquality.conf` settings:

```ini
# Minimum password length
minlen = 14
# Require at least one uppercase character
ucredit = -1
# Require at least one lowercase character
lcredit = -1
# Require at least one digit
dcredit = -1
# Require at least one special character
ocredit = -1
# Don't allow more than 3 consecutive identical characters
maxrepeat = 3
# Don't allow password to be a palindrome
 enforce_for_root
```

After modifying, ensure PAM is configured to use `pam_pwquality`.

### Password Expiration

Force users to change their passwords periodically. This can be configured globally or per-user.

To set a global password expiration policy (e.g., 90 days) and warning period (e.g., 7 days) in `/etc/login.defs`:

```ini
PASS_MAX_DAYS   90
PASS_MIN_DAYS   0
PASS_WARN_AGE   7
```

## 2. SSH Key-Based Authentication

Using SSH keys instead of passwords for remote access significantly enhances security by eliminating brute-force password attacks.

### Generate SSH Key Pair

On your local machine, generate an SSH key pair. Ed25519 is recommended for new deployments due to its superior security and performance. RSA 4096-bit is a solid alternative for compatibility with older systems.

```bash
# Recommended: Ed25519 (faster, more secure)
ssh-keygen -t ed25519 -a 100

# Alternative: RSA 4096-bit (better compatibility)
ssh-keygen -t rsa -b 4096
```

### Copy Public Key to Server

Copy your public key (`~/.ssh/id_rsa.pub`) to the server using `ssh-copy-id`:

```bash
ssh-copy-id user@your_server_ip
```

Alternatively, manually copy the content of `id_rsa.pub` to `~/.ssh/authorized_keys` on the server.

### Disable Password Authentication for SSH

Once SSH key-based authentication is working, disable password authentication in `/etc/ssh/sshd_config` to prevent password-based attacks.

```ini
PasswordAuthentication no
```

### Disable Root Login via SSH

Prevent direct root login via SSH to mitigate attacks targeting the root account.

```ini
PermitRootLogin no
```

### Configure `AllowUsers` or `AllowGroups`

Restrict SSH access to specific users or groups in `/etc/ssh/sshd_config`.

```ini
AllowUsers your_username
# OR
AllowGroups sshusers
```

After making changes to `sshd_config`, restart the SSH service:

```bash
sudo systemctl restart sshd
```

## 3. Limiting `sudo` and `su` Usage

Controlling who can execute commands with elevated privileges is crucial for maintaining system integrity.

### Limit `sudo` Access

Only grant `sudo` privileges to users who absolutely need them. Manage `sudo` access via the `/etc/sudoers` file or by adding users to the `sudo` group (or `wheel` on some distributions).

```bash
sudo usermod -aG sudo your_username
```

### Limit `su` Access

Restrict who can use the `su` command to switch to another user (especially root). This can be done by adding users to the `wheel` group and configuring PAM.

Edit `/etc/pam.d/su` and uncomment the line:

```ini
auth            required        pam_wheel.so use_uid
```

Then add authorized users to the `wheel` group:

```bash
sudo usermod -aG wheel your_username
```

## 4. Multi-Factor Authentication (MFA) for SSH

For enhanced security, implement MFA for SSH access. This typically involves combining SSH keys with a time-based one-time password (TOTP) or other MFA solutions.

### Example: Google Authenticator for SSH

1.  **Install Google Authenticator PAM module**:
    ```bash
    sudo apt install libpam-google-authenticator -y
    ```
2.  **Configure PAM for SSH**:
    Edit `/etc/pam.d/sshd` and add the following line at the top:
    ```ini
    auth required pam_google_authenticator.so
    ```
3.  **Configure `sshd_config`**:
    Edit `/etc/ssh/sshd_config` and ensure `KbdInteractiveAuthentication` is set to `yes`:
    ```ini
    KbdInteractiveAuthentication yes
    # If using password authentication alongside MFA, ensure it's enabled:
    # PasswordAuthentication yes
    # UsePAM yes
    ```
4.  **Run `google-authenticator` for each user**:
    Each user needing MFA must run `google-authenticator` on the server and follow the prompts to generate their secret key and QR code. Store the secret key securely.
    ```bash
    google-authenticator
    ```
5.  **Restart SSH service**:
    ```bash
sudo systemctl restart sshd
    ```

Now, when users log in via SSH, they will be prompted for their verification code after their SSH key or password.

## 5. SSH Server Hardening

Harden the SSH server configuration in `/etc/ssh/sshd_config` to use only strong cryptographic algorithms and restrict unnecessary features.

### Recommended `sshd_config` Settings

```ini
# Authentication
LoginGraceTime 30
MaxAuthTries 3
MaxSessions 5
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
PermitRootLogin no

# Restrict to specific users/groups
AllowUsers your_username
# AllowGroups sshusers

# Use only strong key exchange algorithms
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group18-sha512,diffie-hellman-group16-sha512

# Use only strong ciphers
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

# Use only strong MACs
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256

# Use only strong host key algorithms
HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256

# Disable unused features
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
PermitTunnel no
GatewayPorts no

# Logging
LogLevel VERBOSE

# Idle timeout (disconnect after 15 minutes of inactivity)
ClientAliveInterval 300
ClientAliveCountMax 3
```

### Verify SSH Configuration

After applying changes, verify the configuration and restart SSH:

```bash
# Test configuration syntax
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd

# Verify listening ciphers and algorithms (from a client)
ssh -vv your_server 2>&1 | grep -E "kex:|cipher:|mac:"
```
