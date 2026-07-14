# 01 - Web Application Server Threat Model

This document outlines a threat model for a typical web application server, focusing on potential threats, vulnerabilities, and countermeasures using the STRIDE methodology.

## 1. System Description

A web application server hosts a dynamic web application, typically interacting with a database server (in a separate network segment) and serving content to end-users over the internet. It often includes components like a web server (e.g., Nginx, Apache, IIS), an application runtime (e.g., PHP, Node.js, Python, .NET), and potentially a caching layer.

## 2. Data Flow Diagram (DFD) - Simplified

```mermaid
graph TD
    A[User Browser] -->|HTTPS| B(Load Balancer)
    B -->|HTTPS| C[Web Server]
    C -->|HTTP/S (Internal)| D[Application Server]
    D -->|Database Protocol| E[Database Server]
    E -- Cache --> C
```

## 3. Asset Identification

*   **Data**: User data (credentials, personal information), application data, session tokens, configuration files, logs.
*   **Services**: Web server (HTTP/HTTPS), application runtime, SSH/RDP for administration.
*   **Infrastructure**: Server OS, network connectivity, load balancer.

## 4. Threat Analysis (STRIDE)

### 4.1. Spoofing (Identity Spoofing)

**Threat**: An attacker impersonates a legitimate user, server, or application component.

**Examples**:
*   Phishing attacks to steal user credentials.
*   Compromised SSL/TLS certificates allowing an attacker to impersonate the web server.
*   Attacker gaining access to a legitimate user's session token.

**Vulnerabilities**:
*   Weak authentication mechanisms.
*   Lack of strong identity verification for server-to-server communication.
*   Session hijacking due to insecure session management.

**Countermeasures**:
*   Implement strong authentication (MFA) for users and administrators.
*   Use mutual TLS (mTLS) for server-to-server communication where appropriate.
*   Secure session management (e.g., HttpOnly, Secure flags for cookies, short session timeouts).
*   Regularly rotate API keys and credentials.

### 4.2. Tampering (Data Tampering)

**Threat**: An attacker modifies data on the server, in transit, or in storage.

**Examples**:
*   SQL Injection leading to database record modification.
*   Cross-Site Scripting (XSS) to modify web page content or inject malicious scripts.
*   Modification of application configuration files.
*   Manipulation of HTTP requests/responses.

**Vulnerabilities**:
*   Lack of input validation and output encoding.
*   Insecure file permissions on configuration files.
*   Absence of integrity checks for data in storage or transit.

**Countermeasures**:
*   Implement robust input validation and output encoding (e.g., OWASP ESAPI).
*   Use parameterized queries to prevent SQL Injection.
*   Enforce strict file permissions on critical files and directories.
*   Utilize HTTPS for all communications to ensure data integrity in transit.
*   Implement file integrity monitoring (FIM) for critical system and application files.

### 4.3. Repudiation (Non-Repudiation)

**Threat**: A user or system entity denies having performed an action.

**Examples**:
*   An administrator denies making a critical configuration change.
*   A user denies performing a transaction.

**Vulnerabilities**:
*   Insufficient logging of actions.
*   Lack of audit trails.

**Countermeasures**:
*   Implement comprehensive logging for all significant actions (logins, configuration changes, data modifications).
*   Ensure logs are immutable and stored securely (e.g., centralized SIEM).
*   Use digital signatures or cryptographic hashes for critical transactions.

### 4.4. Information Disclosure

**Threat**: Sensitive information is exposed to unauthorized individuals.

**Examples**:
*   Error messages revealing sensitive system details (e.g., stack traces, database connection strings).
*   Directory listings exposing file structures.
*   Unencrypted data in storage or transit.
*   Sensitive data in logs.

**Vulnerabilities**:
*   Verbose error handling.
*   Misconfigured web servers.
*   Lack of encryption for data at rest and in transit.
*   Improper log sanitization.

**Countermeasures**:
*   Implement generic error messages and log detailed errors internally.
*   Disable directory listings on web servers.
*   Encrypt all sensitive data at rest (e.g., full disk encryption, database encryption) and in transit (HTTPS, VPN).
*   Sanitize logs to remove sensitive information.

### 4.5. Denial of Service (DoS)

**Threat**: An attacker prevents legitimate users from accessing the web application or its services.

**Examples**:
*   Distributed Denial of Service (DDoS) attacks overwhelming server resources.
*   Resource exhaustion due to inefficient application code or unhandled exceptions.
*   Exploiting vulnerabilities that cause the application or server to crash.

**Vulnerabilities**:
*   Lack of rate limiting and traffic filtering.
*   Inefficient application code or database queries.
*   Unpatched software with known DoS vulnerabilities.

**Countermeasures**:
*   Implement DDoS protection services (e.g., CDN, cloud-based WAF).
*   Use rate limiting on API endpoints and login pages.
*   Optimize application code and database queries.
*   Regularly patch and update all software components.
*   Implement robust monitoring and alerting for resource utilization.

### 4.6. Elevation of Privilege

**Threat**: An attacker gains higher privileges than they are authorized for.

**Examples**:
*   Exploiting a vulnerability in the operating system or application to gain root/administrator access.
*   Insecure configuration allowing a low-privileged user to execute commands as a higher-privileged user.

**Vulnerabilities**:
*   Unpatched operating system or application software.
*   Misconfigured sudoers file (Linux) or insecure service accounts (Windows).
*   Weak access control mechanisms.

**Countermeasures**:
*   Regularly patch and update all software.
*   Implement the Principle of Least Privilege for all users and service accounts.
*   Configure `sudo` carefully (Linux) and use Just Enough Administration (JEA) (Windows).
*   Use Mandatory Access Controls (MAC) like SELinux/AppArmor (Linux).
*   Conduct regular security audits and penetration testing.

## 5. Risk Rating Examples

The following table provides example risk ratings for identified threats using a simplified DREAD-like scoring model (1-10 scale):

| Threat Category | Example Threat | Damage Potential | Reproducibility | Exploitability | Affected Users | Discoverability | Average Risk | Priority |
|----------------|----------------|------------------|-----------------|----------------|----------------|-----------------|--------------|----------|
| Spoofing | Session hijacking via stolen token | 8 | 6 | 7 | 9 | 5 | 7.0 | High |
| Tampering | SQL Injection attack | 9 | 7 | 8 | 10 | 8 | 8.4 | Critical |
| Information Disclosure | Verbose error messages exposing stack traces | 5 | 9 | 9 | 3 | 9 | 7.0 | High |
| Denial of Service | DDoS attack on web endpoint | 7 | 8 | 6 | 10 | 7 | 7.6 | High |
| Elevation of Privilege | Local privilege escalation via unpatched kernel | 10 | 5 | 4 | 2 | 6 | 5.4 | Medium |

**Risk Priority Guidelines:**
*   **Critical (8.0-10.0)**: Immediate remediation required
*   **High (6.0-7.9)**: Remediate within 30 days
*   **Medium (4.0-5.9)**: Remediate within 90 days
*   **Low (1.0-3.9)**: Remediate as part of regular maintenance

## 6. Practical Verification Steps

After implementing countermeasures, verify their effectiveness with these practical tests:

### 6.1 Authentication & Session Management Verification

```bash
# Test MFA enforcement
curl -v https://your-server.com/login

# Test session timeout (wait and check if session persists)
curl -b session_cookie.txt https://your-server.com/dashboard

# Verify secure cookie flags
curl -I https://your-server.com/login | grep -i set-cookie
# Should include: HttpOnly; Secure; SameSite=Strict
```

### 6.2 Input Validation Testing

```bash
# Test for SQL Injection vulnerability
curl "https://your-server.com/search?q=' OR '1'='1"

# Test for XSS vulnerability
curl "https://your-server.com/search?q=<script>alert('XSS')</script>"

# Expected: Application should reject or sanitize malicious input
```

### 6.3 Logging Verification

```bash
# Check that failed login attempts are logged
grep "Failed password" /var/log/auth.log  # Linux
Get-WinEvent -FilterHashtable @{LogName='Security';Id=4625}  # Windows

# Verify log integrity
ls -la /var/log/
# Logs should be owned by root with restricted permissions (e.g., 640)
```

### 6.4 Network Security Verification

```bash
# Verify HTTPS is enforced
curl -I http://your-server.com
# Should redirect to HTTPS

# Check TLS configuration
nmap --script ssl-enum-ciphers -p 443 your-server.com
# Should show only TLS 1.2+ with strong ciphers

# Verify firewall rules
sudo ufw status verbose  # Ubuntu/Debian
sudo firewall-cmd --list-all  # RHEL/CentOS
netsh advfirewall show allprofiles  # Windows
```

## 7. References

*   [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)
*   [Microsoft STRIDE Threat Model](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-stride)
*   [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
*   [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
*   [CIS Controls](https://www.cisecurity.org/controls)

## Appendix A: Template for Additional Threat Models

Use this template when creating threat models for other systems:

```markdown
# [System Name] Threat Model

## 1. System Description
[Brief description of the system and its purpose]

## 2. Data Flow Diagram
[Mermaid diagram or description of data flows]

## 3. Asset Identification
* **Data**: [List critical data assets]
* **Services**: [List critical services]
* **Infrastructure**: [List infrastructure components]

## 4. Threat Analysis (STRIDE)
### 4.1 Spoofing
[Threats, vulnerabilities, countermeasures]

### 4.2 Tampering
[Threats, vulnerabilities, countermeasures]

[Continue for all STRIDE categories...]

## 5. Risk Ratings
[Risk rating table with DREAD scores]

## 6. Verification Steps
[Practical tests to verify countermeasures]

## 7. References
[Relevant links and documentation]
```
