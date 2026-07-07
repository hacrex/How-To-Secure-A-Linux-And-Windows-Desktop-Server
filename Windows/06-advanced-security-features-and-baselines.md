# 06 - Windows Advanced Security Features and Baselines

Leveraging advanced security features and established baselines is crucial for achieving a robust security posture in Windows Server environments. This section covers Microsoft-recommended baselines, industry standards, and specific security enhancements.

## 1. Microsoft Security Baselines

Microsoft provides security baselines—groups of Microsoft-recommended configuration settings—that explain their security implications. These baselines are designed to enhance the security of Windows Server deployments.

*   **Utilize Microsoft Security Baselines**: Apply Microsoft-recommended security baselines for Windows Server (e.g., Windows Server 2025). These baselines include hundreds of security settings and can be deployed using tools like OSConfig, PowerShell, Windows Admin Center, or Azure Policy [1] [3].
*   **Test Before Deployment**: Always test security baselines in a non-production environment before applying them to production systems, as they can change default behaviors and introduce compatibility issues [1].

## 2. CIS Benchmarks for Windows Server

The Center for Internet Security (CIS) Benchmarks are consensus-based configuration guidelines developed to help organizations secure their systems. They provide detailed, prescriptive guidance for hardening Windows Server.

*   **Consider CIS Benchmarks**: Apply CIS Benchmarks for Windows Server to achieve a high level of security configuration. These benchmarks are widely recognized and provide a comprehensive set of recommendations [4].

## 3. Secured-Core Server Features

Secured-Core servers are designed to provide advanced protection against sophisticated attacks by integrating hardware, firmware, and operating system security features.

*   **Enable Secured-Core Features**: If your hardware supports it, enable Secured-Core features such as UEFI Memory Access Protection (MAT), Secure Boot, and Signed Boot Chain. These features help protect the boot process and kernel from tampering [1].

## 4. Credential Protection

Protecting credentials from theft and misuse is a top priority for server security.

*   **LSASS/PPL Protection**: Implement measures like Local Security Authority Subsystem Service (LSASS) protection and Protected Process Light (PPL) to safeguard credentials stored in memory. This makes it significantly harder for attackers to dump credentials from memory [1] [3].

## 5. Microsoft Defender Antivirus

Microsoft Defender Antivirus provides robust endpoint protection capabilities built into Windows Server.

*   **Configure Microsoft Defender Antivirus**: Ensure Microsoft Defender Antivirus is properly configured and actively running. This includes:
    *   **Attack Surface Reduction (ASR) Rules**: Implement ASR rules to prevent common attack techniques (e.g., blocking untrusted and executable content) [3].
    *   **Device Control Policies**: Configure device control policies to regulate access to peripheral devices (e.g., USB drives, printers) to prevent data loss and malware infections [3].
    *   **Regular Updates**: Ensure regular updates for security intelligence, engine, and platform to keep protection current against the latest threats [1] [3].

## References

[1] [Deploy Windows Server 2025 security baselines locally with OSConfig](https://learn.microsoft.com/en-us/windows-server/security/osconfig/osconfig-how-to-configure-security-baselines)
[3] [Security baseline for Windows Server 2025, version 2602](https://techcommunity.microsoft.com/blog/microsoft-security-baselines/security-baseline-for-windows-server-2025-version-2602/4496468)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
