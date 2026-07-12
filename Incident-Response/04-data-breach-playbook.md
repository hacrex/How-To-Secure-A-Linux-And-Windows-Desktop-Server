# 04 - Data Breach Playbook

This playbook provides a structured approach to respond to incidents involving a data breach, where sensitive or confidential information has been accessed, disclosed, altered, or destroyed without authorization. This applies to data stored on both Linux and Windows server environments.

## 1. Incident Overview

**Incident Type**: Data Breach / Data Exfiltration
**Severity**: Critical
**Impact**: Regulatory fines, reputational damage, legal action, financial loss, loss of customer trust, identity theft.

## 2. Detection

**Indicators of Compromise (IoCs)**:
*   **Unusual Outbound Traffic**: Large volumes of data being transferred from internal networks to external, unknown destinations.
*   **Access Anomalies**: Access to sensitive data by unauthorized users, unusual access patterns (e.g., accessing data at odd hours, from unusual locations).
*   **File System Changes**: Unauthorized modification or deletion of sensitive files, creation of archives or compressed files containing sensitive data.
*   **Security Tool Alerts**: Alerts from DLP (Data Loss Prevention) systems, SIEM, EDR, or IDS/IPS indicating data exfiltration attempts.
*   **User Reports**: Employees or customers reporting suspicious activity related to their data.
*   **External Notifications**: Notification from law enforcement, security researchers, or third parties about potential data exposure.

**Detection Tools**:
*   DLP solutions
*   SIEM (Splunk, ELK, Sentinel)
*   EDR/XDR solutions
*   Network monitoring tools (e.g., NetFlow, packet capture)
*   File Integrity Monitoring (FIM)
*   Database activity monitoring (DAM)

## 3. Analysis

**Objective**: Determine the scope, nature, and impact of the data breach, including what data was compromised and how.

**Steps**:
1.  **Verify Incident**: Confirm the data breach. Is it a false positive?
2.  **Identify Affected Data**: Determine what specific sensitive data (e.g., PII, financial, health, intellectual property) has been accessed or exfiltrated.
3.  **Identify Affected Systems**: Determine which servers, databases, applications, or storage systems were involved.
4.  **Determine Entry Point and Method**: How did the attacker gain access to the data? (e.g., exploited vulnerability, compromised credentials, insider threat).
5.  **Timeline Creation**: Establish a detailed timeline of events, from initial compromise to data exfiltration.
6.  **Collect Evidence**: Securely collect all relevant logs (system, application, database, network, firewall), memory dumps, disk images, and network traffic captures for forensic analysis. **DO NOT** make changes to the compromised system that could destroy evidence.
7.  **Identify Attacker Actions**: What actions did the attacker take? (e.g., privilege escalation, lateral movement, data staging, exfiltration methods).

**Key Questions**:
*   What categories of data were compromised?
*   How many individuals are affected?
*   What is the sensitivity level of the compromised data?
*   When did the breach occur and how long did it last?
*   What is the root cause of the breach?

## 4. Containment

**Objective**: Limit the damage, prevent further data loss, and preserve evidence.

**Steps**:
1.  **Isolate Affected Systems**: Disconnect compromised systems from the network or move them to a quarantine segment to prevent further data exfiltration.
2.  **Block Attacker Access**: Block known attacker IP addresses and domains at the perimeter firewall.
3.  **Disable Compromised Accounts**: Immediately disable or reset passwords for any compromised user or service accounts.
4.  **Revoke Access**: Revoke any compromised API keys, tokens, or other credentials.
5.  **Secure Vulnerabilities**: Temporarily disable services or apply immediate patches to close the exploited vulnerability.
6.  **Prevent Data Exfiltration**: Implement or strengthen DLP policies, monitor outbound traffic for sensitive data.

## 5. Eradication

**Objective**: Eliminate the attacker's presence and remove all malicious components and vulnerabilities.

**Steps**:
1.  **Remove Backdoors/Malware**: Identify and remove any installed backdoors, rootkits, or malware used by the attacker.
2.  **Patch Vulnerabilities**: Permanently address the root cause of the breach by applying patches or reconfiguring systems.
3.  **Rebuild/Reimage Systems**: For severely compromised systems, especially those where root access was gained, consider reimaging from a trusted golden image or rebuilding from scratch.
4.  **Reset Credentials**: Reset all passwords and regenerate SSH keys for affected systems and accounts, and any related systems.

## 6. Recovery

**Objective**: Restore affected systems and services to normal operation and ensure data integrity.

**Steps**:
1.  **Restore from Clean Backups**: Restore data and configurations from verified clean backups (taken before the incident). Verify data integrity.
2.  **Verify System Integrity**: Conduct thorough checks to ensure all systems are clean, secure, and functioning correctly.
3.  **Monitor Closely**: Implement enhanced monitoring for the recovered systems to detect any recurrence of the attack.
4.  **Gradual Reintroduction**: Gradually reintroduce systems back into the production environment, starting with the least critical.

## 7. Post-Incident Activity

**Objective**: Learn from the incident, improve security posture, and fulfill legal/regulatory obligations.

**Steps**:
1.  **Lessons Learned Meeting**: Conduct a meeting with all involved parties to discuss what happened, what worked well, and what could be improved.
2.  **Update Policies and Procedures**: Revise security policies, incident response plans, and playbooks based on lessons learned.
3.  **Enhance Controls**: Implement new security controls or strengthen existing ones (e.g., MFA, DLP, enhanced monitoring) to prevent similar incidents.
4.  **Legal and Regulatory Compliance**: Consult with legal counsel to determine notification requirements (e.g., to affected individuals, regulatory bodies, law enforcement).
5.  **Public Relations**: Develop a communication plan for external stakeholders if public disclosure is necessary.
6.  **Training**: Provide additional security awareness training to users and technical staff, focusing on the breach vector.

## 8. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [GDPR Data Breach Notification Guidelines](https://gdpr-info.eu/art-33-gdpr/)
*   [HIPAA Breach Notification Rule](https://www.hhs.gov/hipaa/for-professionals/breach-notification-rule/index.html)
