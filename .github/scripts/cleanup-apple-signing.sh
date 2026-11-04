#!/usr/bin/env bash
set -euo pipefail

if [ -f "$RUNNER_TEMP/apple-signing/build.keychain-db" ]; then
  security delete-keychain "$RUNNER_TEMP/apple-signing/build.keychain-db"
fi
if [ -n "${IOS_INSTALLED_PROFILE:-}" ]; then
  rm -f "$IOS_INSTALLED_PROFILE"
fi
rm -rf "$RUNNER_TEMP/apple-signing"

case "${RELEASE_PLATFORM:-}" in
  macos) rm -f macos/Runner/Configs/Signing.generated.xcconfig ;;
  ios) rm -f ios/Flutter/Signing.generated.xcconfig ;;
esac
