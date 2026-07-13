# Cloud Security Best Practices

This directory provides best practices and recommendations for securing virtual machines and other resources in major cloud providers: Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP). While many on-premise security principles apply, cloud environments introduce unique considerations and shared responsibility models.

## 📖 Table of Contents

- [Introduction to Cloud Security](#introduction-to-cloud-security)
- [01 - AWS Security Best Practices](./01-aws-security-best-practices.md)
- [02 - Azure Security Best Practices](./02-azure-security-best-practices.md)
- [03 - GCP Security Best Practices](./03-gcp-security-best-practices.md)
- [04 - Kubernetes Security Best Practices](./04-kubernetes-security-best-practices.md)
- [05 - Serverless Security Best Practices](./05-serverless-security-best-practices.md)

## Introduction to Cloud Security

Cloud computing offers immense flexibility and scalability, but it also shifts some security responsibilities. The **Shared Responsibility Model** is a key concept in cloud security:

*   **Cloud Provider (e.g., AWS, Azure, GCP)**: Responsible for the security *of* the cloud (e.g., physical infrastructure, global network, virtualization layer).
*   **Customer**: Responsible for security *in* the cloud (e.g., operating systems, network configuration, applications, data, identity and access management).

This section focuses on the customer's responsibilities, providing actionable guidance to secure your cloud deployments effectively.
