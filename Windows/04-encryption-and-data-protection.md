# 04 - Windows Encryption and Data Protection

Protecting data at rest and in transit is fundamental for Windows Server security. This section covers key encryption technologies and best practices.

## 1. BitLocker Drive Encryption

BitLocker is a full volume encryption feature included with Microsoft Windows versions starting with Windows Vista. It is designed to protect data by providing encryption for entire volumes.

*   **Enable BitLocker**: Enable BitLocker for the entire system drive and any additional data drives that contain sensitive information. This protects data even if the physical drive is removed from the server [4].
*   **Recovery Key Management**: Securely store BitLocker recovery keys. These keys are essential for accessing data if the primary unlock method (e.g., TPM) is unavailable.

## 2. IPsec (Internet Protocol Security)

IPsec is a suite of protocols that provides cryptographic security services for IP networks. It can be used to encrypt network traffic between servers, ensuring data confidentiality and integrity in transit.

*   **Implement IPsec**: Configure IPsec to encrypt network traffic between critical servers, especially for sensitive communications. This helps protect against eavesdropping and tampering [4].

## References

[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
