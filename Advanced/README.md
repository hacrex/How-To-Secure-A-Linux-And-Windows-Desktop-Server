# Advanced Security Topics (Cross-OS)

This section covers advanced security topics that are generally applicable to both Linux and Windows server environments. These topics address modern infrastructure challenges and provide a holistic approach to server security.

## 📖 Table of Contents

- [Introduction](#introduction)
- [01 - Container Security](./01-container-security.md)
- [02 - Cloud Server Security](./02-cloud-server-security.md)
- [03 - Security Monitoring and Incident Response](./03-security-monitoring-and-incident-response.md)
- [04 - Kubernetes Security](./04-kubernetes-security.md)
- [05 - Serverless Security](./05-serverless-security.md)
- [06 - Supply Chain Security](./06-supply-chain-security.md)

## Supply Chain Security

Software supply chain attacks target the tools, libraries, and processes used to build software, rather than the software itself. The [Supply Chain Security guide](./06-supply-chain-security.md) covers SBOM generation, dependency verification, container image signing, CI/CD hardening, and the SLSA framework.

## Introduction

As server environments become more complex, encompassing containerized applications and cloud deployments, security considerations extend beyond traditional operating system hardening. This section delves into these advanced areas, providing best practices and considerations for securing your entire infrastructure.

### Zero Trust Architecture

Zero Trust is a security model that assumes no implicit trust, even within the network perimeter. Every access request is verified, authenticated, and authorized regardless of origin [5].

*   **Never Trust, Always Verify**: Authenticate and authorize every request, whether from inside or outside the network.
*   **Least Privilege Access**: Grant only the minimum permissions needed for each task, with time-bound access where possible.
*   **Assume Breach**: Design systems as if an attacker is already present. Segment networks, encrypt all traffic, and monitor continuously.

Key Zero Trust technologies include identity-aware proxies, microsegmentation, mutual TLS, and software-defined perimeters. See [NIST SP 800-207](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf) for the foundational framework.

## References

[5] [NIST SP 800-207 - Zero Trust Architecture](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf)
