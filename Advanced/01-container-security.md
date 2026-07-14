# 01 - Container Security

Containerization technologies like Docker have revolutionized application deployment, but they also introduce new security challenges. This section outlines best practices for securing containerized environments at the Docker/container runtime level.

For Kubernetes-specific security guidance, see [Cloud-Security/04-kubernetes-security-best-practices.md](../Cloud-Security/04-kubernetes-security-best-practices.md).

## 1. Container Image Hardening

Securing container images is the first step in protecting your containerized applications.

*   **Use Minimal Base Images**: Start with minimal, official base images (e.g., Alpine Linux, Distroless) to reduce the attack surface by minimizing the number of installed packages and dependencies.
*   **Scan Images for Vulnerabilities**: Integrate image scanning tools into your CI/CD pipeline to automatically detect known vulnerabilities in operating system packages and application dependencies. Tools like Trivy, Clair, or Sysdig can be used for this purpose.
*   **Sign Container Images**: Use tools like Cosign or Docker Content Trust to sign container images, ensuring their authenticity and integrity throughout the supply chain.
*   **Avoid Sensitive Information in Images**: Do not embed sensitive information (e.g., API keys, passwords) directly into container images. Use secrets management solutions or environment variables at runtime instead.
*   **Keep Images Updated**: Regularly rebuild images with updated base images and dependencies to incorporate security patches.

## 2. Container Runtime Security

Protecting containers during their execution is crucial to prevent exploits and unauthorized access.

*   **Run Containers as Non-Root Users**: Configure containers to run as non-root users whenever possible. Add `USER <non-root-user>` to your Dockerfile. This significantly limits the potential impact of a container compromise.
*   **Drop Unnecessary Capabilities**: Containers often run with more Linux capabilities than they need. Drop unnecessary capabilities using `--cap-drop` flag (e.g., `CAP_NET_RAW`, `CAP_SYS_ADMIN`) to restrict what a container can do on the host system.
*   **Implement Seccomp Profiles**: Use Seccomp (Secure Computing Mode) profiles to restrict system calls a container can make. Docker provides a default seccomp profile, but custom profiles can provide tighter security.
*   **Use AppArmor/SELinux Profiles**: Implement AppArmor or SELinux profiles to further confine container processes and limit their access to host resources.
*   **Read-Only Filesystems**: Mount container filesystems as read-only where possible using `--read-only` flag to prevent unauthorized writes to the container image.
*   **Resource Limits**: Set CPU and memory limits for containers using `--memory` and `--cpus` flags to prevent resource exhaustion attacks.
*   **Disable Privileged Mode**: Never run containers in privileged mode (`--privileged`) unless absolutely necessary, as this gives the container full access to the host.

## 3. Docker Daemon Security

The Docker daemon runs with root privileges and must be secured.

*   **Restrict Docker Daemon Access**: Only trusted users should be able to control the Docker daemon. Adding a user to the `docker` group grants root-equivalent privileges.
*   **Enable Docker Content Trust**: Set `DOCKER_CONTENT_TRUST=1` to enforce image signature verification.
*   **Use TLS for Remote Access**: If remote access to the Docker daemon is required, always use TLS encryption with client certificates.
*   **Audit Docker Commands**: Enable logging of Docker commands for audit and forensic purposes.

## 4. Network Security

*   **Isolate Container Networks**: Use Docker networks to isolate containers from each other and from the host network.
*   **Limit Port Exposure**: Only expose necessary ports using `-p` flag. Avoid using `--publish-all` or `-P`.
*   **Use Internal Networks**: For containers that don't need external access, create internal Docker networks without port publishing.

## 5. Supply Chain Security

Protecting the container supply chain is crucial to prevent malicious code from entering your environment.

*   **Trusted Registries**: Use trusted and private container registries to store and distribute your images. Verify the source of base images.
*   **Vulnerability Management**: Continuously monitor for new vulnerabilities in your images and dependencies, and establish a process for rapid patching and remediation.
*   **Software Bill of Materials (SBOM)**: Generate and maintain SBOMs for your container images to understand all components and their dependencies.
*   **Pin Image Versions**: Avoid using `:latest` tags. Pin specific image versions or digests to ensure reproducibility and prevent unexpected changes.

## Practical Example: Secure Dockerfile

```dockerfile
# Use minimal base image
FROM alpine:3.19

# Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -D appuser

# Install only necessary packages
RUN apk --no-cache add ca-certificates

# Set working directory
WORKDIR /app

# Copy application files
COPY --chown=appuser:appgroup . .

# Switch to non-root user
USER appuser

# Define health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost:8080/health || exit 1

# Expose only necessary port
EXPOSE 8080

# Run application
CMD ["./app"]
```

## Verification Steps

1. **Check for running containers as root:**
   ```bash
   docker ps --format "{{.Names}}\t{{.User}}" | grep -v ":[0-9]"
   ```

2. **Scan image for vulnerabilities:**
   ```bash
   trivy image your-image-name:tag
   ```

3. **Verify container capabilities:**
   ```bash
   docker inspect <container-id> | grep -i cap
   ```

4. **Check for privileged containers:**
   ```bash
   docker ps --format "{{.Names}}\t{{.Status}}" 
   docker inspect <container-id> | grep -i privileged
   ```

## References

[1] [17 comprehensive container security best practices for 2026 - Sysdig](https://www.sysdig.com/learn-cloud-native/container-security-best-practices)
[2] [Docker Security Best Practices](https://docs.docker.com/engine/security/)
[3] [OWASP Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
