#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/.netlify-build"
PROJECT="$WORK/xiaoshuyuan_flutter"
BACKUP="$WORK/source-backup"

rm -rf "$WORK" "$ROOT/site"
mkdir -p "$WORK"
unzip -q "$ROOT/xiaoshuyuan_flutter_web_source.zip" -d "$WORK"

if [ ! -f "$PROJECT/lib/main.dart" ] || [ ! -f "$PROJECT/pubspec.yaml" ]; then
  echo "ERROR: Flutter source archive is incomplete."
  exit 1
fi

# Preserve the real app source. `flutter create` generates a demo main.dart,
# so restore the original app files immediately after generating web scaffolding.
mkdir -p "$BACKUP"
cp -a "$PROJECT/lib" "$BACKUP/lib"
cp -a "$PROJECT/pubspec.yaml" "$BACKUP/pubspec.yaml"

if ! command -v flutter >/dev/null 2>&1; then
  FLUTTER_DIR="${HOME}/flutter"
  if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

cd "$PROJECT"
flutter config --enable-web
flutter create --platforms=web --project-name xiaoshuyuan .

rm -rf "$PROJECT/lib"
cp -a "$BACKUP/lib" "$PROJECT/lib"
cp -a "$BACKUP/pubspec.yaml" "$PROJECT/pubspec.yaml"

if ! grep -q "const bg = Color(0xFF101014)" "$PROJECT/lib/main.dart"; then
  echo "ERROR: Original Xiaoshuyuan app entry was not restored."
  exit 1
fi

flutter pub get
flutter build web --release --pwa-strategy=none --base-href /
mkdir -p "$ROOT/site"
cp -a build/web/. "$ROOT/site/"
