# 04 - Kubernetes Security

Kubernetes environments require layered security across the cluster, workloads, and runtime. This section covers Pod Security Standards, network policies, secrets management, and RBAC.

## 1. Pod Security Standards (PSS)

Kubernetes defines three Pod Security Standards that replace the deprecated PodSecurityPolicy [4].

### Enforcement Levels

| Level | Description |
|-------|-------------|
| **Privileged** | Unrestricted, provides the widest possible level of permissions |
| **Baseline** | Minimally restrictive, prevents known privilege escalations |
| **Restricted** | Heavily restricted, follows current pod hardening best practices |

### Apply Pod Security Standards

```yaml
# Enforce baseline on a namespace
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

### Key Restrictions at Each Level

```yaml
# Baseline prevents:
# - Host network, host PID, host IPC
# - Privileged containers
# - Specific volume types (hostPath, etc.)
# - Adding capabilities beyond a defined set

# Restricted additionally enforces:
# - Must run as non-root
# - Must drop ALL capabilities
# - Must use seccomp profile RuntimeDefault or Localhost
# - Must set fsGroup and runAsGroup
```

## 2. Network Policies

Network Policies control pod-to-pod and pod-to-external traffic. By default, Kubernetes allows all traffic between pods.

### Default Deny All Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### Allow Specific Traffic

```yaml
# Allow only the frontend to reach the backend
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### Restrict Egress

```yaml
# Allow backend to reach only the database on port 5432
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-egress-to-db
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
  # Allow DNS resolution
  - to: []
    ports:
    - protocol: UDP
      port: 53
```

## 3. Secrets Management

### Use Kubernetes Secrets (Baseline)

```yaml
# Create a secret
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password='S3cur3P@ss'

# Reference in a pod
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - name: app
    image: myapp:latest
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
```

### External Secrets Management (Recommended)

For production, use external secrets managers:

*   **HashiCorp Vault**: Centralized secrets with dynamic credential generation
*   **AWS Secrets Manager** / **Azure Key Vault** / **GCP Secret Manager**: Cloud-native solutions
*   **Sealed Secrets** / **SOPS**: Encrypt secrets for safe storage in Git

```yaml
# Example: External Secrets Operator with AWS Secrets Manager
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: db-credentials
  data:
  - secretKey: password
    remoteRef:
      key: prod/database/password
```

## 4. Role-Based Access Control (RBAC)

```yaml
# Create a read-only role for developers
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: production
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "watch"]

---
# Bind the role to a user group
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: production
subjects:
- kind: Group
  name: developers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### Audit RBAC

```bash
# Check who has cluster-admin
kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.roleRef.name=="cluster-admin") | .subjects[].name'

# List all RoleBindings in a namespace
kubectl get rolebindings -n production -o wide

# Check if anonymous access is enabled
kubectl auth can-i list pods --as=system:anonymous
```

## 5. Additional Hardening

*   **Enable Audit Logging**: Configure Kubernetes audit logging to track API server requests.
*   **Use Admission Controllers**: Enable Pod Security Admission, OPA/Gatekeeper, or Kyverno to enforce policies.
*   **Scan Images**: Integrate Trivy, Grype, or Snyk into CI/CD to scan container images before deployment.
*   **Runtime Security**: Deploy Falco or Tetragon for runtime threat detection.
*   **Rotate Certificates**: Ensure cluster certificates are rotated regularly and before expiration.

```bash
# Check certificate expiration
kubeadm certs check-expiration

# Enable audit logging (in kube-apiserver)
# --audit-policy-file=/etc/kubernetes/audit-policy.yaml
# --audit-log-path=/var/log/kubernetes/audit.log
# --audit-log-maxage=30
# --audit-log-maxbackup=10
# --audit-log-maxsize=100
```

## References

[4] [Kubernetes Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
