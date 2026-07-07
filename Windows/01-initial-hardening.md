# 01 - Windows Initial Server Preparation and Updates

Before and immediately after deploying a Windows Server, several foundational steps are crucial for establishing a secure environment:

*   **Inventory Management**: Maintain a detailed inventory of all servers to track their purpose, configuration, and security status [4].
*   **Network Isolation**: Isolate new servers from untrusted networks until they are fully hardened to prevent early exposure to threats [4].
*   **BIOS/Firmware Security**: Secure the BIOS/firmware with strong passwords and configure the boot order to prevent booting from unauthorized media [4].
*   **Prompt Updates**: Immediately apply all available Windows updates, patches, and hotfixes. Enable automatic updates for Microsoft products and consider using centralized update solutions like WSUS or SCCM for multiple servers [2] [4]. Test updates in a non-production environment before deploying to production [2] [4].
*   **OS Version Management**: Ensure Windows Servers are running supported versions and have a plan for regular upgrades to avoid unsupported and unsecure versions [2].

## References

[2] [Windows Server 2025 Security Hardening | IT Blog](https://www.informaticar.net/windows-server-2025-security-hardening/)
[4] [Windows Server security guide: hardening & best practices - Netwrix](https://netwrix.com/en/resources/guides/windows-server-hardening-checklist/)
