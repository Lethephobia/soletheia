#!/usr/bin/env bash
set -euo pipefail

: "${RUNNER_TEMP:?}"
: "${GITHUB_ENV:?}"
case "$RELEASE_PLATFORM" in
  macos)
    APPLE_CERTIFICATE_BASE64="${MACOS_CERTIFICATE_BASE64:-}"
    APPLE_CERTIFICATE_PASSWORD="${MACOS_CERTIFICATE_PASSWORD:-}"
    ;;
  ios)
    APPLE_CERTIFICATE_BASE64="${IOS_CERTIFICATE_BASE64:-}"
    APPLE_CERTIFICATE_PASSWORD="${IOS_CERTIFICATE_PASSWORD:-}"
    ;;
  *) exit 1 ;;
esac
: "${APPLE_CERTIFICATE_BASE64:?Set the platform certificate secret}"
: "${APPLE_CERTIFICATE_PASSWORD:?Set the platform certificate password secret}"
: "${APPLE_TEAM_ID:?Set the APPLE_TEAM_ID variable}"

signing_dir="$RUNNER_TEMP/apple-signing"
mkdir -p "$signing_dir"
chmod 700 "$signing_dir"
umask 077
keychain="$signing_dir/build.keychain-db"
password="$(openssl rand -hex 32)"
printf '%s' "$APPLE_CERTIFICATE_BASE64" | base64 --decode > "$signing_dir/certificate.p12"
security create-keychain -p "$password" "$keychain"
security set-keychain-settings -lut 7200 "$keychain"
security unlock-keychain -p "$password" "$keychain"
security import "$signing_dir/certificate.p12" -P "$APPLE_CERTIFICATE_PASSWORD" -k "$keychain" -t cert -f pkcs12 -T /usr/bin/codesign -T /usr/bin/security
security set-key-partition-list -S apple-tool:,apple:,codesign: -k "$password" "$keychain" > /dev/null
security list-keychains -d user -s "$keychain" "$HOME/Library/Keychains/login.keychain-db"
rm "$signing_dir/certificate.p12"
echo "APPLE_KEYCHAIN=$keychain" >> "$GITHUB_ENV"

case "$RELEASE_PLATFORM" in
  macos)
    : "${MACOS_SIGNING_IDENTITY:?Set the MACOS_SIGNING_IDENTITY variable}"
    : "${MACOS_BUNDLE_ID:?Set the MACOS_BUNDLE_ID variable}"
    : "${APPLE_NOTARY_KEY_BASE64:?Set the App Store Connect team API key secret}"
    : "${APPLE_NOTARY_KEY_ID:?}"
    : "${APPLE_NOTARY_ISSUER_ID:?}"
    [[ "$MACOS_BUNDLE_ID" =~ ^[A-Za-z0-9.-]+$ ]] || { echo 'Invalid MACOS_BUNDLE_ID' >&2; exit 1; }
    cat > macos/Runner/Configs/Signing.generated.xcconfig <<EOF
PRODUCT_BUNDLE_IDENTIFIER = $MACOS_BUNDLE_ID
DEVELOPMENT_TEAM = $APPLE_TEAM_ID
CODE_SIGN_STYLE = Manual
CODE_SIGN_IDENTITY = $MACOS_SIGNING_IDENTITY
ENABLE_HARDENED_RUNTIME = YES
EOF
    options="$signing_dir/ExportOptions.plist"
    plutil -create xml1 "$options"
    /usr/libexec/PlistBuddy -c 'Add :method string developer-id' "$options"
    /usr/libexec/PlistBuddy -c "Add :teamID string $APPLE_TEAM_ID" "$options"
    /usr/libexec/PlistBuddy -c 'Add :signingStyle string manual' "$options"
    /usr/libexec/PlistBuddy -c "Add :signingCertificate string $MACOS_SIGNING_IDENTITY" "$options"
    printf '%s' "$APPLE_NOTARY_KEY_BASE64" | base64 --decode > "$signing_dir/notary.p8"
    xcrun notarytool store-credentials release-notary --keychain "$keychain" \
      --key "$signing_dir/notary.p8" --key-id "$APPLE_NOTARY_KEY_ID" --issuer "$APPLE_NOTARY_ISSUER_ID"
    rm "$signing_dir/notary.p8"
    ;;
  ios)
    : "${IOS_PROFILE_BASE64:?Set the Ad Hoc provisioning profile secret}"
    : "${IOS_BUNDLE_ID:?Set the registered IOS_BUNDLE_ID variable}"
    printf '%s' "$IOS_PROFILE_BASE64" | base64 --decode > "$signing_dir/profile.mobileprovision"
    security cms -D -i "$signing_dir/profile.mobileprovision" > "$signing_dir/profile.plist"
    bash "$GITHUB_WORKSPACE/.github/scripts/configure-ios-signing.sh"
    ;;
  *) exit 1 ;;
esac
