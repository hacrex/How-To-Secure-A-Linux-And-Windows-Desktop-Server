# 02 - Principle of Least Privilege and Access Control

The Principle of Least Privilege (PoLP) is a fundamental security concept that dictates that users, programs, and processes should be granted only the minimum necessary permissions to perform their legitimate functions. Implementing robust access control mechanisms across both Linux and Windows environments is crucial for adhering to PoLP and minimizing the impact of potential security breaches.

## 1. Understanding the Principle of Least Privilege

*   **Minimize Attack Surface**: By limiting privileges, you reduce the potential damage an attacker can inflict if they compromise an account or system. An attacker with limited privileges will have fewer resources to exploit.
*   **Containment**: In the event of a breach, PoLP helps contain the damage by restricting the compromised entity's ability to move laterally or escalate privileges.
*   **Improved Auditability**: With fewer privileges granted, it becomes easier to track and audit actions, making it simpler to identify unauthorized activities.

## 2. Key Access Control Best Practices

### 2.1. User and Group Management

*   **Dedicated Accounts**: Create separate, dedicated accounts for each user and service. Avoid shared accounts, as they make accountability difficult.
*   **Strong Authentication**: Enforce strong, unique passwords for all accounts. Implement Multi-Factor Authentication (MFA) wherever possible, especially for administrative accounts and remote access.
*   **Group-Based Permissions**: Manage permissions through groups rather than individual users. This simplifies administration and ensures consistent application of privileges.
*   **Regular Review**: Periodically review user and service accounts, disabling or deleting those that are no longer needed. Audit group memberships to ensure they align with current roles.

### 2.2. Administrative Privileges

*   **Separate Administrative Accounts**: Use separate, non-privileged accounts for daily tasks and only switch to administrative accounts when elevated privileges are absolutely necessary. This reduces the exposure of high-privilege credentials.
*   **Just-in-Time (JIT) Access**: Implement JIT access solutions that grant elevated privileges only for a limited time and specific tasks, automatically revoking them afterward.
*   **Secure Remote Access**: Restrict administrative access to servers to secure channels (e.g., SSH with key-based authentication, VPN-protected RDP) and from trusted IP addresses or management workstations.

### 2.3. File System and Registry Permissions

*   **Default Deny**: Configure file system and registry permissions with a 
default deny" approach. Grant explicit permissions only to necessary users or groups.
*   **Regular Audits**: Periodically audit file and folder permissions to ensure they are correctly configured and have not been inadvertently broadened.
*   **Windows**: Utilize NTFS permissions and share permissions. For critical system files and directories, adhere to security baselines (e.g., CIS Benchmarks) for recommended permissions.
*   **Linux**: Use `chmod` and `chown` to set appropriate file and directory permissions. Pay attention to `umask` settings.

### 2.4. Application Permissions

*   **Run Services with Least Privilege**: Configure applications and services to run under dedicated, low-privilege accounts rather than highly privileged accounts (e.g., `Local System` on Windows, `root` on Linux).
*   **Containerization**: For containerized applications, ensure containers run as non-root users and have only the necessary capabilities. Implement Seccomp, AppArmor, or SELinux profiles to further restrict container actions.

## 3. Tools and Technologies

| Operating System | Key Tools/Technologies for Access Control |
| :--------------- | :---------------------------------------- |
| **Linux**        | PAM, `sudo`, `su`, SSH key-based authentication, SELinux, AppArmor, `chmod`, `chown` |
| **Windows**      | Active Directory, Group Policy Objects (GPOs), LAPS, NTFS permissions, PowerShell, Just Enough Administration (JEA) |

## References

*   [NIST SP 800-53 - Access Control (AC)](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
*   [Microsoft Security Baselines](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-security-baselines)
*   [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
