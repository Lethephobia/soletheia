#!/usr/bin/env bash
set -euo pipefail

: "${FLUTTER_VERSION:?FLUTTER_VERSION is required}"
: "${RUNNER_TEMP:?RUNNER_TEMP is required}"
: "${GITHUB_PATH:?GITHUB_PATH is required}"
: "${GITHUB_ENV:?GITHUB_ENV is required}"

flutter_sdk="$RUNNER_TEMP/flutter-sdk"
if [ ! -d "$flutter_sdk/.git" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$flutter_sdk"
fi

test "$(git -C "$flutter_sdk" describe --tags --exact-match HEAD)" = "$FLUTTER_VERSION"
echo "$flutter_sdk/bin" >> "$GITHUB_PATH"
echo "FLUTTER_ROOT=$flutter_sdk" >> "$GITHUB_ENV"
"$flutter_sdk/bin/flutter" config --no-analytics
"$flutter_sdk/bin/flutter" --version
