# 03 - Windows Network and Firewall Configuration

Securing network access is critical for protecting Windows Servers from external and internal threats. This section outlines best practices for configuring network settings and the Windows Firewall.

## 1. Network Configuration

*   **Network Segmentation**: Isolate servers using VLANs, subnets, or other network segregation techniques. This strategy limits the server's exposure to potential threats by ensuring that only necessary traffic can reach it [4].
*   **DNS and Hostname Accuracy**: Ensure that DNS and hostname configurations are accurate to prevent DNS-related manipulation and ensure proper name resolution for services [4].
*   **Disable Unnecessary Protocols**: Disable protocols like NetBIOS over TCP/IP and LMHosts lookup if they are not required for legacy software or hardware. These protocols can be exploited if left enabled unnecessarily [4].

## 2. Firewall Configuration

To help safeguard your Windows servers from unauthorized access and malicious traffic, proper firewall configuration is essential.

*   **Enable Windows Firewall**: Ensure the Windows Firewall is enabled and actively running on all network profiles (Domain, Private, and Public) [4].
*   **Configure Default Blocking Policy**: Configure each Windows Firewall profile to block inbound traffic by default. This 
"default deny" posture ensures that only explicitly allowed traffic can reach the server [4].
*   **Restrict Inbound Access**: When inbound access is necessary for a server, limit it to essential protocols, ports, and specific IP addresses. Open only required network ports and restrict or deny access for all other ports [4].
*   **Remote Access Control**: If Remote Desktop Protocol (RDP) is necessary for administration, limit access to specific IP addresses or networks. Enforce strong authentication (e.g., MFA) and set the RDP connection encryption level to high to protect administrative sessions [4].

## References

[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
