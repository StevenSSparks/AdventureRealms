# Adventure Realms Installation Guide

## Distribution Packages

### AdventureRealms-Complete-1.0.0-Signed.pkg (Recommended)
- **Signed PKG installer** - Best for enterprise distribution
- **Automatic installation** of both GUI and command-line versions
- **Gatekeeper approved** - No security warnings

### AdventureRealms-Complete-1.0.0.dmg
- **Drag-and-drop installation** - User-friendly for individual users
- **Visual installer** with Applications folder shortcut
- **Contains signed app bundle** with icon

## What Gets Installed

### 1. GUI Application
- **Location**: `/Applications/AdventureRealms.app`
- **Features**: 
  - Beautiful game icon in Applications folder
  - Shows up in Launchpad
  - Native macOS app experience
  - Double-click to launch

### 2. Command-Line Tool
- **Location**: `/usr/local/bin/adventure-realms`
- **Usage**: Open Terminal and type `adventure-realms`
- **Features**:
  - Classic command-line mode
  - Full terminal interface
  - Available system-wide from any directory

## Usage Examples

### GUI Mode (App Bundle)
```bash
# Launch from Applications folder or Launchpad
# Or from command line:
open -a "Adventure Realms"
```

### Command-Line Mode
```bash
# From any directory in Terminal:
adventure-realms

# Run with specific options (if supported):
adventure-realms --classic-mode
adventure-realms --help
```

## Code Signing Details

- **Application**: Signed with Apple Development certificate
- **PKG Installer**: Signed with Developer ID Installer certificate
- **Security**: Hardened runtime enabled with proper entitlements
- **Compatibility**: macOS 11.0+ (Big Sur and later)

## Installation Instructions

### Using PKG (Recommended)
1. Download `AdventureRealms-Complete-1.0.0-Signed.pkg`
2. Double-click to install
3. Follow the installer prompts
4. Launch from Applications folder or use `adventure-realms` in Terminal

### Using DMG
1. Download `AdventureRealms-Complete-1.0.0.dmg`
2. Double-click to mount
3. Drag `AdventureRealms.app` to Applications folder
4. For command-line access, manually copy the executable to `/usr/local/bin/adventure-realms`

Both methods provide the same functionality - choose based on your distribution preferences!
