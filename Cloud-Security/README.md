# Cloud Security Best Practices

This directory provides best practices and recommendations for securing virtual machines and other resources in major cloud providers: Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP). While many on-premise security principles apply, cloud environments introduce unique considerations and shared responsibility models.

## 📖 Table of Contents

- [Introduction to Cloud Security](#introduction-to-cloud-security)
- [01 - AWS Security Best Practices](./01-aws-security-best-practices.md)
- [02 - Azure Security Best Practices](./02-azure-security-best-practices.md)
- [03 - GCP Security Best Practices](./03-gcp-security-best-practices.md)
- [04 - Kubernetes Security Best Practices](./04-kubernetes-security-best-practices.md)
- [05 - Serverless Security Best Practices](./05-serverless-security-best-practices.md)
- [06 - API Security Best Practices](./06-api-security-best-practices.md)

## Introduction to Cloud Security

Cloud computing offers immense flexibility and scalability, but it also shifts some security responsibilities. The **Shared Responsibility Model** is a key concept in cloud security:

*   **Cloud Provider (e.g., AWS, Azure, GCP)**: Responsible for the security *of* the cloud (e.g., physical infrastructure, global network, virtualization layer).
*   **Customer**: Responsible for security *in* the cloud (e.g., operating systems, network configuration, applications, data, identity and access management).

This section focuses on the customer's responsibilities, providing actionable guidance to secure your cloud deployments effectively.

## Key Takeaways

*   **Shared responsibility is foundational**: Cloud providers secure the underlying cloud infrastructure, while customers must secure identities, data, workloads, networks, applications, APIs, and configurations.
*   **Identity is the modern security perimeter**: Enforce least privilege, MFA, short-lived credentials, workload identities, and regular access reviews across AWS, Azure, GCP, Kubernetes, serverless, and API environments.
*   **Network exposure should be intentional**: Segment workloads, keep sensitive services private, restrict administrative access, control ingress and egress, and use private endpoints where possible.
*   **Encrypt and classify data everywhere**: Protect data at rest and in transit, manage keys carefully, classify sensitive data, and limit what applications and APIs return to callers.
*   **Logging and monitoring must be enabled before incidents**: Centralize cloud audit logs, network logs, workload logs, API logs, and security alerts so teams can detect misuse, investigate incidents, and meet compliance needs.
*   **Managed security services improve coverage**: Use native services such as cloud posture management, threat detection, WAF, DDoS protection, key management, secret management, and policy enforcement to reduce operational gaps.
*   **Cloud-native workloads need lifecycle security**: Harden images, functions, clusters, deployment pipelines, dependencies, infrastructure-as-code, and runtime configurations.
*   **APIs require dedicated controls**: Inventory APIs, validate tokens and object-level authorization, enforce schema validation, rate limit abusive clients, protect secrets, and monitor for anomalous access.
*   **Resilience is part of security**: Backups, tested recovery, autoscaling, rate limiting, graceful degradation, multi-zone design, and incident response playbooks reduce the impact of outages and attacks.
*   **Continuous improvement is required**: Review configurations, rotate credentials, patch dependencies, test controls, update baselines, and incorporate lessons learned from incidents and audits.

## Cloud Security Posture Management (CSPM) and Cloud Workload Protection (CWP)

### CSPM

CSPM continuously monitors cloud configurations against security benchmarks and compliance frameworks, automatically detecting misconfigurations.

| Provider | CSPM Tool | Key Capabilities |
|----------|-----------|-----------------|
| AWS | AWS Security Hub, AWS Config | Compliance checks, CIS Benchmark scoring, aggregated findings |
| Azure | Microsoft Defender for Cloud | Secure score, regulatory compliance, misconfiguration alerts |
| GCP | Security Command Center Premium | Vulnerability scanning, threat detection, compliance monitoring |
| Multi-cloud | Prisma Cloud, Wiz, Lacework | Cross-provider posture management |

### CWPP

CWPP protects workloads (VMs, containers, serverless) at runtime with threat detection, vulnerability management, and compliance enforcement.

| Provider | CWPP Tool | Key Capabilities |
|----------|-----------|-----------------|
| AWS | Amazon Inspector, GuardDuty | Vulnerability scanning, threat detection |
| Azure | Defender for Servers, Defender for Containers | Agent-based protection, runtime monitoring |
| GCP | Event Threat Detection, Container Threat Detection | Log analysis, container runtime protection |
| Multi-cloud | CrowdStrike Falcon, Sysdig Secure | Cross-provider workload protection |
