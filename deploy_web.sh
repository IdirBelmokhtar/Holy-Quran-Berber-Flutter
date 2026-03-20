#!/bin/bash
# ──────────────────────────────────────────────────────
#  ./deploy_web.sh — Build & deploy Flutter web to Firebase
#
#  1. Restores assets from backup if needed
#  2. Builds with optimizations (tree-shake, PWA caching)
#  3. Copies large assets into build output
#  4. Deploys to Firebase Hosting
# ──────────────────────────────────────────────────────

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

AUDIO_SRC="assets/data/translate_kabyle_voix_hafs"
IMAGE_SRC="assets/data/translate_kabyle_image_hafs"
BACKUP_DIR="../data-kabyle"
BUILD_ASSETS="build/web/assets/assets/data"

# ── Step 1: Restore audio if it was moved out ──
if [ ! -d "$AUDIO_SRC" ] && [ -d "$BACKUP_DIR/translate_kabyle_voix_hafs" ]; then
  echo "📦 Restoring audio assets from backup..."
  mkdir -p "assets/data"
  mv "$BACKUP_DIR/translate_kabyle_voix_hafs" "$AUDIO_SRC"
  echo "✅ Audio restored to $AUDIO_SRC"
elif [ -d "$AUDIO_SRC" ]; then
  echo "ℹ️  Audio folder already in assets/. OK."
else
  echo "⚠️  WARNING: Audio folder not found anywhere! Web audio will not work."
fi

# ── Restore images if they were moved out ──
if [ ! -d "$IMAGE_SRC" ] && [ -d "$BACKUP_DIR/translate_kabyle_image_hafs" ]; then
  echo "📦 Restoring image assets from backup..."
  mkdir -p "assets/data"
  mv "$BACKUP_DIR/translate_kabyle_image_hafs" "$IMAGE_SRC"
  echo "✅ Images restored to $IMAGE_SRC"
elif [ -d "$IMAGE_SRC" ]; then
  echo "ℹ️  Image folder already in assets/. OK."
else
  echo "⚠️  WARNING: Image folder not found anywhere! Web images will not work."
fi

# ── Uncomment voix + image paths in pubspec.yaml ──
echo "📝 Uncommenting translation asset paths in pubspec.yaml..."
sed -i '' 's|^    # - assets/data/translate_kabyle_voix_hafs/|    - assets/data/translate_kabyle_voix_hafs/|' pubspec.yaml
sed -i '' 's|^    # - assets/data/translate_kabyle_image_hafs/|    - assets/data/translate_kabyle_image_hafs/|' pubspec.yaml
echo "✅ pubspec.yaml updated (translation paths active)"

# ── Step 2: Build with optimizations ──
echo ""
echo "🔨 Building Flutter Web (optimized)..."
flutter build web --release --tree-shake-icons --pwa-strategy=offline-first

# ── Step 3: Copy large assets into the build output ──
echo ""
echo "📂 Copying translation assets to web build..."

# Copy images
if [ -d "$IMAGE_SRC" ]; then
  mkdir -p "$BUILD_ASSETS/translate_kabyle_image_hafs"
  cp -R "$IMAGE_SRC"/* "$BUILD_ASSETS/translate_kabyle_image_hafs/"
  echo "  ✅ Images copied"
else
  echo "  ⚠️  Image folder not found, skipping."
fi

# Copy audio
if [ -d "$AUDIO_SRC" ]; then
  mkdir -p "$BUILD_ASSETS/translate_kabyle_voix_hafs"
  cp -R "$AUDIO_SRC"/* "$BUILD_ASSETS/translate_kabyle_voix_hafs/"
  echo "  ✅ Audio copied"
else
  echo "  ⚠️  Audio folder not found, skipping."
fi

# ── Step 4: Deploy to Firebase ──
echo ""
echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo "✅ Deployment complete!"
