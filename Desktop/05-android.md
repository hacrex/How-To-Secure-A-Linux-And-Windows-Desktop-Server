# Android Hardening

This guide covers security hardening for Android devices (Android 10+).

## 1. Screen Lock and Biometrics

Use the strongest screen lock you can manage.

```
Settings > Security > Screen lock

Recommended:
1. PIN (minimum 6 digits) or alphanumeric password
2. Fingerprint as convenience unlock (not primary security)
3. Face unlock as convenience (less secure than fingerprint)

Avoid:
- Pattern (shoulder-surfing risk)
- Swipe (no security)
- 4-digit PIN (too easy to brute-force)
```

## 2. Encryption

Most modern Android devices are encrypted by default. Verify:

```
Settings > Security > Encryption & credentials
- "Encrypted" = your data is protected
- If not encrypted, enable it immediately (Settings > Security > Encrypt phone)
```

**Android uses file-based encryption (FBE)** — your data is encrypted at rest. The lock screen password/PIN is the decryption key.

## 3. Google Play Protect

Google Play Protect scans apps for malware. Ensure it's enabled.

```
Settings > Security > Google Play Protect
- "Scan apps with Play Protect" = On
- "Improve harmful app detection" = On
```

Also: **Settings > Security > Find My Device** = On

## 4. App Permissions

Review and restrict app permissions regularly.

```
Settings > Privacy > Permission manager

Key permissions to restrict:
- Location: "Allow only while using the app" (or deny)
- Camera: "Allow only while using the app" (or deny)
- Microphone: "Allow only while using the app" (or deny)
- Contacts: Deny for apps that don't need them
- SMS: Deny for apps that don't need them
- Phone: Deny for apps that don't need them
- Nearby devices: Deny if not needed
- Files and media: Review each app
```

## 5. Install Unknown Sources

Disable installation of apps from unknown sources.

```
Settings > Apps > Special app access > Install unknown apps

Set ALL apps to "Don't allow" except:
- Your browser (if you need to install APKs intentionally)
- File manager (if needed)

NEVER install apps from:
- Random websites
- APK files from unknown sources
- Third-party app stores (unless trusted)
```

## 6. Browser Security (Chrome)

```
Settings > Privacy and security:
1. Safe Browsing: Enhanced Protection
2. Always use secure connections (HTTPS): On
3. Do Not Track: On
4. Third-party cookies: Block third-party cookies
5. Clear browsing data on exit (or use auto-clear)

Recommended browsers:
- Chrome (with Enhanced Protection)
- Firefox (with Enhanced Tracking Protection Strict)
- Brave (built-in ad/tracker blocking)
```

## 7. Network Security

```
Wi-Fi:
1. Settings > Network & internet > Wi-Fi
2. Use WPA3 or WPA2 (never connect to open networks without VPN)
3. Disable "Auto-connect" for untrusted networks
4. Forget networks you no longer use
5. Disable Wi-Fi scanning for location (Settings > Location > App location permissions > Wi-Fi scanning)

VPN:
- Use a reputable VPN on public Wi-Fi
- Recommended: Mullvad, ProtonVPN, IVPN
- Avoid free VPNs (they sell your data)

Bluetooth:
1. Settings > Connected devices > Bluetooth
2. Turn off when not in use
3. Set to "Not visible to other devices" when on
4. Never pair with unknown devices
```

## 8. Privacy Settings

```
Settings > Privacy:

1. Delete ad ID: Settings > Privacy > Ads > Delete advertising ID
2. Activity controls:
   - Web & App Activity: Off
   - Location History: Off
   - YouTube History: Off
3. Personalization:
   - "Personalized ads" = Off
   - "Personalized search" = Off
4. Permission manager: Review and revoke unnecessary permissions
```

## 9. Auto-Updates

```
Google Play Store:
1. Open Play Store > Profile icon > Settings
2. Network preferences > Auto-update apps
3. Select: "Over Wi-Fi only" or "Don't auto-update" (and update manually)

System updates:
Settings > System > System update
- Check for updates regularly
- Enable automatic updates if available
```

## 10. Additional Hardening

### Disable USB Debugging (when not needed)
```
Settings > Developer options > USB debugging = Off
(If Developer options is not visible, tap "Build number" 7 times in Settings > About phone)
```

### Disable NFC (when not used)
```
Settings > Connected devices > Connection preferences > NFC = Off
```

### Disable Nearby Share (when not used)
```
Settings > Google > Devices & sharing > Nearby Share = Off
```

### Secure Folder (Samsung) / Private Space (Pixel)
```
Use Secure Folder or Private Space to isolate sensitive apps:
- Banking apps
- Password manager
- Email
- Messaging
```

### App Lock
```
Use built-in app lock or a third-party app locker:
- Settings > Security > App lock (some OEMs)
- Or use your password manager's app lock feature
```

## Quick Checklist

- [ ] Screen lock with 6+ digit PIN or alphanumeric password
- [ ] Fingerprint/biometrics configured
- [ ] Device encrypted (verify in Settings)
- [ ] Google Play Protect enabled
- [ ] Find My Device enabled
- [ ] App permissions reviewed and restricted
- [ ] Unknown sources disabled
- [ ] Browser: Safe Browsing enhanced, HTTPS-only
- [ ] Wi-Fi: WPA3/WPA2 only, auto-connect disabled
- [ ] VPN used on public networks
- [ ] Bluetooth off when not in use
- [ ] Ad ID deleted
- [ ] Google activity controls: Off
- [ ] USB debugging off (when not needed)
- [ ] System and app updates current
