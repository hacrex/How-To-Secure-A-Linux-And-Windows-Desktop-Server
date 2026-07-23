# Chrome OS Hardening

Chrome OS is designed with security in mind, but there are still steps to harden your Chromebook for personal use.

## 1. Automatic Updates

Chrome OS updates automatically by default. Verify this is enabled.

```
Settings > About Chrome OS > Check for updates
```

Chrome OS updates include:
- OS security patches
- Browser updates
- Firmware updates (verified boot chain)

## 2. Verified Boot

Chrome OS uses Verified Boot by default. Every time you start your Chromebook, it verifies the OS integrity before booting.

```bash
# Check verified boot status
# This is automatic — you'll see "OS verification is ON" on the dev mode screen
# Never disable OS verification unless you know what you're doing
```

**Do NOT enter Developer Mode** unless you explicitly need it. Developer Mode disables Verified Boot and dm-verity, significantly reducing security.

## 3. User Account Security

```
Settings > Privacy and security

1. Use a strong Google account password
2. Enable 2-Step Verification (mandatory recommendation)
   - Use a hardware security key (Titan, YubiKey) as primary
   - Use Google Authenticator as backup
   - Enable backup codes
3. Set up screen lock with PIN or password
   - Settings > Device > Displays > Lock screen
4. Enable "Require password when waking from sleep"
```

## 4. Browser Security (Chrome)

```
Settings > Privacy and security:

1. Safe Browsing: Enhanced Protection
   - Warns about dangerous sites, downloads, and passwords
   - Checks against Google's real-time database

2. HTTPS-Only Mode: On
   - Forces encrypted connections to all sites

3. Do Not Track: Enabled

4. Third-party cookies: Block third-party cookies
   - Or use "Block all cookies" for maximum privacy

5. Security: 
   - Enable "Enhanced protection" in Safe Browsing
   - Disable "Help improve security on the web"
```

## 5. Extension Management

Extensions are a common attack vector. Minimize what you install.

```
Recommended:
- uBlock Origin (ad/tracker blocking)
- HTTPS Everywhere (now built into Chrome, but verify)
- Bitwarden/1Password (password manager)

Review regularly:
1. chrome://extensions
2. Remove unused extensions
3. Check permissions — remove extensions with excessive access
4. Disable "Developer mode" unless needed
```

## 6. Network Security

```
Wi-Fi:
1. Settings > Network > Wi-Fi > Network name
2. Use WPA3 or WPA2 (never WEP or open networks)
3. Disable "Auto-connect" for untrusted networks
4. Use a VPN on public Wi-Fi

DNS:
1. Settings > Privacy and security > Use secure DNS
2. Select: With Cloudflare (1.1.1.1) or Google (8.8.8.8)
```

## 7. Guest Mode and Supervised Users

```
Guest Mode:
- Settings > Security and Privacy > Enable Guest browsing
- Consider DISABLING guest browsing to prevent unmonitored access
- If enabled, be aware guests can browse without your extensions/history

Supervised Users (for family):
- Settings > People > Manage other people
- Set up supervised accounts with content restrictions
- Use Family Link for parental controls
```

## 8. Privacy Settings

```
Settings > Privacy and security:

1. Web and App Activity: Off (or review regularly)
2. Location History: Off
3. YouTube History: Off (or pause)
4. Ads personalization: Off
5. Chrome sync: Review what data is synced
6. "Help improve Chrome's features and performance": Off
7. "Make searches and browsing better": Off
```

## 9. Physical Security

```
1. Enable screen lock immediately
   - Settings > Device > Displays > Lock screen
   
2. Set "Power button" to sleep (not shut down)
   
3. Enable "On proximity, show lock screen" (if supported)
   
4. Disable USB boot (default on Chrome OS)
   
5. Consider a privacy screen filter for public use
   
6. Enable Find My Device
   - Settings > Security and Privacy > Find My Device > On
```

## 10. Developer Options (Advanced)

If you must use Linux apps (Crostini):

```
1. Settings > Advanced > Developers > Linux development environment
2. Keep the Linux container updated:
   sudo apt update && sudo apt upgrade -y
3. Don't store sensitive data in the Linux container
4. Use the container for development tools only
```

**Never use Developer Mode** (Esc+Refresh+Power) unless you understand the security tradeoffs. It disables:
- Verified Boot
- dm-verity
- Auto-update may be affected

## Quick Checklist

- [ ] Chrome OS up to date
- [ ] Google account has 2FA enabled (hardware key preferred)
- [ ] Screen lock enabled with PIN/password
- [ ] Safe Browsing set to Enhanced Protection
- [ ] HTTPS-Only Mode enabled
- [ ] Extensions minimized and reviewed
- [ ] Guest browsing disabled (or restricted)
- [ ] Privacy settings reviewed (location, history, ads)
- [ ] Find My Device enabled
- [ ] Wi-Fi: WPA3/WPA2 only
- [ ] DNS set to secure provider (Cloudflare/Quad9)
- [ ] Developer Mode NOT enabled
