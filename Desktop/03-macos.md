# macOS Hardening

This guide covers security hardening for macOS systems (Ventura, Sonoma, Sequoia).

## 1. System Updates

Enable automatic updates to ensure timely security patches.

```bash
# Check for updates
softwareupdate --list

# Install all updates
softwareupdate --install --all

# Enable automatic updates via GUI
System Settings > General > Software Update > Automatic updates > On
```

## 2. FileVault (Disk Encryption)

FileVault encrypts your entire startup volume using XTS-AES-128 encryption.

```bash
# Check FileVault status
fdesetup status

# Enable FileVault (will prompt for password)
sudo fdesetup enable

# Store recovery key securely (not on the same machine!)
fdesetup recovery -enable
```

**System Settings > Privacy & Security > FileVault > Turn On**

## 3. Gatekeeper

Gatekeeper ensures only signed and notarized apps can run.

```bash
# Check Gatekeeper status
spctl --status

# Enable Gatekeeper
sudo spctl --master-enable

# Assess a specific app
spctl --assess --verbose /Applications/AppName.app
```

**System Settings > Privacy & Security > Allow applications downloaded from: App Store and identified developers**

## 4. System Integrity Protection (SIP)

SIP prevents modifications to system files, even by root.

```bash
# Check SIP status
csrutil status

# SIP should be Enabled. Never disable it unless absolutely necessary for development.
# To disable (not recommended):
# csrutil disable  (requires Recovery Mode)
```

## 5. Firewall

```bash
# Check firewall status
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Enable stealth mode (don't respond to probes)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Block all incoming connections (except essential services)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

# Allow specific apps
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/AppName.app
```

**System Settings > Network > Firewall > On**

## 6. Privacy Settings

Review and restrict permissions in **System Settings > Privacy & Security**:

- **Location Services**: Disable for apps that don't need it
- **Contacts/Calendars/Reminders**: Only grant to trusted apps
- **Camera/Microphone**: Only grant when needed
- **Screen Recording**: Only grant to trusted apps
- **Full Disk Access**: Remove unnecessary apps
- **Analytics & Improvements**: Disable sharing with Apple and developers
- **Advertising**: Disable personalized ads

## 7. Safari / Browser Hardening

```bash
# Enable Safari's fraudulent website warning
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Enable Do Not Track
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Block cookies
defaults write com.apple.Safari WebKitAcceptCookies -int 0
defaults write com.apple.SafariCompanion WebKitAcceptCookies -int 0
```

Also in Safari settings:
- Enable **Hide IP address from trackers**
- Enable **Prevent cross-site tracking**
- Set **Block all cookies** or **Allow from current website only**

## 8. Disable Unnecessary Services

```bash
# Disable Bluetooth (if not used)
# System Settings > Bluetooth > Off

# Disable AirDrop (if not used)
# Finder > AirDrop > Allow me to be discovered by: No One

# Disable iCloud (if not used for sensitive data)
# System Settings > Apple ID > iCloud > Sign Out

# Disable remote Apple events
sudo systemsetup -setremoteappleevents off

# Disable remote login (SSH)
sudo systemsetup -setremotelogin off
```

## 9. Screen Lock

```bash
# Set screen lock delay (immediately)
defaults write com.apple.screensaver idleTime -int 0

# Require password immediately after sleep
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
```

**System Settings > Lock Screen > Start Screen Saver when inactive > Immediately**

## 10. XProtect and Malware Removal

macOS includes built-in malware protection. Keep it updated automatically.

```bash
# XProtect updates automatically with macOS updates
# MRT (Malware Removal Tool) also updates automatically

# Check XProtect version
system_profiler SPInstallHistoryDataType | grep -A5 "XProtect"
```

## 11. Secure Keyboard Entry

Prevent keylogging in Terminal:

```bash
# Enable Secure Keyboard Entry in Terminal
# Terminal > Settings > Keyboard > Secure Keyboard Entry
```

## Quick Checklist

- [ ] macOS is up to date
- [ ] FileVault enabled
- [ ] Gatekeeper enabled
- [ ] SIP enabled
- [ ] Firewall enabled (stealth mode on)
- [ ] Privacy permissions reviewed (camera, mic, location)
- [ ] Browser hardened (fraud warning, tracking prevention)
- [ ] Bluetooth disabled (if not used)
- [ ] AirDrop restricted
- [ ] Remote login disabled
- [ ] Screen lock set to immediate
- [ ] Secure Keyboard Entry enabled in Terminal
