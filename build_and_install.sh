#!/bin/bash
set -e

cd "$(dirname "$0")"

BUILD_DIR="/tmp/StudioQL-build"

echo "Building StudioQL..."
xattr -cr .

xcodebuild -project StudioQL.xcodeproj \
    -target StudioQL \
    -configuration Release \
    DEVELOPMENT_TEAM=RASNRWHHJ7 \
    CODE_SIGN_STYLE=Automatic \
    SYMROOT="$BUILD_DIR" \
    -quiet

echo "Installing to /Applications..."
killall StudioQL 2>/dev/null || true
sleep 1
rm -rf /Applications/StudioQL.app
cp -R "$BUILD_DIR/Release/StudioQL.app" /Applications/

/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister -f /Applications/StudioQL.app

echo "Launching app to register extensions..."
open /Applications/StudioQL.app

echo "Resetting QuickLook..."
qlmanage -r
qlmanage -r cache

echo ""
echo "Done! StudioQL.app installed to /Applications."
echo "You may need to log out/in for QuickLook to pick up the extensions."
