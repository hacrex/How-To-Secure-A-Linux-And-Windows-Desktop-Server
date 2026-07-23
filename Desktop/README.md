# Personal Desktop Hardening

This section provides security hardening guides for personal desktop and mobile operating systems. Unlike server hardening (which focuses on network services and remote access), desktop hardening focuses on local user protection, privacy, and defense against everyday threats like malware, phishing, and physical access attacks.

## Table of Contents

- [Windows Desktop](./01-windows-desktop.md)
- [Linux Desktop](./02-linux-desktop.md)
- [macOS](./03-macos.md)
- [Chrome OS](./04-chrome-os.md)
- [Android](./05-android.md)

## Key Differences from Server Hardening

| Aspect | Server | Desktop |
|--------|--------|---------|
| Primary threat | Remote exploitation, lateral movement | Malware, phishing, physical access |
| Network exposure | Always online, public-facing | Intermittent, behind NAT/firewall |
| Users | System administrators | Regular end users |
| Updates | Scheduled maintenance windows | Auto-update preferred |
| Encryption | Disk encryption for data at rest | Full disk + file-based encryption |
| Browser | Minimal or none | Primary attack surface |
| USB/peripherals | Disabled or restricted | Common usage, need control |
| Privacy | Minimal concern | Major concern (telemetry, tracking) |

## Cross-Platform Principles

Regardless of OS, these principles apply to all desktops:

1. **Keep everything updated** — OS, browser, applications, firmware
2. **Use a standard user account** for daily tasks, not admin
3. **Enable full disk encryption** (BitLocker, LUKS, FileVault)
4. **Use a password manager** with unique passwords per site
5. **Enable MFA** on all accounts that support it
6. **Keep firewall enabled** with default-deny inbound
7. **Install reputable antivirus/EDR** and keep it updated
8. **Back up regularly** following the 3-2-1-1-0 rule
9. **Lock your screen** when stepping away (Win+L, Cmd+Shift+Q, Super+L)
10. **Be cautious with USB devices** — never plug in unknown drives
