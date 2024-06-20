#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Check for version (optional)
flutter --version

# Enable web support
flutter config --enable-web

# Install dependencies and upgrade them
flutter pub get
flutter pub upgrade

# Build the web app
flutter build web