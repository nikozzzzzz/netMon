#!/bin/bash
set -e

# Configuration
APP_NAME="netMon"
BUILD_DIR=".build/release"
APP_BUNDLE="$APP_NAME.app"
DMG_NAME="$APP_NAME.dmg"

# Default to empty if not set in environment
DEV_ID="${DEV_ID:-}"
NOTARY_PROFILE="${NOTARY_PROFILE:-}"

echo "🚀 Starting Release Build for $APP_NAME..."

# 1. Build
echo "🛠️  Building..."
swift build -c release

# 2. Create Bundle
echo "📦 Creating App Bundle..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BUILD_DIR/$APP_NAME" "$APP_BUNDLE/Contents/MacOS/"
cp "Info.plist" "$APP_BUNDLE/Contents/"
cp "Sources/icon/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/"
chmod +x "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# 3. Sign
if [ -n "$DEV_ID" ]; then
    echo "🔐 Signing App Bundle..."
    codesign --force --options runtime --deep --sign "$DEV_ID" "$APP_BUNDLE"
else
    echo "⚠️  DEV_ID not set. Skipping signing."
fi

# 4. Package (DMG)
echo "💿 Creating DMG..."
rm -f "$DMG_NAME"
# Create a temporary folder for DMG content
DMG_ROOT="dmg_root"
rm -rf "$DMG_ROOT"
mkdir -p "$DMG_ROOT"

# Copy App
cp -r "$APP_BUNDLE" "$DMG_ROOT/"

# Create /Applications link
ln -s /Applications "$DMG_ROOT/Applications"

# Create DMG from folder
hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_ROOT" -ov -format UDZO "$DMG_NAME"

# Clean up
rm -rf "$DMG_ROOT"

# 5. Notarize
if [ -n "$NOTARY_PROFILE" ]; then
    echo "📤 Submitting for Notarization (this may take a minute)..."
    xcrun notarytool submit "$DMG_NAME" --keychain-profile "$NOTARY_PROFILE" --wait

    # 6. Staple
    echo "📎 Stapling Ticket..."
    xcrun stapler staple "$DMG_NAME"
else
    echo "⚠️  NOTARY_PROFILE not set. Skipping notarization."
fi

echo "✅ Done! DMG is ready:"
echo "   $PWD/$DMG_NAME"
