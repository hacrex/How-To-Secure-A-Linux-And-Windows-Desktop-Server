# LinkedIn Post

---

I just completed a massive overhaul of an open-source security hardening guide — and I'm sharing what I learned.

Over the past few days, I reviewed and improved 70+ guides covering server and desktop security across 7 platforms.

Here's what we fixed:

**Critical bugs found:**
- A .gitignore wrapped in markdown backticks (none of the rules were working)
- Missing LICENSE, missing READMEs, broken CI pipeline
- Deprecated commands that would fail on modern systems

**Content improvements (35 issues resolved):**
- Added SSH hardening with modern ciphers, MACs, and key exchange algorithms
- Replaced deprecated eCryptfs with fscrypt for Linux encryption
- Added PowerShell commands to every Windows guide (was all prose, no action)
- Added 20+ critical Windows Event IDs for security monitoring
- Rewrote the Kubernetes security guide from scratch (was empty)
- Added Credential Guard, JEA, and ASR rules for Windows

**New sections added:**
- Personal Desktop Hardening for 5 platforms (Windows, Linux, macOS, Chrome OS, Android)
- 3 new threat models (Cloud, API, IoT)
- Supply Chain Security guide (SBOM, SLSA, dependency verification)
- Zero Trust Architecture overview
- Legal notification requirements (GDPR 72h, HIPAA 60d, PCI DSS)

The repo now covers:
- 2 server platforms (Linux, Windows)
- 5 desktop/mobile platforms
- 3 cloud providers (AWS, Azure, GCP)
- 14 automation scripts (Ansible + PowerShell)
- 5 threat models with STRIDE analysis
- 7 incident response playbooks

All open-source. All actionable. No fluff.

If you're setting up security for your servers or just want a reference for best practices, check it out:
https://github.com/hacrex/How-To-Secure-A-Linux-And-Windows-Desktop-Server

#CyberSecurity #LinuxSecurity #WindowsSecurity #OpenSource #InfoSec #DevSecOps #CloudSecurity #Hardening #ServerSecurity #DesktopSecurity
