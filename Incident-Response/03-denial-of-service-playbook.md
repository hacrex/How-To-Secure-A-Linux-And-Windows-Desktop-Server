# 03 - Denial of Service (DoS/DDoS) Playbook

This playbook provides a structured approach to respond to Denial of Service (DoS) and Distributed Denial of Service (DDoS) incidents targeting server systems, covering both Linux and Windows environments.

## 1. Incident Overview

**Incident Type**: Denial of Service (DoS/DDoS)
**Severity**: High
**Impact**: Service unavailability, reputational damage, financial loss, resource exhaustion.

## 2. Detection

**Indicators of Compromise (IoCs)**:
*   **Unusual Traffic Spikes**: Sudden, unexplained increases in network traffic (inbound or outbound).
*   **Service Unavailability**: Websites, applications, or services become unresponsive or extremely slow.
*   **High Resource Utilization**: Sustained high CPU, memory, or network I/O on servers without corresponding legitimate activity.
*   **Firewall/IDS/IPS Alerts**: Alerts indicating high connection rates, SYN floods, UDP floods, or other attack patterns.
*   **Log Anomalies**: Excessive connection attempts, error messages related to resource exhaustion.
*   **User Reports**: Customers or internal users reporting inability to access services.

**Detection Tools**:
*   Network monitoring tools (e.g., NetFlow, sFlow analyzers)
*   Load balancer statistics
*   Firewall/Router logs
*   IDS/IPS systems
*   SIEM (Splunk, ELK, Sentinel)
*   Cloud provider monitoring (e.g., AWS CloudWatch, Azure Monitor, GCP Monitoring)

## 3. Analysis

**Objective**: Identify the type of DoS/DDoS attack, its source, and the targeted services.

**Steps**:
1.  **Verify Incident**: Confirm the DoS/DDoS attack. Is it a legitimate traffic surge or a malicious attack?
2.  **Identify Attack Type**: Determine if it's a volumetric attack (e.g., UDP flood, SYN flood), protocol attack (e.g., fragmented packets), or application-layer attack (e.g., HTTP flood).
3.  **Determine Attack Source**: Identify source IP addresses, geographic locations, and attack patterns.
4.  **Identify Targeted Services**: Which applications, servers, or network components are being targeted?
5.  **Timeline Creation**: Establish a timeline of events.
6.  **Collect Evidence**: Securely collect network traffic captures (if feasible), logs from firewalls, load balancers, and servers.

**Key Questions**:
*   What is the volume and type of attack traffic?
*   Where is the attack originating from?
*   Which services are most affected?
*   Is it a sustained attack or intermittent?

## 4. Containment

**Objective**: Mitigate the attack and restore service availability.

**Steps**:
1.  **Activate DDoS Mitigation Services**: If subscribed, activate cloud-based DDoS protection services (e.g., Cloudflare, Akamai, AWS Shield, Azure DDoS Protection, Google Cloud Armor).
2.  **Blackhole/Null Route Attackers**: If the attack is from a limited number of IPs, blackhole or null route them at the network edge (ISP or upstream provider).
3.  **Rate Limiting**: Implement rate limiting on firewalls, load balancers, or web servers to restrict traffic from suspicious sources.
4.  **Filter Traffic**: Use firewalls or ACLs to filter traffic based on known attack signatures, protocols, or ports.
5.  **Increase Capacity**: If possible, scale up resources (bandwidth, server instances) to absorb the attack traffic.
6.  **Change IP Addresses**: For direct IP attacks, changing the public IP address of the targeted service might be an option (though often temporary).

## 5. Eradication

**Objective**: Fully stop the attack and remove any lingering effects.

**Steps**:
1.  **Verify Attack Cessation**: Confirm that the attack traffic has subsided or been successfully mitigated.
2.  **Remove Temporary Blocks**: Carefully remove temporary blackholes or rate limits that might impede legitimate traffic.
3.  **Review System Health**: Ensure all systems are stable and operating normally after the attack.

## 6. Recovery

**Objective**: Restore full service functionality and optimize for future resilience.

**Steps**:
1.  **Monitor Closely**: Continue to monitor systems and network traffic closely for any signs of renewed attack or lingering issues.
2.  **Verify Service Availability**: Confirm that all affected services are fully operational and accessible to legitimate users.
3.  **Optimize Configurations**: Adjust firewall rules, load balancer settings, and application configurations based on lessons learned from the attack.

## 7. Post-Incident Activity

**Objective**: Learn from the incident and improve DDoS defenses.

**Steps**:
1.  **Lessons Learned Meeting**: Conduct a meeting to discuss the attack, the effectiveness of the response, and areas for improvement.
2.  **Update Policies and Procedures**: Revise DDoS response plans and playbooks.
3.  **Enhance Defenses**: Invest in stronger DDoS mitigation solutions, increase network capacity, or implement more robust traffic filtering rules.
4.  **Threat Intelligence**: Share IoCs with relevant security communities or threat intelligence platforms.

## 8. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [OWASP Denial of Service](https://owasp.org/www-community/attacks/Denial_of_Service)
*   [Cloudflare DDoS Protection](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
