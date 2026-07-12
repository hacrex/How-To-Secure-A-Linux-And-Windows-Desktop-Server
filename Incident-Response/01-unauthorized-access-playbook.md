# 01 - Unauthorized Access Playbook

This playbook provides a structured approach to respond to incidents involving unauthorized access to server systems, covering both Linux and Windows environments.

## 1. Incident Overview

**Incident Type**: Unauthorized Access / Intrusion
**Severity**: High
**Impact**: Potential data breach, system compromise, privilege escalation, lateral movement.

## 2. Detection

**Indicators of Compromise (IoCs)**:
*   **Log Anomalies**: Unusual login times, failed login attempts, logins from unfamiliar IP addresses/geolocations.
    *   **Linux**: `/var/log/auth.log`, `/var/log/secure`, `last`, `lastb` commands.
    *   **Windows**: Security Event Log (Event IDs 4624, 4625, 4648, 4776).
*   **New/Modified Accounts**: Creation of new user accounts, changes to existing user privileges.
*   **Unusual Process Activity**: Unknown processes running, processes running with elevated privileges.
*   **File/Directory Changes**: Unauthorized modification, creation, or deletion of critical system files or data.
*   **Network Connections**: Outbound connections to suspicious IP addresses, unusual inbound connections.
*   **IDS/IPS Alerts**: Alerts from intrusion detection/prevention systems.
*   **User Reports**: Users reporting suspicious activity or inability to log in.

**Detection Tools**:
*   SIEM (Splunk, ELK, Sentinel)
*   EDR/XDR solutions
*   Host-based IDS (OSSEC, Wazuh)
*   Network monitoring tools

## 3. Analysis

**Objective**: Determine the scope, method, and impact of the unauthorized access.

**Steps**:
1.  **Verify Incident**: Confirm the unauthorized access. Is it a false positive?
2.  **Identify Affected Systems**: Determine which servers, applications, and data have been accessed or compromised.
3.  **Determine Entry Point**: How did the attacker gain access? (e.g., weak password, exploited vulnerability, phishing).
4.  **Timeline Creation**: Establish a timeline of events leading up to and during the incident.
5.  **Collect Evidence**: Securely collect logs, memory dumps, disk images, and network traffic captures for forensic analysis. **DO NOT** make changes to the compromised system that could destroy evidence.
6.  **Identify Attacker Actions**: What did the attacker do after gaining access? (e.g., data exfiltration, privilege escalation, backdoor installation, lateral movement).

**Key Questions**:
*   When did the unauthorized access occur?
*   Which accounts were used or compromised?
*   What systems were accessed?
*   What data was accessed, modified, or exfiltrated?
*   Are there any backdoors or persistence mechanisms?

## 4. Containment

**Objective**: Limit the damage and prevent further spread of the unauthorized access.

**Steps**:
1.  **Isolate Affected Systems**: Disconnect compromised servers from the network. If possible, move them to a quarantine VLAN.
2.  **Block Attacker IP Addresses**: Update firewalls and network ACLs to block known attacker IP addresses.
3.  **Disable Compromised Accounts**: Immediately disable or reset passwords for any compromised user or service accounts.
4.  **Revoke Access**: Revoke SSH keys or other credentials that may have been compromised.
5.  **Prevent Lateral Movement**: Review network logs for signs of lateral movement and isolate any other potentially compromised systems.

## 5. Eradication

**Objective**: Eliminate the attacker's presence and remove all malicious components.

**Steps**:
1.  **Remove Backdoors/Malware**: Identify and remove any installed backdoors, rootkits, or malware.
2.  **Patch Vulnerabilities**: Address the root cause of the unauthorized access by patching exploited vulnerabilities.
3.  **Rebuild/Reimage Systems**: For severely compromised systems, consider reimaging from a trusted golden image or rebuilding from scratch.
4.  **Reset Credentials**: Reset all passwords and regenerate SSH keys for affected systems and accounts.

## 6. Recovery

**Objective**: Restore affected systems and services to normal operation.

**Steps**:
1.  **Restore from Clean Backups**: Restore data and configurations from verified clean backups (taken before the incident).
2.  **Verify System Integrity**: Conduct thorough checks to ensure all systems are clean and functioning correctly.
3.  **Monitor Closely**: Implement enhanced monitoring for the recovered systems to detect any recurrence of the attack.
4.  **Gradual Reintroduction**: Gradually reintroduce systems back into the production environment, starting with the least critical.

## 7. Post-Incident Activity

**Objective**: Learn from the incident and improve security posture.

**Steps**:
1.  **Lessons Learned Meeting**: Conduct a meeting with all involved parties to discuss what happened, what worked well, and what could be improved.
2.  **Update Policies and Procedures**: Revise security policies, incident response plans, and playbooks based on lessons learned.
3.  **Enhance Controls**: Implement new security controls or strengthen existing ones to prevent similar incidents in the future.
4.  **Report (if required)**: Fulfill any legal or regulatory reporting requirements.
5.  **Training**: Provide additional security awareness training to users and technical staff.

## 8. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [SANS Incident Response Steps](https://www.sans.org/blog/the-six-steps-of-incident-response/)
