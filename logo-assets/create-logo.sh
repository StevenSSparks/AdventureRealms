#!/bin/bash
# Simple logo creation script using macOS tools

# Create a text-based logo using system tools
echo "Creating Adventure Realms logo..."

# You can use this AppleScript to create a quick logo in TextEdit or Preview
osascript << 'EOF'
tell application "TextEdit"
    activate
    make new document
    set text of document 1 to "🏰 ADVENTURE REALMS 🏰"
    tell document 1
        set font to "Optima-Bold"
        set size to 48
    end tell
end tell
EOF
