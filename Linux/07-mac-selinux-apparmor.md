# 07 - Linux Mandatory Access Control (MAC) - SELinux & AppArmor

Mandatory Access Control (MAC) systems provide an additional layer of security by enforcing strict access policies that cannot be overridden by discretionary access controls (DAC). In Linux, the most prominent MAC implementations are SELinux and AppArmor. This section compares these two systems and provides guidance on their usage.

## 1. Understanding Mandatory Access Control (MAC)

Unlike DAC, where resource owners can grant or deny access, MAC systems enforce policies defined by a central authority (e.g., the system administrator). This means that even if a process runs as `root`, a MAC policy can still restrict its actions, preventing privilege escalation and containing breaches.

## 2. SELinux (Security-Enhanced Linux)

SELinux is a robust and highly granular MAC system developed by the National Security Agency (NSA). It operates on a label-based model, assigning security contexts (labels) to every file, process, and system object. Policies then define how these labeled objects can interact.

### Key Characteristics:

*   **Security Model**: Label-based access control, where rules are assigned to security contexts and object labels [3].
*   **Granularity**: Offers fine-grained control over users, processes, and objects, supporting multi-level and role-based enforcement [3].
*   **Complexity**: Has a steep learning curve due to its detailed policy language and extensive configuration requirements [3].
*   **Default Distributions**: Default in Red Hat Enterprise Linux (RHEL), CentOS, Fedora, AlmaLinux, and Rocky Linux [3].
*   **Modes of Operation**: Can operate in `enforcing` (policies are enforced and logged), `permissive` (policies are not enforced but violations are logged), and `disabled` modes [3].

### Pros and Cons of SELinux [3]:

| Pros                                     | Cons                                       |
| :--------------------------------------- | :----------------------------------------- |
| Fine-grained, label-based access control | Complex to configure and manage            |
| Supports roles, users, and multi-level security | Steep learning curve for new users         |
| Strong containment and isolation         | Logs are harder to interpret               |
| Scales well in large or dynamic systems  | Requires specialized tools (e.g., `semanage`) |
| Default in RHEL, CentOS, Fedora          | Misconfigurations can block system processes |

### Basic SELinux Commands:

*   **Check Status**: `sestatus`
*   **Change Mode**: `sudo setenforce 0` (permissive), `sudo setenforce 1` (enforcing)
*   **View Contexts**: `ls -Z`, `ps -Z`
*   **Restore File Contexts**: `sudo restorecon -Rv /path/to/files`

## 3. AppArmor

AppArmor (Application Armor) is another MAC system that uses a simpler, path-based approach. It confines programs to a limited set of resources by using profiles that define what individual programs can access based on their file paths.

### Key Characteristics:

*   **Security Model**: Path-based access control, assigning rules to file paths [3].
*   **Granularity**: Provides a good level of control, suitable for predefined application behavior [3].
*   **Complexity**: Generally considered easier to learn, write, and debug profiles [3].
*   **Default Distributions**: Default in Ubuntu, SUSE, and some Debian-based systems [3].
*   **Modes of Operation**: Profiles can be in `enforce` (policies are enforced and logged) or `complain` (policies are not enforced but violations are logged) modes [3].

### Pros and Cons of AppArmor [3]:

| Pros                                     | Cons                                       |
| :--------------------------------------- | :----------------------------------------- |
| Easy to learn and manage                 | Limited to path-based rules                |
| Uses human-readable, plain-text profiles | Not ideal for complex or dynamic environments |
| Easier to troubleshoot with readable logs | Lacks advanced role and type enforcement   |
| Low performance overhead                 | Static profiles require manual updates     |
| Default on Ubuntu, SUSE, Debian          | Weaker isolation compared to SELinux       |

### Basic AppArmor Commands:

*   **Check Status**: `sudo apparmor_status`
*   **Load Profile**: `sudo apparmor_parser -r /etc/apparmor.d/profile_name`
*   **Put Profile in Enforce Mode**: `sudo aa-enforce /etc/apparmor.d/profile_name`
*   **Put Profile in Complain Mode**: `sudo aa-complain /etc/apparmor.d/profile_name`

## 4. Choosing Between SELinux and AppArmor

The choice between SELinux and AppArmor often depends on your specific needs, existing infrastructure, and comfort level with complexity [3].

| Factor             | SELinux                                      | AppArmor                                     |
| :----------------- | :------------------------------------------- | :------------------------------------------- |
| **Granularity**    | Very high, label-based                       | Good, path-based                             |
| **Complexity**     | High learning curve, complex policies        | Lower learning curve, simpler profiles       |
| **Flexibility**    | Highly flexible, custom roles/types          | More static, suited for predefined behavior  |
| **Performance**    | Optimized for enterprise, some overhead      | Lower overhead, ideal for lightweight systems |
| **Distro Default** | RHEL, CentOS, Fedora                         | Ubuntu, SUSE, Debian                         |
| **Use Case**       | Enterprise, high-security, complex environments | Desktops, low-risk servers, ease of management |

It is generally recommended to use the MAC system that is default for your chosen Linux distribution, as it will have better integration and community support.

## References

[1] [17 comprehensive container security best practices for 2026 - Sysdig](https://www.sysdig.com/learn-cloud-native/container-security-best-practices)
[2] [25 Cloud Security Best Practices for AWS, Azure, and GCP](https://cloudaware.com/blog/cloud-security-best-practices/)
[3] [SELinux vs AppArmor: The Hard Truth About Linux Security](https://tuxcare.com/blog/selinux-vs-apparmor/)
