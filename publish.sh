#!/bin/bash

# Adventure Realms - Publish Script
# Publishes the .NET application for macOS ARM64
# Usage: ./publish.sh [configuration]

set -e

# Configuration
CONFIGURATION=${1:-"Release"}
RUNTIME="osx-arm64"
PROJECT_PATH="AdventureRealms/AdventureRealms.csproj"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Verify project file exists
if [[ ! -f "$PROJECT_PATH" ]]; then
    echo "❌ Project file not found: $PROJECT_PATH"
    exit 1
fi

log_info "Publishing Adventure Realms for macOS..."
log_info "Configuration: $CONFIGURATION"
log_info "Runtime: $RUNTIME"

# Clean previous publish
if [[ -d "publish" ]]; then
    rm -rf publish
    log_info "Cleaned previous publish directory"
fi

# Publish the application
log_info "Running dotnet publish..."
dotnet publish "$PROJECT_PATH" \
    -c "$CONFIGURATION" \
    -r "$RUNTIME" \
    --self-contained \
    -o "publish/$RUNTIME" \
    -p:PublishSingleFile=true \
    -p:IncludeNativeLibrariesForSelfExtract=true \
    -p:EnableCompressionInSingleFile=true \
    -p:PublishTrimmed=false \
    -p:TrimMode=none

if [[ $? -eq 0 ]]; then
    log_success "Application published successfully!"
    echo
    echo "📁 Published to: publish/$RUNTIME/"
    echo "🎮 Executable: publish/$RUNTIME/AdventureRealms"
    echo
    echo "📦 File size: $(ls -lh publish/$RUNTIME/AdventureRealms | awk '{print $5}')"
    echo
    echo "✅ Ready for distribution building!"
    echo "   Next step: ./build-distribution.sh [version]"
else
    echo "❌ Publish failed"
    exit 1
fi
