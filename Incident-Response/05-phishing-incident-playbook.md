# 05 - Phishing Incident Playbook

This playbook provides a structured approach to respond to phishing incidents, which are a common initial access vector for various cyberattacks. It covers detection, analysis, containment, eradication, and recovery steps.

## 1. Incident Overview

**Incident Type**: Phishing Attack (Email, SMS, Voice, Web)
**Severity**: Medium to High (depending on compromise level)
**Impact**: Credential theft, malware infection, data breach, financial fraud, unauthorized access.

## 2. Detection

**Indicators of Compromise (IoCs)**:
*   **User Reports**: Employee reports of suspicious emails, messages, or websites.
*   **Email Gateway Alerts**: Alerts from email security solutions (e.g., M365 Defender, Proofpoint) about malicious emails.
*   **Endpoint Protection Alerts**: Antivirus/EDR alerts indicating malware downloaded from a phishing link.
*   **Network Monitoring**: Unusual outbound connections, DNS queries to known malicious domains.
*   **Login Anomalies**: Failed login attempts, successful logins from unusual locations or devices after a user clicked a phishing link.
*   **Threat Intelligence Feeds**: Matching email/URL indicators against known phishing campaigns.

**Detection Tools**:
*   Email Security Gateways
*   Endpoint Detection and Response (EDR) solutions
*   Security Information and Event Management (SIEM)
*   Web Proxy/DNS logs
*   User awareness and reporting mechanisms

## 3. Analysis

**Objective**: Determine the scope, method, and impact of the phishing attack.

**Steps**:
1.  **Verify Incident**: Confirm the phishing attempt. Is it a legitimate email or a simulated phishing test?
2.  **Collect Phishing Artifacts**: Obtain the full email headers, body, attachments, and URLs. **DO NOT** click on links or open attachments on an unisolated system.
3.  **Identify Targeted Users/Groups**: Determine who received the phishing message and who interacted with it (clicked links, opened attachments, entered credentials).
4.  **Analyze Malicious Content**: Examine attachments for malware (in a sandbox environment) and URLs for malicious redirects or credential harvesting pages.
5.  **Check for Compromise**: For users who interacted with the phishing content:
    *   **Credential Theft**: Check login logs for suspicious activity (e.g., new logins, MFA bypass attempts) on all services (email, VPN, cloud apps).
    *   **Malware Infection**: Scan endpoints for malware. Review EDR alerts.
    *   **Data Exfiltration**: Check network logs for unusual outbound traffic.
6.  **Timeline Creation**: Establish a timeline of events.

**Key Questions**:
*   What was the nature of the phishing attack (credential harvesting, malware delivery, BEC)?
*   How many users were targeted and how many were compromised?
*   What information was potentially exposed or stolen?
*   Are there any signs of lateral movement or further compromise?

## 4. Containment

**Objective**: Limit the damage and prevent further spread of the phishing attack.

**Steps**:
1.  **Block Malicious Indicators**: Block sender email addresses, malicious URLs, and IP addresses at email gateways, firewalls, and web proxies.
2.  **Remove Phishing Emails**: If possible, recall or delete the phishing email from all inboxes across the organization.
3.  **Isolate Compromised Systems**: Disconnect any systems confirmed to be infected with malware or used for unauthorized access.
4.  **Reset Compromised Credentials**: Immediately force password resets for all users who entered credentials on a phishing site. Enforce MFA if not already in place.
5.  **Revoke Session Tokens**: Invalidate session tokens for any compromised accounts.
6.  **Communicate Internally**: Send out an internal alert to all employees about the phishing campaign, advising caution and how to report similar emails.

## 5. Eradication

**Objective**: Eliminate the attacker's presence and remove all malicious components and vulnerabilities.

**Steps**:
1.  **Clean Infected Systems**: Remove any malware from compromised endpoints. Reimage if necessary.
2.  **Close Vulnerabilities**: If the phishing attack exploited a vulnerability (e.g., unpatched software), apply the necessary patches.
3.  **Remove Persistence**: Check for and remove any backdoors or persistence mechanisms established by the attacker.
4.  **Enhance Email Filters**: Update email security rules to better detect and block similar phishing attempts.

## 6. Recovery

**Objective**: Restore affected systems and services to normal operation.

**Steps**:
1.  **Restore Data**: If data was corrupted or deleted, restore from clean backups.
2.  **Verify System Integrity**: Conduct thorough checks to ensure all systems are clean, secure, and functioning correctly.
3.  **Monitor Closely**: Implement enhanced monitoring for affected users and systems to detect any recurrence.
4.  **Re-enable Accounts**: Re-enable user accounts after verifying they are secure and credentials have been reset.

## 7. Post-Incident Activity

**Objective**: Learn from the incident and improve security posture.

**Steps**:
1.  **Lessons Learned Meeting**: Conduct a meeting with all involved parties to discuss what happened, what worked well, and what could be improved.
2.  **Update Policies and Procedures**: Revise security policies, incident response plans, and playbooks based on lessons learned.
3.  **Enhance Controls**: Implement new security controls (e.g., advanced email protection, stronger MFA, browser isolation) to prevent similar incidents.
4.  **Security Awareness Training**: Conduct targeted security awareness training for users, focusing on the specific phishing tactics used in the incident.
5.  **Report (if required)**: Fulfill any legal or regulatory reporting requirements.

## 8. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [CISA - Phishing](https://www.cisa.gov/topics/cyber-threats-and-advisories/phishing)
*   [APWG Phishing Activity Trends Report](https://docs.apwg.org/reports/apwg_trends_report_h2_2023.pdf)
