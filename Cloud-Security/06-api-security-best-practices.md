# 06 - API Security Best Practices

APIs are a primary control plane and data access layer for cloud applications. Securing APIs requires strong identity, careful authorization, resilient edge controls, safe data handling, and continuous monitoring across the full API lifecycle.

## 1. Inventory and Governance

*   **Maintain an API Inventory**: Track every public, private, partner, and internal API, including owner, environment, data classification, authentication method, and exposure path.
*   **Classify API Data**: Identify APIs that process credentials, personal data, payment data, health data, secrets, administrative actions, or tenant-isolated records.
*   **Define Security Requirements Early**: Include authentication, authorization, rate limiting, logging, abuse handling, and privacy requirements during API design.
*   **Manage API Versions**: Deprecate old versions deliberately, communicate timelines, and remove unsupported endpoints that no longer receive security fixes.
*   **Document Contracts**: Keep OpenAPI or equivalent specifications current so gateways, tests, and security tools can validate expected behavior.

## 2. Authentication and Authorization

*   **Use Strong Authentication**: Prefer standards-based authentication such as OAuth 2.0, OpenID Connect, mutual TLS, or signed service-to-service tokens.
*   **Enforce Least Privilege**: Scope API tokens to specific audiences, actions, tenants, resources, and expiration windows.
*   **Validate Tokens Server-Side**: Verify issuer, audience, signature, expiration, not-before time, scopes, and token revocation requirements.
*   **Separate User and Machine Access**: Use dedicated identities and policies for users, workloads, CI/CD systems, and third-party integrations.
*   **Protect Against Broken Object Level Authorization**: Validate that the caller is allowed to access each object, account, tenant, or record requested, not just the endpoint.
*   **Require Step-Up Controls for Sensitive Actions**: Use MFA, reauthentication, privileged approval, or just-in-time authorization for administrative or destructive actions.

## 3. Input Validation and Data Protection

*   **Validate All Inputs**: Enforce strict schemas, types, lengths, ranges, allowlists, and content types at the gateway and application layers.
*   **Reject Unexpected Fields**: Prevent mass assignment by ignoring or rejecting properties that the caller should not be able to set.
*   **Normalize and Encode Safely**: Handle Unicode, path traversal, URL encoding, and output encoding consistently to reduce injection risk.
*   **Limit Sensitive Data Exposure**: Return only the fields needed by the caller and avoid exposing secrets, internal identifiers, stack traces, or implementation details.
*   **Encrypt in Transit**: Require modern TLS for all API traffic, including internal service-to-service calls.
*   **Protect Secrets**: Store API keys, signing keys, and credentials in managed secret stores. Rotate secrets regularly and immediately after exposure.

## 4. Rate Limiting, Abuse Prevention, and DDoS Resilience

*   **Apply Layered Rate Limits**: Limit by IP, account, tenant, user, token, API key, endpoint, method, and geographic or ASN risk where appropriate.
*   **Use Quotas and Burst Controls**: Define normal usage ceilings and short-term burst limits to protect downstream services.
*   **Protect Expensive Endpoints**: Add stricter controls to login, password reset, search, export, reporting, checkout, and bulk operations.
*   **Deploy Edge Protection**: Place public APIs behind API gateways, WAFs, bot management, CDN, and cloud DDoS protection when possible.
*   **Design for Graceful Degradation**: Return clear retry guidance, use backpressure, shed low-priority work, and protect critical paths during traffic spikes.
*   **Prevent Credential Stuffing**: Monitor failed logins, impossible travel, password spray indicators, and anomalous token use.

## 5. Secure API Gateways and Network Controls

*   **Centralize Policy Enforcement**: Use API gateways to enforce authentication, authorization, TLS, schema validation, throttling, request size limits, and logging.
*   **Restrict Origins**: Ensure origin services only accept traffic from trusted gateways, load balancers, service meshes, or private networks.
*   **Segment Internal APIs**: Keep internal APIs on private networks and expose them externally only through controlled ingress points.
*   **Use mTLS for Service-to-Service Calls**: Authenticate workloads and encrypt east-west traffic in zero-trust or service mesh architectures.
*   **Control Egress**: Limit what API workloads can call, especially metadata services, administrative endpoints, and sensitive data stores.

## 6. Logging, Monitoring, and Detection

*   **Log Security-Relevant Events**: Capture authentication failures, authorization denials, token validation failures, rate-limit events, administrative actions, schema validation failures, and sensitive-data access.
*   **Avoid Logging Secrets**: Redact credentials, tokens, session identifiers, personal data, and payment data from logs.
*   **Correlate Requests**: Use request IDs, user IDs, tenant IDs, workload IDs, and source attributes to support investigations.
*   **Alert on Abuse Patterns**: Monitor spikes in 401/403/429/5xx responses, unusual endpoint sequences, high-cardinality object access, and suspicious geographies or ASNs.
*   **Retain Audit Trails**: Store logs centrally with integrity controls and retention periods aligned to compliance and incident response needs.

## 7. Secure Development and Testing

*   **Threat Model APIs**: Review trust boundaries, data flows, identities, abuse cases, tenant isolation, and dependency risks.
*   **Automate Security Tests**: Add SAST, dependency scanning, IaC scanning, secret scanning, dynamic API testing, and contract tests to CI/CD pipelines.
*   **Test Authorization Explicitly**: Include negative tests for cross-tenant access, privilege escalation, missing scopes, object ID tampering, and mass assignment.
*   **Review Third-Party Integrations**: Limit partner scopes, monitor usage, require secure webhooks, and define incident notification expectations.
*   **Secure Webhooks**: Sign webhook payloads, validate timestamps, prevent replay, and use least-privileged delivery endpoints.

## 8. References

*   [OWASP API Security Top 10](https://owasp.org/API-Security/)
*   [NIST SP 800-204A - Building Secure Microservices-based Applications Using Service-Mesh Architecture](https://csrc.nist.gov/publications/detail/sp/800-204a/final)
*   [AWS - Security Best Practices for Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/security-best-practices.html)
*   [Microsoft - Azure API Management Security Baseline](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/api-management-security-baseline)
*   [Google Cloud - API Security Best Practices](https://cloud.google.com/apis/docs/security-best-practices)
