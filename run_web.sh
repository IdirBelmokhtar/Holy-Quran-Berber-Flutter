#!/bin/bash
# ──────────────────────────────────────────────────────
#  ./run_web.sh — Run Flutter app on Chrome (web)
#
#  Restores Kabyle translation assets back into assets/
#  so they are available as local assets for the web build.
# ──────────────────────────────────────────────────────

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

AUDIO_SRC="assets/data/translate_kabyle_voix_hafs"
IMAGE_SRC="assets/data/translate_kabyle_image_hafs"
BACKUP_DIR="../data-kabyle"

# ── Restore audio INTO the project (if backup exists) ──
if [ ! -d "$AUDIO_SRC" ] && [ -d "$BACKUP_DIR/translate_kabyle_voix_hafs" ]; then
  echo "📦 Restoring audio assets into the project..."
  mkdir -p "assets/data"
  mv "$BACKUP_DIR/translate_kabyle_voix_hafs" "$AUDIO_SRC"
  echo "✅ Audio restored to $AUDIO_SRC"
elif [ -d "$AUDIO_SRC" ]; then
  echo "ℹ️  Audio folder already in assets/. OK."
else
  echo "⚠️  Audio folder not found in backup ($BACKUP_DIR) or assets/. Continuing anyway..."
fi

# ── Restore images INTO the project (if backup exists) ──
if [ ! -d "$IMAGE_SRC" ] && [ -d "$BACKUP_DIR/translate_kabyle_image_hafs" ]; then
  echo "📦 Restoring image assets into the project..."
  mkdir -p "assets/data"
  mv "$BACKUP_DIR/translate_kabyle_image_hafs" "$IMAGE_SRC"
  echo "✅ Images restored to $IMAGE_SRC"
elif [ -d "$IMAGE_SRC" ]; then
  echo "ℹ️  Image folder already in assets/. OK."
else
  echo "⚠️  Image folder not found in backup ($BACKUP_DIR) or assets/. Continuing anyway..."
fi

# ── Uncomment voix + image paths in pubspec.yaml ──
echo "📝 Uncommenting translation asset paths in pubspec.yaml..."
sed -i '' 's|^    # - assets/data/translate_kabyle_voix_hafs/|    - assets/data/translate_kabyle_voix_hafs/|' pubspec.yaml
sed -i '' 's|^    # - assets/data/translate_kabyle_image_hafs/|    - assets/data/translate_kabyle_image_hafs/|' pubspec.yaml
echo "✅ pubspec.yaml updated (translation paths active)"

# ── Run on Chrome ──
echo ""
echo "🌐 Running Flutter on Chrome..."
flutter run -d chrome
