#!/usr/bin/env bash
set -euo pipefail

# Netlify does not provide Flutter by default, so install the stable SDK here.
if ! command -v flutter >/dev/null 2>&1; then
  FLUTTER_DIR="${HOME}/flutter"
  if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
  fi
  export PATH="${FLUTTER_DIR}/bin:${PATH}"
fi

flutter config --enable-web
flutter create --platforms=web --project-name xiaoshuyuan .
flutter pub get
flutter build web --release --pwa-strategy=none
