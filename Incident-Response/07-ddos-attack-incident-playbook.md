# 07 - DDoS Attack Incident Playbook

This playbook provides an actionable response workflow for Distributed Denial of Service (DDoS) incidents affecting internet-facing applications, APIs, DNS, network links, load balancers, and supporting infrastructure.

## 1. Incident Overview

**Incident Type**: Distributed Denial of Service (DDoS) Attack  
**Severity**: High to Critical, depending on service impact and duration  
**Primary Objectives**: Preserve availability, protect critical infrastructure, maintain customer communications, and collect evidence for post-incident improvement.

**Common Attack Categories**:

*   **Volumetric Attacks**: UDP floods, amplification attacks, DNS/NTP/SSDP reflection, and other bandwidth-exhaustion attacks.
*   **Protocol Attacks**: SYN floods, fragmented packet attacks, connection table exhaustion, and TLS handshake abuse.
*   **Application-Layer Attacks**: HTTP floods, expensive search or login requests, API abuse, cache-bypass attacks, and bot-driven traffic that mimics legitimate users.
*   **Multi-Vector Attacks**: Campaigns that combine network, transport, and application-layer techniques or change tactics during mitigation.

## 2. Preparation

**People and Process**:

1.  Maintain an on-call escalation path for security, network, application, cloud, communications, legal, and executive stakeholders.
2.  Pre-authorize emergency changes for DDoS controls such as rate limits, WAF rules, geofencing, CDN settings, autoscaling thresholds, and traffic diversion.
3.  Define customer and internal communication templates for degraded service, intermittent availability, and full outage scenarios.
4.  Establish contacts with ISPs, cloud providers, CDN providers, DNS providers, and DDoS scrubbing services before an incident occurs.

**Technology and Evidence Readiness**:

1.  Enable network flow logs, load balancer logs, CDN logs, WAF logs, DNS query logs, application logs, and cloud audit logs.
2.  Deploy layered protections such as CDN caching, DDoS protection, WAF rules, bot management, autoscaling, resilient DNS, and health checks.
3.  Baseline normal traffic by region, ASN, protocol, endpoint, user agent, request method, response code, and request rate.
4.  Maintain runbooks for switching traffic to a scrubbing provider or alternate region.

## 3. Detection and Triage

**Indicators of Attack**:

*   Sudden bandwidth, packet-per-second, request-per-second, or connection-per-second spikes.
*   Increased latency, 5xx errors, TLS negotiation failures, queue depth, thread exhaustion, or database saturation.
*   CDN, WAF, firewall, IDS/IPS, or cloud DDoS alerts.
*   Traffic from unusual ASNs, regions, protocols, user agents, referrers, or request paths.
*   Many requests to expensive endpoints such as login, search, export, checkout, password reset, or unauthenticated API routes.
*   Reports from users, customer support, synthetic monitoring, or external uptime checks.

**Initial Triage Steps**:

1.  Confirm whether the event is a DDoS attack, legitimate traffic surge, deployment issue, dependency outage, or configuration error.
2.  Identify impacted services, user groups, regions, and business functions.
3.  Determine the primary attack layer: network, transport, application, DNS, or API.
4.  Capture the start time, initial symptoms, traffic characteristics, and current mitigation state.
5.  Assign an incident commander and open a dedicated communication channel.

## 4. Analysis

**Questions to Answer**:

*   Which IPs, domains, endpoints, DNS records, ports, or protocols are targeted?
*   Is traffic bypassing the CDN, WAF, load balancer, or API gateway and hitting origin infrastructure directly?
*   Which controls are absorbing traffic, and which controls are saturated?
*   Are legitimate users blocked or degraded by mitigation rules?
*   Are attackers changing vectors after controls are applied?

**Evidence to Collect**:

*   NetFlow/sFlow records, packet samples, firewall counters, and load balancer metrics.
*   CDN, WAF, API gateway, DNS, and origin server logs.
*   Top source IPs, ASNs, geographies, user agents, paths, methods, status codes, and request rates.
*   Screenshots or exports of monitoring dashboards during peak traffic.
*   A timeline of detection, decisions, mitigation changes, communications, and recovery milestones.

## 5. Containment and Mitigation

**Network and Edge Controls**:

1.  Activate or escalate DDoS mitigation with the CDN, cloud provider, ISP, or scrubbing provider.
2.  Ensure DNS records point to protected endpoints and that origin IPs are not directly reachable from the internet.
3.  Apply upstream filtering for clearly malicious protocols, ports, packet sizes, or reflected traffic sources.
4.  Use Anycast, traffic scrubbing, or regional failover if available.
5.  Avoid broad blocks that could unnecessarily deny legitimate users unless service survival requires it.

**Application and API Controls**:

1.  Enable emergency WAF rules for attack signatures, abusive paths, suspicious headers, malformed requests, and known bad automation.
2.  Apply rate limits by IP, account, API key, session, token, endpoint, method, ASN, or geography where appropriate.
3.  Challenge suspicious traffic with CAPTCHA, proof-of-work, bot management, or step-up authentication when available.
4.  Temporarily disable or degrade nonessential expensive features such as exports, searches, reports, or unauthenticated high-cost endpoints.
5.  Increase caching for static and cacheable dynamic content. Confirm attackers cannot force cache misses with random query strings or headers.
6.  Scale stateless tiers only after confirming downstream dependencies such as databases, queues, identity providers, and third-party APIs can handle the load.

**Operational Controls**:

1.  Freeze nonemergency production changes until the incident commander approves them.
2.  Coordinate public status updates through a designated communications owner.
3.  Track every rule change, traffic diversion, escalation, and rollback action in the incident timeline.
4.  Continuously test legitimate user paths from multiple regions while mitigation is active.

## 6. Eradication and Stabilization

1.  Confirm attack traffic has stopped or is fully absorbed by mitigation layers.
2.  Keep heightened monitoring active for at least one business cycle or an agreed observation window.
3.  Gradually remove temporary blocks, challenges, emergency rate limits, and feature degradations.
4.  Validate that DNS, CDN, WAF, load balancer, autoscaling, and origin configurations are in their intended steady state.
5.  Review systems for collateral effects such as exhausted queues, failed jobs, locked accounts, delayed notifications, or corrupted caches.

## 7. Recovery

1.  Confirm core user journeys and API integrations work from representative regions and customer segments.
2.  Re-enable paused jobs, disabled endpoints, and degraded features in a controlled order.
3.  Continue monitoring error rates, latency, saturation, customer reports, and security alerts.
4.  Notify stakeholders when service is stable and explain any remaining customer-facing impact.
5.  Preserve logs, traffic samples, chat transcripts, tickets, and configuration snapshots according to evidence retention policy.

## 8. Post-Incident Activity

**Lessons Learned**:

1.  Conduct a blameless review covering what happened, what worked, what failed, and where detection or response lagged.
2.  Compare actual traffic patterns to baselines and update alert thresholds.
3.  Identify whether any origin IPs, administrative endpoints, DNS records, or API routes were unnecessarily exposed.
4.  Review mitigation accuracy, including false positives that affected legitimate users.
5.  Update architecture, runbooks, escalation contacts, vendor contracts, and tabletop scenarios.

**Hardening Actions**:

*   Move internet-facing services behind DDoS-protected CDN, WAF, load balancer, and API gateway layers.
*   Restrict origin access to trusted edge networks and administrative paths to private networks or strong identity-aware controls.
*   Add endpoint-specific rate limits for expensive API and application functions.
*   Improve caching and graceful degradation patterns for high-traffic scenarios.
*   Test DDoS response procedures through tabletop exercises and controlled simulations.

## 9. Communication Checklist

*   **Internal Teams**: Impacted services, severity, current mitigations, next update time, and decision owner.
*   **Executives**: Business impact, customer impact, estimated recovery posture, and external communications plan.
*   **Customers**: Plain-language status, affected services, workaround guidance, and next update time.
*   **Providers**: Attack telemetry, target IPs/domains, timestamps, requested mitigation, and escalation priority.

## 10. References

*   [NIST SP 800-61 Rev. 2 - Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
*   [CISA - Understanding and Responding to Distributed Denial-of-Service Attacks](https://www.cisa.gov/resources-tools/resources/understanding-and-responding-distributed-denial-service-attacks)
*   [OWASP - Denial of Service](https://owasp.org/www-community/attacks/Denial_of_Service)
*   [Cloudflare - What is a DDoS attack?](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
