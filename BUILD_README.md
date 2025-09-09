# Adventure Realms - Build & Distribution Scripts

This directory contains automated scripts for building and packaging Adventure Realms for macOS distribution.

## Quick Start

For a complete build and distribution package:

```bash
# 1. Publish the .NET application
./publish.sh

# 2. Build signed distribution packages
./build-distribution.sh 1.0.0
```

## Scripts Overview

### 📦 `publish.sh` - .NET Application Publisher
**Purpose**: Publishes the .NET application for macOS ARM64

**Usage**:
```bash
./publish.sh [configuration]
```

**Examples**:
```bash
./publish.sh                # Release build (default)
./publish.sh Debug         # Debug build
```

**Output**: Creates `publish/osx-arm64/AdventureRealms` executable

### 🔐 `build-distribution.sh` - Complete Distribution Builder
**Purpose**: Creates signed PKG and DMG installers with both GUI and CLI versions

**Usage**:
```bash
./build-distribution.sh [version]
```

**Examples**:
```bash
./build-distribution.sh              # Version 1.0.0 (default)
./build-distribution.sh 1.2.0       # Version 1.2.0
./build-distribution.sh 2.0.0-beta  # Beta version
```

**Output**: 
- `AdventureRealms-Complete-[VERSION]-Signed.pkg` (Signed installer)
- `AdventureRealms-Complete-[VERSION].dmg` (Drag-and-drop installer)

## What Gets Built

### GUI Application (`AdventureRealms.app`)
- ✅ Native macOS app bundle
- ✅ Beautiful game icon
- ✅ Shows in Applications folder and Launchpad  
- ✅ Properly signed with Apple Development certificate
- ✅ Hardened runtime enabled

### Command-Line Tool (`adventure-realms`)
- ✅ Installed to `/usr/local/bin/adventure-realms`
- ✅ Available system-wide from Terminal
- ✅ Same executable as GUI, but accessible via CLI
- ✅ Perfect for classic/headless mode

### Distribution Packages
- ✅ **PKG Installer**: Professional installer with Developer ID signature
- ✅ **DMG Image**: User-friendly drag-and-drop installation
- ✅ **Gatekeeper Compatible**: No security warnings on installation
- ✅ **Dual Installation**: Both GUI and CLI installed automatically

## Prerequisites

### Development Environment
- macOS development machine
- Xcode Command Line Tools installed
- .NET SDK installed
- Valid Apple Developer certificates

### Required Certificates
- **Apple Development Certificate**: For signing applications
  - Currently: `Apple Development: Steven Scott Sparks (GLGR4ZA4QR)`
- **Developer ID Installer Certificate**: For signing installers
  - Currently: `Developer ID Installer: Steven Scott Sparks (DF8R99VKQL)`

### Required Files
- `entitlements.plist` - Security entitlements for hardened runtime
- Project must be published to `publish/osx-arm64/AdventureRealms`

## Build Process Details

### Step 1: Application Publishing
```bash
# The publish.sh script runs:
dotnet publish AdventureRealms/AdventureRealms.csproj \
    -c Release \
    -r osx-arm64 \
    --self-contained \
    -o publish/osx-arm64 \
    -p:PublishSingleFile=true
```

### Step 2: Code Signing
```bash
# Signs the executable with development certificate:
codesign --force --sign "Apple Development: Steven Scott Sparks (GLGR4ZA4QR)" \
         --entitlements entitlements.plist \
         --options runtime \
         publish/osx-arm64/AdventureRealms
```

### Step 3: App Bundle Creation
- Creates proper `AdventureRealms.app` structure
- Copies icon file (if available)
- Generates `Info.plist` with correct bundle information
- Signs the complete app bundle

### Step 4: PKG Installer Creation
```bash
# Creates unsigned PKG:
pkgbuild --root [app_structure] \
         --identifier com.stevenssparks.adventurerealms.complete \
         --version [VERSION] \
         --install-location / \
         AdventureRealms-[VERSION].pkg

# Signs PKG installer:
productsign --sign "Developer ID Installer: Steven Scott Sparks (DF8R99VKQL)" \
            AdventureRealms-[VERSION].pkg \
            AdventureRealms-Complete-[VERSION]-Signed.pkg
```

### Step 5: DMG Creation
```bash
# Creates compressed DMG:
hdiutil create -volname "Adventure Realms" \
               -srcfolder [dmg_contents] \
               -ov -format UDZO \
               AdventureRealms-Complete-[VERSION].dmg
```

## Certificate Management

### Checking Certificate Status
```bash
# List available certificates:
security find-identity -v -p codesigning

# Verify specific certificate:
security find-certificate -c "Apple Development: Steven Scott Sparks (GLGR4ZA4QR)" -p
```

### Certificate Issues
If you encounter certificate chain issues:

1. **Re-download certificates** from Apple Developer portal
2. **Import certificates** using Keychain Access or `security` command
3. **Verify certificate chain** includes Apple intermediate certificates
4. **Check certificate expiration** dates

## Troubleshooting

### Common Issues

**❌ "unable to build chain to self-signed root"**
- Certificate chain incomplete
- Re-import Apple intermediate certificates
- Check certificate validity dates

**❌ "publish/osx-arm64/AdventureRealms not found"**
- Run `./publish.sh` first
- Check .NET SDK installation
- Verify project builds successfully

**❌ "errSecInternalComponent"** 
- Keychain access issues
- Try unlocking login keychain
- Restart Terminal/system

**❌ PKG/DMG creation fails**
- Check disk space
- Verify write permissions
- Clean up previous build artifacts

### Verification Commands

```bash
# Verify executable signature:
codesign --verify --verbose=2 publish/osx-arm64/AdventureRealms

# Verify app bundle:
codesign --verify --verbose=2 AdventureRealms.app

# Verify PKG signature:
pkgutil --check-signature AdventureRealms-Complete-*-Signed.pkg

# Test installation contents:
pkgutil --payload-files AdventureRealms-Complete-*-Signed.pkg
```

## Version Management

The build script automatically:
- Updates `CFBundleVersion` and `CFBundleShortVersionString` in `Info.plist`
- Names output files with version number
- Maintains consistent versioning across all components

## Distribution

### For Internal/Development Distribution
- Use the **PKG installer** for enterprise/team distribution
- Use the **DMG** for individual user distribution

### For Public Distribution
- Consider additional notarization with Apple (requires Developer ID Application certificate)
- May require Mac App Store distribution for wider reach

## Maintenance

### Updating Certificates
When certificates expire or change:

1. Update certificate names in `build-distribution.sh`:
   ```bash
   DEVELOPER_CERT="Apple Development: [NEW_NAME]"
   INSTALLER_CERT="Developer ID Installer: [NEW_NAME]"
   ```

2. Test build process with new certificates

### Updating Dependencies
- Monitor .NET version compatibility
- Update `LSMinimumSystemVersion` in `Info.plist` if needed
- Test on target macOS versions

## Security Notes

- All builds use **hardened runtime** for enhanced security
- **Entitlements** are properly configured for .NET/Terminal.Gui requirements
- **Signed timestamping** ensures long-term signature validity
- **Certificate chain validation** prevents tampering

---

🎮 **Happy building!** These scripts automate the entire distribution process, from .NET publish to signed, ready-to-distribute packages.
