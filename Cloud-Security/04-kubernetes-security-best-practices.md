# 04 - Kubernetes Security Best Practices

Kubernetes has become the de facto standard for container orchestration, but securing it is complex due to its distributed nature and numerous components. This guide outlines key security best practices for Kubernetes clusters, applicable whether deployed on-premises or in cloud environments (AWS EKS, Azure AKS, GCP GKE).

## 1. Cluster Hardening

*   **Keep Kubernetes Updated**: Regularly update your Kubernetes cluster to the latest stable version to benefit from security patches and new features.
*   **Control Plane Security**: Ensure the Kubernetes API server, etcd, controller manager, and scheduler are secured:
    *   **API Server**: Restrict access to the API server, use strong authentication (mTLS, OIDC), and authorize requests with RBAC.
    *   **etcd**: Encrypt etcd data at rest and in transit. Restrict access to etcd to only the API server.
*   **Node Security**: Harden worker nodes:
    *   **Minimal OS**: Use a minimal, hardened operating system (e.g., Container-Optimized OS, Flatcar Linux).
    *   **Patch Management**: Keep node operating systems and container runtimes (Docker, containerd) updated.
    *   **Disable SSH**: If possible, disable direct SSH access to nodes and use managed services or bastion hosts.
    *   **Host-based Firewall**: Configure host-based firewalls on nodes.

## 2. Network Security

*   **Network Policies**: Implement Kubernetes Network Policies to control traffic flow between pods and namespaces. Adopt a 
default-deny approach.
*   **Pod Security Policies (PSPs) / Pod Security Admission (PSA)**: Enforce security standards for pods, such as disallowing privileged containers, restricting host path mounts, and requiring read-only root filesystems.
*   **Ingress/Egress Control**: Secure ingress (traffic into the cluster) with WAFs and API Gateways. Control egress (traffic out of the cluster) to prevent data exfiltration.
*   **Service Mesh**: Consider a service mesh (e.g., Istio, Linkerd) for advanced traffic management, mTLS, and policy enforcement between services.

## 3. Identity and Access Management (IAM)

*   **Role-Based Access Control (RBAC)**: Implement fine-grained RBAC to control who can access the Kubernetes API and what actions they can perform. Grant least privilege.
*   **Service Accounts**: Use dedicated service accounts for applications. Grant them only the necessary permissions via RBAC.
*   **Secrets Management**: Store sensitive information (API keys, database credentials) in Kubernetes Secrets, and consider integrating with external secret management solutions (e.g., HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager).
*   **Pod Identity**: Use cloud provider-specific features for pod identity (e.g., AWS IAM Roles for Service Accounts (IRSA), Azure AD Workload Identity, GCP Workload Identity) to grant pods access to cloud resources without exposing credentials.

## 4. Container Image Security

*   **Image Scanning**: Integrate container image scanning into your CI/CD pipeline to identify vulnerabilities and misconfigurations before deployment.
*   **Trusted Registries**: Use trusted and private container registries (e.g., Docker Hub, AWS ECR, Azure Container Registry, GCP Container Registry/Artifact Registry).
*   **Minimal Base Images**: Use minimal base images (e.g., Alpine Linux, Distroless) to reduce the attack surface.
*   **Sign and Verify Images**: Implement image signing and verification to ensure only trusted images are deployed.

## 5. Runtime Security

*   **Runtime Protection**: Deploy runtime security tools (e.g., Falco, Sysdig Secure) to detect and respond to suspicious activities within containers and on nodes.
*   **Container Sandboxing**: Use technologies like gVisor or Kata Containers to provide stronger isolation between containers and the host kernel.
*   **Security Context**: Define security contexts for pods and containers to control privilege and access settings (e.g., `runAsNonRoot`, `allowPrivilegeEscalation: false`).

## 6. Logging and Monitoring

*   **Centralized Logging**: Aggregate logs from Kubernetes components, pods, and nodes into a centralized logging solution (e.g., ELK Stack, Splunk, cloud-native logging services).
*   **Monitoring and Alerting**: Monitor cluster health, resource utilization, and security events. Set up alerts for suspicious activities.
*   **Audit Logs**: Enable Kubernetes audit logs to track API requests and actions within the cluster.

## 7. Compliance and Governance

*   **Policy Enforcement**: Use tools like OPA Gatekeeper or Kyverno to enforce policies and best practices across your cluster.
*   **Security Baselines**: Implement security baselines based on CIS Benchmarks for Kubernetes.
*   **Regular Audits**: Conduct regular security audits and penetration tests of your Kubernetes clusters.

## 8. References

*   [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)
*   [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/)
*   [OWASP Kubernetes Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html)
