# 06 - Understanding Network Ports and Services

Network ports are virtual endpoints for communication in an operating system. They allow different applications and services to send and receive data over a network. Understanding which ports are open and what services are running on them is a fundamental aspect of server security.

## 1. The Basics of Network Ports

*   **Port Numbers**: Ports are identified by numbers ranging from 0 to 65535.
*   **Protocols**: Ports are associated with specific transport protocols, primarily TCP (Transmission Control Protocol) and UDP (User Datagram Protocol).
*   **Port Categories**:
    *   **Well-Known Ports (0-1023)**: Assigned by IANA for common, standard services (e.g., HTTP on 80, HTTPS on 443, SSH on 22).
    *   **Registered Ports (1024-49151)**: Assigned by IANA for specific applications or services (e.g., MySQL on 3306, RDP on 3389).
    *   **Dynamic/Private Ports (49152-65535)**: Used for temporary, ephemeral connections by client applications.

## 2. Security Implications of Open Ports

An open port itself is not inherently dangerous; it simply means a service is listening for connections. However, the *service* running on that port can be a security risk if:

*   **It is vulnerable**: The service software has known security flaws that attackers can exploit.
*   **It is misconfigured**: The service is set up insecurely (e.g., weak authentication, default credentials).
*   **It is unnecessary**: The service is running but not needed for the server's function, unnecessarily expanding the attack surface.

## 3. Common Ports and Associated Risks

| Port | Protocol | Service | Typical Use | Security Risks & Recommendations |
| :--- | :------- | :------ | :---------- | :------------------------------- |
| **20/21** | TCP | FTP | File Transfer | FTP transmits data (including credentials) in plaintext. **Recommendation**: Use SFTP (SSH File Transfer Protocol) or FTPS instead. |
| **22** | TCP | SSH | Secure Shell | Secure remote administration. **Recommendation**: Use key-based authentication, disable root login, change default port (optional), use Fail2Ban. |
| **23** | TCP | Telnet | Remote Terminal | Telnet transmits data in plaintext. **Recommendation**: Never use Telnet over untrusted networks; use SSH instead. |
| **25** | TCP | SMTP | Email Routing | Simple Mail Transfer Protocol. **Recommendation**: Secure with TLS (SMTPS on port 465 or STARTTLS on 587). |
| **53** | TCP/UDP | DNS | Domain Name System | Resolves domain names to IP addresses. **Recommendation**: Secure DNS servers against cache poisoning and DDoS attacks. |
| **80** | TCP | HTTP | Web Traffic | Unencrypted web traffic. **Recommendation**: Redirect all HTTP traffic to HTTPS (port 443). |
| **110** | TCP | POP3 | Email Retrieval | Post Office Protocol. **Recommendation**: Use POP3S (port 995) for encrypted retrieval. |
| **135/139/445** | TCP/UDP | RPC/NetBIOS/SMB | Windows File Sharing | Server Message Block. High risk for ransomware (e.g., WannaCry). **Recommendation**: Block at the perimeter firewall. Disable SMBv1. |
| **143** | TCP | IMAP | Email Retrieval | Internet Message Access Protocol. **Recommendation**: Use IMAPS (port 993) for encrypted retrieval. |
| **443** | TCP | HTTPS | Secure Web Traffic | Encrypted web traffic. **Recommendation**: Ensure strong TLS configurations and valid certificates. |
| **1433** | TCP | MS SQL | Database | Microsoft SQL Server. **Recommendation**: Do not expose directly to the internet. Use strong authentication and encryption. |
| **3306** | TCP | MySQL | Database | MySQL Database. **Recommendation**: Do not expose directly to the internet. Restrict access to specific application servers. |
| **3389** | TCP | RDP | Remote Desktop | Windows Remote Desktop Protocol. High risk for brute-force attacks. **Recommendation**: Do not expose directly to the internet. Use a VPN or RD Gateway. Implement MFA and Network Level Authentication (NLA). |
| **5432** | TCP | PostgreSQL | Database | PostgreSQL Database. **Recommendation**: Do not expose directly to the internet. Restrict access to specific application servers. |

## 4. Best Practices for Port Management

### 4.1. Principle of Least Privilege (Network Level)

*   **Default Deny**: Configure firewalls to block all incoming traffic by default.
*   **Allow Only Necessary Ports**: Explicitly allow inbound traffic only on ports required for the server's specific function.

### 4.2. Regular Port Scanning and Auditing

*   **Internal Scanning**: Regularly scan your servers from within the network to identify all open ports and running services. Tools like `nmap` or `netstat` (Linux) / `Get-NetTCPConnection` (Windows) are useful.
*   **External Scanning**: Scan your public-facing IP addresses from the outside to ensure only intended services are exposed to the internet.
*   **Review and Justify**: Periodically review the list of open ports and justify the need for each one. Close any ports that are no longer required.

### 4.3. Service Hardening

*   **Keep Services Updated**: Ensure the software running on open ports is patched against known vulnerabilities.
*   **Secure Configuration**: Follow security best practices for configuring each service (e.g., disabling default accounts, enforcing strong authentication).

## 5. References

*   [IANA Service Name and Transport Protocol Port Number Registry](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml)
*   [SANS Critical Security Controls - Control 4: Secure Configuration of Enterprise Assets and Software](https://www.cisecurity.org/controls/v8/)
