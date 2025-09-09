#!/bin/bash

# Certificate Import Helper
# Use this to import your new Developer ID Application certificate

echo "🔐 Adventure Realms - Certificate Import Helper"
echo "=============================================="

echo "📋 Current certificates:"
security find-identity -v -p codesigning

echo
echo "📥 To import a new Developer ID Application certificate:"
echo "   1. Download your certificate from Apple Developer portal as .p12"
echo "   2. Place the .p12 file in this directory"
echo "   3. Run: security import certificate.p12 -k ~/Library/Keychains/login.keychain"
echo "   4. Enter the certificate password when prompted"

echo
echo "🔍 Looking for certificate files in current directory..."
if ls *.p12 >/dev/null 2>&1; then
    echo "Found .p12 files:"
    ls -la *.p12
    echo
    read -p "Import the first .p12 file? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        P12_FILE=$(ls *.p12 | head -1)
        echo "Importing $P12_FILE..."
        security import "$P12_FILE" -k ~/Library/Keychains/login.keychain
        echo "✅ Import complete!"
        echo
        echo "📋 Updated certificates:"
        security find-identity -v -p codesigning
    fi
else
    echo "No .p12 files found in current directory"
    echo
    echo "📝 Next steps:"
    echo "   1. Go to Apple Developer portal"
    echo "   2. Create/download Developer ID Application certificate"
    echo "   3. Save as .p12 file in this directory"
    echo "   4. Run this script again"
fi
