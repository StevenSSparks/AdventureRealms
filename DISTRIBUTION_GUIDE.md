# Adventure Realms Distribution Guide

## Certificate Types

You now have **Mac App Store** certificates, which means you have two distribution options:

### 1. Mac App Store Distribution (Recommended)
- **Certificate**: Apple Distribution 
- **Advantages**: 
  - ✅ No security warnings for users
  - ✅ Automatic updates through App Store
  - ✅ Built-in payment processing
  - ✅ Discovery through App Store search
- **Disadvantages**:
  - ❌ App Store review process required
  - ❌ Apple takes 30% commission
  - ❌ Must follow App Store guidelines

### 2. Direct Distribution (Requires Developer ID)
- **Current Status**: ❌ Not available (need Developer ID certificate)
- **What's needed**: Developer ID Application certificate ($99/year Apple Developer Program)
- **Advantages**:
  - ✅ No App Store review
  - ✅ Keep 100% of revenue
  - ✅ Full control over distribution
- **Disadvantages**:
  - ❌ Users see security warnings
  - ❌ Manual update system needed

## How to Build

### For Mac App Store Submission:
```bash
./simple-build.sh 1.0.3 appstore
```
- Uses your "Apple Distribution" certificate
- Creates app bundle suitable for App Store submission
- **Important**: Cannot be distributed directly to users

### For Development/Testing:
```bash
./simple-build.sh 1.0.3 direct
```
- Uses your "Apple Development" certificate
- Only works for team members/testers
- Shows security warnings for other users

## Next Steps

### Option A: Submit to Mac App Store
1. Build with: `./simple-build.sh 1.0.3 appstore`
2. Upload to App Store Connect
3. Submit for review
4. Distribute through Mac App Store

### Option B: Get Developer ID for Direct Distribution
1. Upgrade to Apple Developer Program ($99/year)
2. Create Developer ID Application certificate
3. Build with: `./simple-build.sh 1.0.3 direct`
4. Distribute DMG directly to users

## Current Certificate Status

Run this to see your certificates:
```bash
security find-identity -v
```

You should see:
- ✅ **Apple Distribution** - For Mac App Store
- ✅ **3rd Party Mac Developer Installer** - For Mac App Store PKG
- ❌ **Developer ID Application** - For direct distribution (not present)

## Recommendation

Since you have Mac App Store certificates, I recommend:

1. **Try the Mac App Store first** - It provides the best user experience
2. **Keep the current build system** - It automatically detects and uses the right certificate
3. **Consider Developer ID later** - If you want direct distribution without App Store review

The Adventure Realms app is already properly structured and signed for Mac App Store submission!
