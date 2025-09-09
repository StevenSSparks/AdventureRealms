#!/bin/bash

# Adventure Realms - CLI Tool Installer
# Installs the command-line version alongside the GUI app

set -e

CLI_NAME="adventure-realms"
INSTALL_PATH="/usr/local/bin"

echo "🖥️  Installing Adventure Realms CLI tool..."

if [[ ! -f "publish/osx-arm64/AdventureRealms" ]]; then
    echo "❌ No published executable found"
    echo "📝 Run: ./publish.sh first"
    exit 1
fi

# Install CLI tool
sudo cp "publish/osx-arm64/AdventureRealms" "$INSTALL_PATH/$CLI_NAME"
sudo chmod +x "$INSTALL_PATH/$CLI_NAME"

echo "✅ CLI tool installed!"
echo "📋 Usage:"
echo "   • Type '$CLI_NAME' in Terminal from any directory"
echo "   • Use for classic command-line mode"
echo "   • Example: $CLI_NAME --help"

# Test
if command -v $CLI_NAME >/dev/null 2>&1; then
    echo "🎮 CLI tool is ready to use!"
else
    echo "⚠️  CLI tool installed but not in PATH. You may need to restart Terminal."
fi
