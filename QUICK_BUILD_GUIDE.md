# Quick Build Example

## For a new release:

```bash
# 1. Update version in your code if needed
# 2. Publish the application
./publish.sh

# 3. Build signed distribution packages  
./build-distribution.sh 1.0.2

# That's it! You now have:
# - AdventureRealms-Complete-1.0.2-Signed.pkg (Professional installer)
# - AdventureRealms-Complete-1.0.2.dmg (User-friendly installer)
```

## For development builds:

```bash
# Debug build with default version
./publish.sh Debug
./build-distribution.sh 1.0.0-dev
```

## Before release checklist:

- [ ] Update version numbers in project files
- [ ] Test the application locally  
- [ ] Run `./publish.sh` successfully
- [ ] Run `./build-distribution.sh [version]` successfully
- [ ] Verify PKG signature with `pkgutil --check-signature`
- [ ] Test install on clean macOS system
- [ ] Verify both GUI and CLI modes work

🎯 **The scripts handle all the complex signing and packaging automatically!**
