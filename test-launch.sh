#!/bin/bash

# Test script to check if Adventure Realms launches properly
# This helps distinguish between terminal vs GUI launch issues

echo "Testing Adventure Realms launch..."
echo "================================="

# Test 1: Direct executable
echo "1. Testing direct executable:"
if timeout 2s "/Users/steve/Documents/GitHub/AdventureRealms/publish/osx-arm64/AdventureRealms" 2>/dev/null; then
    echo "   ✅ Direct executable starts"
else
    echo "   ❌ Direct executable fails"
fi

# Test 2: App bundle executable  
echo "2. Testing app bundle executable:"
if timeout 2s "/Users/steve/Documents/GitHub/AdventureRealms/Adventure Realms.app/Contents/MacOS/AdventureRealms" 2>/dev/null; then
    echo "   ✅ App bundle executable starts"
else
    echo "   ❌ App bundle executable fails"
fi

# Test 3: Check environment differences
echo "3. Environment check:"
echo "   DISPLAY: ${DISPLAY:-'not set'}"
echo "   TERM: ${TERM:-'not set'}"
echo "   PATH: ${PATH}"

# Test 4: Check for required libraries
echo "4. Library dependencies:"
otool -L "/Users/steve/Documents/GitHub/AdventureRealms/Adventure Realms.app/Contents/MacOS/AdventureRealms" | head -5

echo "================================="
echo "Test complete!"
