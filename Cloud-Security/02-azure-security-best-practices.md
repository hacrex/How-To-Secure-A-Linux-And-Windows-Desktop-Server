# 02 - Azure Security Best Practices

This guide outlines key security best practices for Microsoft Azure environments, focusing on securing Virtual Machines, Identity, Networking, and Data.

## 1. Identity and Access Management (IAM)

*   **Azure Active Directory (Azure AD)**: Use Azure AD as the central identity store. Enforce strong authentication policies.
*   **Principle of Least Privilege**: Grant only the necessary permissions. Use Azure RBAC (Role-Based Access Control) to assign roles with the minimum required privileges.
*   **MFA Everywhere**: Enable Multi-Factor Authentication (MFA) for all user accounts, especially administrators.
*   **Conditional Access**: Implement Azure AD Conditional Access policies to enforce stricter controls based on user location, device, or application.
*   **Managed Identities**: Use Managed Identities for Azure resources to authenticate to cloud services without managing credentials directly.
*   **Privileged Identity Management (PIM)**: Use Azure AD PIM to provide just-in-time and just-enough access to Azure resources.

## 2. Network Security

*   **Azure Virtual Network (VNet)**: Segment your network using VNets and subnets. Isolate sensitive resources in dedicated subnets.
*   **Network Security Groups (NSGs)**: Act as virtual firewalls for VMs and subnets. Configure NSGs with the principle of least privilege, allowing only necessary inbound and outbound traffic.
*   **Azure Firewall**: Deploy Azure Firewall for centralized network security across hybrid and multi-cloud environments.
*   **Azure DDoS Protection**: Enable Azure DDoS Protection for your VNets to safeguard against large-scale attacks.
*   **Azure WAF**: Deploy Azure Web Application Firewall (WAF) on Azure Application Gateway or Azure Front Door to protect web applications from common web exploits.
*   **VPN Gateway/ExpressRoute**: Use Azure VPN Gateway or ExpressRoute for secure, private connectivity between your on-premises data centers and Azure.

## 3. Compute Security (Virtual Machines)

*   **Secure Images**: Use hardened VM images from Azure Marketplace or create custom images with security best practices applied.
*   **Patch Management**: Keep VMs patched and updated. Use Azure Update Management to manage updates across your Azure and on-premises machines.
*   **Azure Security Center (Defender for Cloud)**: Enable Azure Security Center for continuous security posture management, threat protection, and vulnerability assessment for your VMs.
*   **Host-Based Security**: Install and configure host-based firewalls (e.g., Windows Defender Firewall on Windows, `ufw` on Linux) and antivirus/EDR solutions on VMs.
*   **Disable Unnecessary Services**: Turn off any services not required for the VM's function.

## 4. Data Protection

*   **Encryption at Rest**: Encrypt VM disks (Azure Disk Encryption), storage accounts (Azure Storage Service Encryption), databases (Azure SQL Database Transparent Data Encryption), and other data stores. Use Azure Key Vault for managing encryption keys.
*   **Encryption in Transit**: Enforce TLS for all data in transit (e.g., between clients and VMs, between VMs and databases).
*   **Azure Storage Access**: Implement strict access policies for Azure Storage accounts. Use Shared Access Signatures (SAS) or Azure AD authentication for granular access.
*   **Backup and Recovery**: Implement regular backups of all critical data using Azure Backup. Test recovery procedures.

## 5. Logging and Monitoring

*   **Azure Monitor**: Use Azure Monitor for collecting, analyzing, and acting on telemetry from your Azure and on-premises environments. Set up alerts for suspicious activities.
*   **Azure Activity Log**: Provides a history of subscription-level events (e.g., resource creation, deletion).
*   **Azure AD Audit Logs**: Track changes made in Azure AD.
*   **Azure Sentinel**: Deploy Azure Sentinel as your cloud-native SIEM and SOAR (Security Orchestration, Automation, and Response) solution for intelligent security analytics.
*   **Network Watcher**: Use Azure Network Watcher to monitor, diagnose, and gain insights into your network performance and security.

## 6. Compliance and Governance

*   **Azure Policy**: Use Azure Policy to create, assign, and manage policies that enforce rules and effects over your resources, ensuring compliance with security standards.
*   **Azure Blueprints**: Use Azure Blueprints to define a repeatable set of Azure resources that implement and adhere to an organization's standards, patterns, and requirements.
*   **Security Baselines**: Implement security baselines based on CIS Benchmarks for Azure.

## 7. References

*   [Azure Security Best Practices](https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices)
*   [Azure Well-Architected Framework - Security Pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/security/security-overview)
*   [CIS Microsoft Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure/)
