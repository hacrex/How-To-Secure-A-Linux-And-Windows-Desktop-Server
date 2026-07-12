# 01 - AWS Security Best Practices

This guide outlines key security best practices for Amazon Web Services (AWS) environments, focusing on securing EC2 instances, IAM, networking, and data.

## 1. Identity and Access Management (IAM)

*   **Principle of Least Privilege**: Grant only the permissions required to perform a task. Avoid using `*` for actions or resources.
*   **MFA Everywhere**: Enable Multi-Factor Authentication (MFA) for all root and IAM user accounts.
*   **Strong Passwords**: Enforce strong password policies for IAM users.
*   **IAM Roles**: Use IAM roles for EC2 instances and other AWS services instead of embedding access keys directly.
*   **Access Keys Management**: Regularly rotate access keys. Delete unused access keys.
*   **IAM Access Analyzer**: Use IAM Access Analyzer to identify unintended access to your external entities.

## 2. Network Security

*   **Security Groups**: Act as virtual firewalls for EC2 instances. Configure them with the principle of least privilege, allowing only necessary inbound and outbound traffic.
*   **Network ACLs (NACLs)**: Act as stateless firewalls for subnets. Use them as an additional layer of defense.
*   **VPC Design**: Segment your Virtual Private Cloud (VPC) into public and private subnets. Deploy public-facing resources in public subnets and sensitive resources (e.g., databases) in private subnets.
*   **VPC Flow Logs**: Enable VPC Flow Logs to monitor and troubleshoot network traffic.
*   **AWS WAF**: Deploy AWS Web Application Firewall (WAF) to protect web applications from common web exploits.
*   **Direct Connect/VPN**: Use AWS Direct Connect or VPN for secure, private connectivity between your on-premises data centers and AWS.

## 3. Compute Security (EC2)

*   **Secure AMIs**: Use hardened Amazon Machine Images (AMIs) or create your own with security best practices applied.
*   **Patch Management**: Keep EC2 instances patched and updated. Use AWS Systems Manager Patch Manager.
*   **Instance Metadata Service (IMDSv2)**: Enforce IMDSv2 to protect against Server-Side Request Forgery (SSRF) vulnerabilities.
*   **Host-Based Security**: Install and configure host-based firewalls (e.g., `ufw` on Linux, Windows Defender Firewall on Windows) and antivirus/EDR solutions on EC2 instances.
*   **Disable Unnecessary Services**: Turn off any services not required for the instance's function.

## 4. Data Protection

*   **Encryption at Rest**: Encrypt EBS volumes, S3 buckets, RDS databases, and other data stores. Use AWS Key Management Service (KMS) for managing encryption keys.
*   **Encryption in Transit**: Enforce TLS for all data in transit (e.g., between clients and EC2, between EC2 and RDS).
*   **S3 Bucket Policies**: Implement strict S3 bucket policies to prevent public access to sensitive data. Use S3 Block Public Access.
*   **Backup and Recovery**: Implement regular backups of all critical data. Test recovery procedures.

## 5. Logging and Monitoring

*   **CloudTrail**: Enable AWS CloudTrail to log all API calls made in your AWS account. This provides an audit trail of actions.
*   **CloudWatch**: Use Amazon CloudWatch for monitoring resources and applications. Set up alarms for suspicious activities.
*   **GuardDuty**: Enable Amazon GuardDuty for intelligent threat detection that monitors for malicious activity and unauthorized behavior.
*   **Security Hub**: Use AWS Security Hub to get a comprehensive view of your security alerts and security posture across your AWS accounts.
*   **VPC Flow Logs**: Monitor network traffic for anomalies.

## 6. Compliance and Governance

*   **AWS Config**: Use AWS Config to assess, audit, and evaluate the configurations of your AWS resources. It continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations.
*   **AWS Organizations**: Use AWS Organizations to centrally manage and govern your environment as you grow and scale your AWS resources.
*   **Security Baselines**: Implement security baselines based on CIS Benchmarks for AWS.

## 7. References

*   [AWS Well-Architected Framework - Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/security-pillar.html)
*   [AWS Security Best Practices](https://aws.amazon.com/security/)
*   [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/aws/)
