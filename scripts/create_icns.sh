#!/bin/bash
set -e

SOURCE_ICON="Sources/icon/icon.png"
ICONSET_DIR="Sources/icon/AppIcon.iconset"
OUTPUT_ICNS="Sources/icon/AppIcon.icns"

if [ ! -f "$SOURCE_ICON" ]; then
    echo "Error: $SOURCE_ICON not found."
    exit 1
fi

mkdir -p "$ICONSET_DIR"

# Generate icons with sips
sips -z 16 16     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16.png"
sips -z 32 32     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16@2x.png"
sips -z 32 32     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32.png"
sips -z 64 64     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32@2x.png"
sips -z 128 128   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128.png"
sips -z 256 256   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128@2x.png"
sips -z 256 256   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256.png"
sips -z 512 512   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256@2x.png"
sips -z 512 512   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512.png"
sips -z 1024 1024 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512@2x.png"

# Convert to icns
iconutil -c icns "$ICONSET_DIR" -o "$OUTPUT_ICNS"

echo "Created $OUTPUT_ICNS"

# Clean up iconset dir
rm -rf "$ICONSET_DIR"
