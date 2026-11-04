#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_PLATFORM:?RELEASE_PLATFORM is required}"
: "${RELEASE_TAG:?RELEASE_TAG is required}"
: "${RUNNER_TEMP:?RUNNER_TEMP is required}"
signed="${APPLE_SIGNING_ENABLED:-false}"
mkdir -p dist
shopt -s nullglob

case "$RELEASE_PLATFORM" in
  macos)
    if [ "$signed" = true ]; then
      bundles=(build/macos/export/*.app)
    else
      bundles=(build/macos/Build/Products/Release/*.app)
    fi
    [ "${#bundles[@]}" -eq 1 ] || { echo 'Expected exactly one macOS app' >&2; exit 1; }
    bundle="${bundles[0]}"
    if [ "$signed" = true ]; then
      : "${MACOS_SIGNING_IDENTITY:?}"
      : "${APPLE_KEYCHAIN:?}"
      suffix=macos.dmg
    else
      suffix=macos-unnotarized.dmg
    fi
    codesign --verify --deep --strict "$bundle"
    stage="$(mktemp -d "$RUNNER_TEMP/dmg.XXXXXX")"
    trap 'rm -rf "$stage"' EXIT
    ditto "$bundle" "$stage/$(basename "$bundle")"
    ln -s /Applications "$stage/Applications"
    asset="soletheia-${RELEASE_TAG}-${suffix}"
    hdiutil create -volname Soletheia -srcfolder "$stage" -ov -format UDZO "dist/$asset"
    if [ "$signed" = true ]; then
      codesign --sign "$MACOS_SIGNING_IDENTITY" --keychain "$APPLE_KEYCHAIN" --timestamp "dist/$asset"
      xcrun notarytool submit "dist/$asset" --keychain "$APPLE_KEYCHAIN" \
        --keychain-profile release-notary --wait --timeout 30m --output-format json > "$RUNNER_TEMP/notary-result.json"
      status="$(plutil -extract status raw -expect string -o - "$RUNNER_TEMP/notary-result.json")"
      echo "Notarization: $status"
      [ "$status" = Accepted ] || { echo 'Notarization was not accepted' >&2; exit 1; }
      xcrun stapler staple "dist/$asset"
      xcrun stapler validate "dist/$asset"
      spctl --assess --type open --context context:primary-signature --verbose "dist/$asset"
    fi
    ;;
  ios)
    if [ "$signed" = true ]; then
      bundles=(build/ios/ipa/*.ipa)
      [ "${#bundles[@]}" -eq 1 ] || { echo 'Expected exactly one exported IPA' >&2; exit 1; }
      asset="soletheia-${RELEASE_TAG}-ios-adhoc.ipa"
      cp "${bundles[0]}" "dist/$asset"
    else
      bundles=(build/ios/archive/*.xcarchive)
      [ "${#bundles[@]}" -eq 1 ] || { echo 'Expected exactly one iOS archive' >&2; exit 1; }
      asset="soletheia-${RELEASE_TAG}-ios-unsigned.xcarchive.zip"
      ditto -c -k --sequesterRsrc --keepParent "${bundles[0]}" "dist/$asset"
    fi
    ;;
  *) echo "Unsupported platform: $RELEASE_PLATFORM" >&2; exit 1 ;;
esac
(cd dist && shasum -a 256 "$asset" > "$asset.sha256")
