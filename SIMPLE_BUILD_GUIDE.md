# Adventure Realms - Simple Build Guide

## 🎯 Quick Build Process

### For GUI App with Your Custom Icon:

```bash
# 1. Publish the .NET app
./publish.sh

# 2. Build the macOS app bundle + DMG
./simple-build.sh 1.0.0

# Result: Adventure-Realms-v1.0.0.dmg ready for distribution!
```

### For Command-Line Access:

```bash
# Install CLI tool system-wide
./install-cli.sh

# Now you can use: adventure-realms
```

## 📱 What You Get

### GUI Application
- ✅ **Beautiful App**: `Adventure Realms.app` with your custom logo
- ✅ **Proper Icon**: Uses `logo-assets/AdventureRealms.icns` 
- ✅ **macOS Native**: Shows in Applications folder and Launchpad
- ✅ **Code Signed**: Properly signed for security

### DMG Installer
- ✅ **User-Friendly**: Simple drag-and-drop installation
- ✅ **Professional**: Clean, branded installer
- ✅ **Compact**: Efficient file size

### CLI Tool (Optional)
- ✅ **System-Wide**: Available as `adventure-realms` command
- ✅ **Classic Mode**: Perfect for terminal users
- ✅ **Same Binary**: Identical functionality to GUI

## 📁 File Structure

```
Adventure Realms.app/
├── Contents/
│   ├── Info.plist          # App metadata
│   ├── MacOS/
│   │   └── AdventureRealms  # Your executable
│   └── Resources/
│       └── AdventureRealms.icns  # Your custom icon
```

## 🔧 Customization

### Change App Name
Edit `APP_NAME` in `simple-build.sh`

### Change Icon
Replace `logo-assets/AdventureRealms.icns` with your new icon

### Change Version
```bash
./simple-build.sh 2.0.0  # Any version number
```

## 🎨 Icon Assets

Your logo assets are in `logo-assets/`:
- ✅ `AdventureRealms.icns` - Main icon file (used by build)
- ✅ `AdventureRealms.iconset/` - Source iconset
- ✅ `adventure-realms-logo.png` - Original logo
- ✅ `icon-sizes/` - Various sizes

**Note**: The build script automatically uses `logo-assets/AdventureRealms.icns`

## 🚀 Distribution

1. **Build**: `./simple-build.sh 1.0.0`
2. **Share**: Give users `Adventure-Realms-v1.0.0.dmg`
3. **Install**: Users double-click DMG and drag app to Applications

## ✨ Clean & Simple

This approach focuses on:
- ✅ **Working installation** every time
- ✅ **Your custom branding** (logo-assets)
- ✅ **Simple process** (no complex PKG issues)
- ✅ **Professional result** (proper macOS app)

Perfect for indie game distribution! 🎮
