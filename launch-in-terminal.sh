#!/bin/bash

# Adventure Realms Terminal Launcher
# This script opens Adventure Realms in a new Terminal window

# Get the directory of this script (the app bundle)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"
EXECUTABLE="$APP_DIR/Contents/MacOS/AdventureRealms"

# Launch in Terminal
osascript -e "tell application \"Terminal\" to do script \"'$EXECUTABLE'; exit\""
