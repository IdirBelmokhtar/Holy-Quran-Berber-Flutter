#!/bin/bash

# Build the flutter web app
echo "Building Flutter Web App..."
flutter build web

# The large kabyle translation assets are no longer in pubspec.yaml to save app size.
# Therefore, we need to explicitly copy them to the web build output so Firebase Hosting will serve them.
echo "Copying translation assets to web build directory..."

# Create the target directories if they don't exist
mkdir -p build/web/assets/assets/data/translate_kabyle_image_hafs
mkdir -p build/web/assets/assets/data/translate_kabyle_voix_hafs

# Copy the images
echo "Copying images..."
cp -R assets/data/translate_kabyle_image_hafs/* build/web/assets/assets/data/translate_kabyle_image_hafs/

# Copy the audio
echo "Copying audio..."
cp -R assets/translate_kabyle_voix_hafs/* build/web/assets/assets/translate_kabyle_voix_hafs/

echo "Assets copied successfully. Deploying to Firebase Hosting..."

# Deploy only the hosting part
firebase deploy --only hosting

echo "Deployment complete."
