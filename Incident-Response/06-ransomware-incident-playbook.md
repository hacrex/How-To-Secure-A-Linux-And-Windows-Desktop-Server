# 06 - Ransomware Incident Playbook

This playbook provides a structured approach to respond to ransomware incidents, covering detection, analysis, containment, eradication, and recovery steps. Ransomware is a critical threat that can severely disrupt operations and lead to significant data loss or financial demands.

## 1. Incident Overview

**Incident Type**: Ransomware Attack
**Severity**: Critical
**Impact**: Data encryption, system unavailability, data exfiltration (double extortion), financial loss, reputational damage, operational disruption.

## 2. Detection

**Indicators of Compromise (IoCs)**:
*   **Encrypted Files**: Files with unusual extensions (e.g., `.locked`, `.crypt`), or files that are suddenly inaccessible.
*   **Ransom Notes**: Text files (e.g., `README.txt`, `HOW_TO_DECRYPT.txt`) appearing in multiple directories, or desktop backgrounds changed to a ransom message.
*   **Unusual File Activity**: High CPU/disk I/O, rapid creation/modification of files, especially in shared drives or cloud storage.
*   **Network Activity**: Connections to known ransomware C2 servers, unusual outbound traffic (for data exfiltration).
*   **Security Software Alerts**: Antivirus/EDR alerts for suspicious file encryption, process injection, or known ransomware signatures.
*   **System Performance Degradation**: Servers becoming unresponsive or extremely slow.
*   **User Reports**: Users reporting inability to access files, or seeing ransom notes.

**Detection Tools**:
*   Endpoint Detection and Response (EDR) solutions
*   Antivirus/Anti-malware software
*   Security Information and Event Management (SIEM)
*   File Integrity Monitoring (FIM)
*   Network monitoring tools
*   User reports

## 3. Analysis

**Objective**: Determine the ransomware variant, infection vector, scope of encryption, and potential data exfiltration.

**Steps**:
1.  **Verify Incident**: Confirm the ransomware infection. Is it a false positive?
2.  **Identify Ransomware Variant**: If possible, identify the specific ransomware strain (e.g., by ransom note, file extension, online tools like ID Ransomware).
3.  **Determine Infection Vector**: How did the ransomware gain access? (e.g., phishing, RDP compromise, exploited vulnerability, supply chain attack).
4.  **Identify Affected Systems**: Determine which servers, workstations, network shares, and cloud storage have been encrypted or accessed.
5.  **Assess Data Exfiltration**: Look for evidence of data exfiltration (double extortion). Check network logs for large outbound transfers.
6.  **Timeline Creation**: Establish a detailed timeline of events, from initial compromise to encryption.
7.  **Collect Evidence**: Securely collect logs, memory dumps, disk images of encrypted systems, and network traffic captures for forensic analysis. **DO NOT** attempt to decrypt files or make changes that could destroy evidence.

**Key Questions**:
*   What is the initial access vector?
*   What is the scope of encryption (which systems, which data)?
*   Was data exfiltrated?
*   Are there any persistence mechanisms?
*   Is there a decryption key available (unlikely without paying ransom)?

## 4. Containment

**Objective**: Stop the spread of ransomware and prevent further encryption or data exfiltration.

**Steps**:
1.  **Isolate Infected Systems**: Immediately disconnect all infected systems from the network. This includes servers, workstations, and network storage.
2.  **Quarantine Suspected Systems**: Isolate any systems that show early signs of infection or are directly connected to infected systems.
3.  **Disable Network Shares**: Disable or restrict access to all network shares (SMB, NFS) to prevent lateral movement.
4.  **Block Malicious IPs/Domains**: Update firewalls and network ACLs to block known ransomware C2 server IPs and domains.
5.  **Disable Compromised Accounts**: Immediately disable or reset passwords for any accounts suspected of being compromised or used by the ransomware.
6.  **Review Backups**: Verify the integrity and age of your backups. Ensure backups are isolated and not accessible to the ransomware.

## 5. Eradication

**Objective**: Eliminate the ransomware and its remnants from the environment.

**Steps**:
1.  **Remove Malware**: Identify and remove all ransomware components, backdoors, and persistence mechanisms.
2.  **Patch Vulnerabilities**: Address the root cause of the infection by patching exploited vulnerabilities.
3.  **Rebuild/Reimage Systems**: For all infected systems, the safest approach is to wipe and reimage from trusted golden images or rebuild from scratch. Do not attempt to clean an infected OS.
4.  **Reset Credentials**: Reset all passwords and regenerate SSH keys for affected systems and accounts, and any related systems.

## 6. Recovery

**Objective**: Restore affected systems and services to normal operation using clean data.

**Steps**:
1.  **Restore from Clean Backups**: Restore data and configurations from verified clean, immutable backups (taken before the infection). Prioritize critical systems and data.
2.  **Verify System Integrity**: Conduct thorough checks to ensure all systems are clean, secure, and functioning correctly after restoration.
3.  **Monitor Closely**: Implement enhanced monitoring for the recovered systems to detect any recurrence of the infection.
4.  **Gradual Reintroduction**: Gradually reintroduce systems back into the production environment, starting with the least critical.

## 7. Post-Incident Activity

**Objective**: Learn from the incident, improve security posture, and fulfill legal/regulatory obligations.

**Steps**:
1.  **Lessons Learned Meeting**: Conduct a meeting with all involved parties to discuss what happened, what worked well, and what could be improved.
2.  **Update Policies and Procedures**: Revise security policies, incident response plans, and playbooks based on lessons learned. Specifically update backup strategies and ransomware defenses.
3.  **Enhance Controls**: Implement new security controls or strengthen existing ones (e.g., EDR, advanced threat intelligence, network segmentation, immutable backups) to prevent similar incidents.
4.  **Legal and Regulatory Compliance**: Consult with legal counsel to determine notification requirements (e.g., to affected individuals, regulatory bodies, law enforcement).
5.  **Public Relations**: Develop a communication plan for external stakeholders if public disclosure is necessary.
6.  **Training**: Provide additional security awareness training to users and technical staff, focusing on ransomware prevention and detection.

## 8. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [CISA Ransomware Guide](https://www.cisa.gov/stopransomware/ransomware-guide)
*   [No More Ransom! Project](https://www.nomoreransom.org/)
