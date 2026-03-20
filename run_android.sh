#!/bin/bash
# ──────────────────────────────────────────────────────
#  ./run_android.sh — Run Flutter app on Android
#
#  Moves large Kabyle translation assets out of assets/
#  so they are NOT bundled into the APK.
#  (On mobile, assets are loaded from Firebase URLs.)
# ──────────────────────────────────────────────────────

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

AUDIO_SRC="assets/data/translate_kabyle_voix_hafs"
IMAGE_SRC="assets/data/translate_kabyle_image_hafs"
BACKUP_DIR="../data-kabyle"

# ── Move audio OUT of the project (if present) ──
if [ -d "$AUDIO_SRC" ]; then
  echo "📦 Moving audio assets out of the project..."
  mkdir -p "$BACKUP_DIR"
  mv "$AUDIO_SRC" "$BACKUP_DIR/translate_kabyle_voix_hafs"
  echo "✅ Audio moved to $BACKUP_DIR/translate_kabyle_voix_hafs"
else
  echo "ℹ️  Audio folder not in assets/ (already moved or not present). OK."
fi

# ── Move images OUT of the project (if present) ──
if [ -d "$IMAGE_SRC" ]; then
  echo "📦 Moving image assets out of the project..."
  mkdir -p "$BACKUP_DIR"
  mv "$IMAGE_SRC" "$BACKUP_DIR/translate_kabyle_image_hafs"
  echo "✅ Images moved to $BACKUP_DIR/translate_kabyle_image_hafs"
else
  echo "ℹ️  Image folder not in assets/ (already moved or not present). OK."
fi

# ── Comment out voix + image paths in pubspec.yaml ──
echo "📝 Commenting out translation asset paths in pubspec.yaml..."
sed -i '' 's|^    - assets/data/translate_kabyle_voix_hafs/|    # - assets/data/translate_kabyle_voix_hafs/|' pubspec.yaml
sed -i '' 's|^    - assets/data/translate_kabyle_image_hafs/|    # - assets/data/translate_kabyle_image_hafs/|' pubspec.yaml
echo "✅ pubspec.yaml updated (translation paths commented out)"

# ── Run on Android ──
echo ""
echo "🚀 Running Flutter on Android..."
flutter run
