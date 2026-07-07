# 01 - Container Security

Containerization technologies like Docker and Kubernetes have revolutionized application deployment, but they also introduce new security challenges. This section outlines best practices for securing containerized environments.

## 1. Container Image Hardening

Securing container images is the first step in protecting your containerized applications.

*   **Use Minimal Base Images**: Start with minimal, official base images (e.g., Alpine Linux) to reduce the attack surface by minimizing the number of installed packages and dependencies [1].
*   **Scan Images for Vulnerabilities**: Integrate image scanning tools into your CI/CD pipeline to automatically detect known vulnerabilities in operating system packages and application dependencies. Tools like Sysdig, Clair, or Trivy can be used for this purpose [1].
*   **Sign Container Images**: Use tools like Cosign to sign container images, ensuring their authenticity and integrity throughout the supply chain [1].
*   **Avoid Sensitive Information in Images**: Do not embed sensitive information (e.g., API keys, passwords) directly into container images. Use secrets management solutions instead.

## 2. Container Runtime Security

Protecting containers during their execution is crucial to prevent exploits and unauthorized access.

*   **Run Containers as Non-Root Users**: Configure containers to run as non-root users whenever possible. This significantly limits the potential impact of a container compromise [1].
*   **Drop Unnecessary Capabilities**: Containers often run with more Linux capabilities than they need. Drop unnecessary capabilities (e.g., `CAP_NET_RAW`, `CAP_SYS_ADMIN`) to restrict what a container can do on the host system [1].
*   **Implement Seccomp and AppArmor/SELinux Profiles**: Use Seccomp (Secure Computing Mode) profiles to restrict system calls a container can make. Implement AppArmor or SELinux profiles to further confine container processes [1].
*   **Read-Only Filesystems**: Mount container filesystems as read-only where possible to prevent unauthorized writes to the container image.
*   **Resource Limits**: Set CPU and memory limits for containers to prevent resource exhaustion attacks.

## 3. Kubernetes Security Best Practices

Securing Kubernetes clusters involves multiple layers, from the cluster infrastructure to individual pods.

*   **Role-Based Access Control (RBAC)**: Implement strict RBAC policies to control who can access the Kubernetes API and what actions they can perform. Follow the principle of least privilege [1].
*   **Network Policies**: Use Kubernetes Network Policies to control traffic flow between pods and namespaces, isolating applications and limiting lateral movement in case of a breach [1].
*   **Pod Security Standards/Admission Controllers**: Implement Pod Security Standards (or older Pod Security Policies) or other admission controllers to enforce security best practices for pods, such as preventing privileged containers or requiring read-only root filesystems.
*   **Secrets Management**: Use Kubernetes Secrets or integrate with external secrets management solutions (e.g., HashiCorp Vault, AWS Secrets Manager) to securely store and manage sensitive data.
*   **API Server Security**: Secure access to the Kubernetes API server, which is the central control plane component. Use strong authentication, authorization, and encrypt communication.
*   **Regular Auditing and Logging**: Enable audit logging for the Kubernetes API server and send logs to a centralized logging system for monitoring and analysis.
*   **Node Security**: Harden Kubernetes worker nodes by applying operating system security best practices, regularly patching, and minimizing installed software.

## 4. Supply Chain Security

Protecting the container supply chain is crucial to prevent malicious code from entering your environment.

*   **Trusted Registries**: Use trusted and private container registries to store and distribute your images.
*   **Vulnerability Management**: Continuously monitor for new vulnerabilities in your images and dependencies, and establish a process for rapid patching and remediation.
*   **Software Bill of Materials (SBOM)**: Generate and maintain SBOMs for your container images to understand all components and their dependencies.

## References

[1] [17 comprehensive container security best practices for 2026 - Sysdig](https://www.sysdig.com/learn-cloud-native/container-security-best-practices)
