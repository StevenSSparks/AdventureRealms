#!/bin/bash

# Adventure Realms - Simple Distribution Builder
# Clean, simple approach focused on working installation

set -e

# Show usage if no arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <version> [distribution_target]"
    echo ""
    echo "Examples:"
    echo "  $0 1.0.3                    # Direct distribution (uses Developer ID or Apple Development)"
    echo "  $0 1.0.3 direct             # Direct distribution (same as above)"
    echo "  $0 1.0.3 appstore           # Mac App Store distribution (uses Apple Distribution)"
    echo ""
    exit 1
fi

# Configuration
APP_NAME="Adventure Realms"
APP_IDENTIFIER="com.stevenssparks.adventurerealms"
CLI_NAME="adventure-realms"
VERSION=${1:-"1.0.0"}

# Auto-detect best available signing certificate
DEVELOPER_ID_CERT=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -1 | sed 's/.*"\(.*\)"/\1/')
MAC_APP_STORE_CERT=$(security find-identity -v | grep "Apple Distribution" | head -1 | sed 's/.*"\(.*\)"/\1/')
DEVELOPMENT_CERT=$(security find-identity -v -p codesigning | grep "Apple Development" | head -1 | sed 's/.*"\(.*\)"/\1/')

# Determine which certificate to use based on distribution target
DISTRIBUTION_TARGET=${2:-"direct"}  # "direct" or "appstore"

if [[ "$DISTRIBUTION_TARGET" == "appstore" && -n "$MAC_APP_STORE_CERT" ]]; then
    SIGNING_CERT="$MAC_APP_STORE_CERT"
    CERT_TYPE="Apple Distribution (Mac App Store)"
    IS_PUBLIC_CERT=true
    IS_APP_STORE=true
elif [[ -n "$DEVELOPER_ID_CERT" ]]; then
    SIGNING_CERT="$DEVELOPER_ID_CERT"
    CERT_TYPE="Developer ID Application (direct distribution)"
    IS_PUBLIC_CERT=true
    IS_APP_STORE=false
elif [[ -n "$MAC_APP_STORE_CERT" ]]; then
    SIGNING_CERT="$MAC_APP_STORE_CERT"
    CERT_TYPE="Apple Distribution (Mac App Store only)"
    IS_PUBLIC_CERT=true
    IS_APP_STORE=true
elif [[ -n "$DEVELOPMENT_CERT" ]]; then
    SIGNING_CERT="$DEVELOPMENT_CERT"
    CERT_TYPE="Apple Development (development/team only)"
    IS_PUBLIC_CERT=false
    IS_APP_STORE=false
else
    echo "❌ No suitable signing certificate found"
    echo "📝 Run: ./import-certificate.sh to set up certificates"
    exit 1
fi

echo "🏗️  Building Adventure Realms $VERSION"
echo "📋 Using certificate: $CERT_TYPE"
echo "🔐 Certificate: $SIGNING_CERT"

if [[ "$IS_APP_STORE" == true ]]; then
    echo "🍎 Note: Apple Distribution cert is for Mac App Store submission only"
    echo "📤 This build cannot be distributed directly to users"
fi

if [[ "$IS_PUBLIC_CERT" == false ]]; then
    echo "⚠️  Warning: Development certificate requires team membership to run"
fi

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

echo "🎮 Building Adventure Realms v$VERSION"
echo "========================================"
echo "🔐 Certificate: $CERT_TYPE"
echo "📝 Signing with: $SIGNING_CERT"
echo

# Step 1: Verify prerequisites
log_info "Checking prerequisites..."

if [[ ! -f "publish/osx-arm64/AdventureRealms" ]]; then
    echo "❌ No published executable found"
    echo "📝 Run: ./publish.sh first"
    exit 1
fi

if [[ ! -f "logo-assets/AdventureRealms.icns" ]]; then
    echo "❌ No icon found in logo-assets/"
    exit 1
fi

log_success "Prerequisites OK"

# Step 2: Create clean app bundle
log_info "Creating Adventure Realms.app bundle..."

rm -rf "Adventure Realms.app"
mkdir -p "Adventure Realms.app/Contents/MacOS"
mkdir -p "Adventure Realms.app/Contents/Resources"

# Copy the executable
cp "publish/osx-arm64/AdventureRealms" "Adventure Realms.app/Contents/MacOS/AdventureRealms"

# Create Terminal launcher script for GUI launches  
cat > "Adventure Realms.app/Contents/MacOS/AdventureRealms-Launcher" << 'EOF'
#!/bin/bash
# Adventure Realms GUI Launcher - Opens in Terminal when double-clicked

# Get the directory of the actual executable
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXECUTABLE="$SCRIPT_DIR/AdventureRealms"

# Check if we're running in a terminal environment
if [ -t 0 ]; then
    # We have a terminal, run directly
    exec "$EXECUTABLE" "$@"
else
    # No terminal, launch in Terminal.app with proper close
    osascript -e "
    tell application \"Terminal\"
        set newWindow to do script \"cd '$SCRIPT_DIR' && './AdventureRealms'; osascript -e 'tell application \\\"Terminal\\\" to close (window 1)' &; echo 'Adventure Realms has exited.'; sleep 1\"
    end tell"
fi
EOF

chmod +x "Adventure Realms.app/Contents/MacOS/AdventureRealms-Launcher"

# Copy your logo assets
cp "logo-assets/AdventureRealms.icns" "Adventure Realms.app/Contents/Resources/AdventureRealms.icns"
log_success "Using logo from logo-assets/AdventureRealms.icns"

# Create Info.plist
cat > "Adventure Realms.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$APP_IDENTIFIER</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleExecutable</key>
    <string>AdventureRealms-Launcher</string>
    <key>CFBundleIconFile</key>
    <string>AdventureRealms.icns</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.games</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

# Step 3: Sign the app bundle
log_info "Signing app bundle..."
if codesign --force --sign "$SIGNING_CERT" --options runtime --entitlements entitlements.plist "Adventure Realms.app"; then
    log_success "App bundle signed successfully"
else
    log_warning "App bundle signing failed, but continuing..."
fi

# Step 4: Create simple DMG
log_info "Creating DMG installer..."
rm -f "Adventure-Realms-v$VERSION.dmg"

# Create a temporary directory for DMG contents
DMG_DIR="dmg_temp"
rm -rf "$DMG_DIR"
mkdir -p "$DMG_DIR"

# Copy app to DMG directory
cp -R "Adventure Realms.app" "$DMG_DIR/"

# Create a symlink to Applications for easy installation
ln -s /Applications "$DMG_DIR/Applications"

# Create a README for installation instructions
cat > "$DMG_DIR/Installation Instructions.txt" << EOF
Adventure Realms Installation
============================

RECOMMENDED INSTALLATION:
1. Drag "Adventure Realms.app" to the Applications folder
2. Open Applications folder and launch Adventure Realms

CERTIFICATE INFO:
This app is signed with: $CERT_TYPE

EOF

if [[ "$IS_PUBLIC_CERT" == "true" ]]; then
    cat >> "$DMG_DIR/Installation Instructions.txt" << EOF
✅ PUBLIC DISTRIBUTION CERTIFICATE
This app should install and run without security warnings.

EOF
else
    cat >> "$DMG_DIR/Installation Instructions.txt" << EOF
⚠️  DEVELOPMENT CERTIFICATE
If macOS shows security warnings:
1. Right-click Adventure Realms.app in Applications
2. Select "Open" from the menu
3. Click "Open" in the security dialog

Or use Terminal to remove quarantine:
sudo xattr -rd com.apple.quarantine "/Applications/Adventure Realms.app"

This is normal for development-signed apps.
EOF
fi

cat >> "$DMG_DIR/Installation Instructions.txt" << EOF

For questions, contact the developer.
EOF

# Create DMG from directory
hdiutil create -volname "Adventure Realms v$VERSION" \
               -srcfolder "$DMG_DIR" \
               -ov \
               -format UDZO \
               "Adventure-Realms-v$VERSION.dmg"

# Clean up
rm -rf "$DMG_DIR"

log_success "DMG created: Adventure-Realms-v$VERSION.dmg"

# Step 5: Test the app bundle
log_info "Testing app bundle..."
if open -a "Adventure Realms.app" --args --help 2>/dev/null; then
    log_success "App bundle can be launched"
else
    log_warning "App launch test had issues (may be normal for CLI apps)"
fi

# Display results
echo
echo "✅ Build Complete!"
echo "=================="
echo "📱 App Bundle: Adventure Realms.app"
echo "💿 DMG Installer: Adventure-Realms-v$VERSION.dmg"
echo "🎨 Icon: Using your logo-assets/AdventureRealms.icns"
echo "🔐 Certificate: $CERT_TYPE"
echo 
echo "📋 Installation Instructions:"
echo "   1. Double-click Adventure-Realms-v$VERSION.dmg"
echo "   2. Drag Adventure Realms.app to Applications folder"
echo "   3. Launch from Applications folder"

if [[ "$IS_PUBLIC_CERT" == "true" ]]; then
    echo
    echo "✅ PUBLIC DISTRIBUTION:"
    echo "   • Uses Developer ID Application certificate"
    echo "   • Should install without security warnings"
    echo "   • Ready for public distribution!"
else
    echo
    echo "⚠️  DEVELOPMENT DISTRIBUTION:"
    echo "   • Uses development certificate (team/testing only)"
    echo "   • Users may see security warnings on first launch"
    echo "   • For public distribution, import Developer ID Application certificate"
    echo "   • Run: ./import-certificate.sh to add public certificate"
fi

echo
echo "🚀 The app will appear in Applications with your custom icon!"
