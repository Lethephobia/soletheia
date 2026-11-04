#!/usr/bin/env bash
set -euo pipefail

: "${RUNNER_TEMP:?}"
: "${GITHUB_ENV:?}"
: "${APPLE_TEAM_ID:?}"
: "${IOS_BUNDLE_ID:?}"
export LC_ALL=C
signing_dir="$RUNNER_TEMP/apple-signing"
profile="$signing_dir/profile.plist"
plist=/usr/libexec/PlistBuddy
fail() { echo "$*" >&2; exit 1; }
read_profile() { "$plist" -c "Print :$1" "$profile"; }

[[ "$APPLE_TEAM_ID" =~ ^[A-Z0-9]{10}$ ]] || fail 'Invalid APPLE_TEAM_ID'
[[ "$IOS_BUNDLE_ID" =~ ^[A-Za-z0-9.-]+$ ]] || fail 'Invalid IOS_BUNDLE_ID'
[ "$(read_profile TeamIdentifier:0)" = "$APPLE_TEAM_ID" ] || fail 'Profile team does not match APPLE_TEAM_ID'
if read_profile TeamIdentifier:1 >/dev/null 2>&1; then
  fail 'Expected exactly one profile team'
fi
# Extract the XML date to avoid locale-dependent PlistBuddy date formatting.
expiration="$(plutil -extract ExpirationDate xml1 -o - "$profile" | sed -n 's:.*<date>\(.*\)</date>.*:\1:p')"
expiration_epoch="$(date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$expiration" '+%s')"
[ "$expiration_epoch" -gt "$(date '+%s')" ] || fail 'Provisioning profile has expired'
read_profile ProvisionedDevices:0 >/dev/null 2>&1 || fail 'Expected registered devices in Ad Hoc profile'
[ "$(read_profile ProvisionsAllDevices 2>/dev/null || true)" != true ] || fail 'Enterprise profiles are not supported'
[ "$(read_profile Entitlements:get-task-allow 2>/dev/null || true)" != true ] || fail 'Expected an Ad Hoc distribution profile'
prefix="$(read_profile ApplicationIdentifierPrefix:0)"
[ "$(read_profile Entitlements:application-identifier)" = "$prefix.$IOS_BUNDLE_ID" ] || fail 'Use an explicit Ad Hoc App ID matching IOS_BUNDLE_ID'
uuid="$(read_profile UUID)"
[[ "$uuid" =~ ^[A-Fa-f0-9-]+$ ]] || fail 'Invalid profile UUID'

cat > ios/Flutter/Signing.generated.xcconfig <<EOF
PRODUCT_BUNDLE_IDENTIFIER = $IOS_BUNDLE_ID
DEVELOPMENT_TEAM = $APPLE_TEAM_ID
CODE_SIGN_STYLE = Manual
CODE_SIGN_IDENTITY[sdk=iphoneos*] = Apple Distribution
PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*] = $uuid
EOF

options="$signing_dir/ExportOptions.plist"
plutil -create xml1 "$options"
"$plist" -c 'Add :method string release-testing' "$options"
"$plist" -c "Add :teamID string $APPLE_TEAM_ID" "$options"
"$plist" -c 'Add :signingStyle string manual' "$options"
"$plist" -c 'Add :signingCertificate string Apple Distribution' "$options"
"$plist" -c 'Add :provisioningProfiles dict' "$options"
"$plist" -c "Add :provisioningProfiles:$IOS_BUNDLE_ID string $uuid" "$options"
"$plist" -c 'Add :manageAppVersionAndBuildNumber bool false' "$options"
"$plist" -c 'Add :stripSwiftSymbols bool true' "$options"

profiles="$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"
mkdir -p "$profiles"
destination="$profiles/$uuid.mobileprovision"
# Record the path before installation so the always-running cleanup can remove it.
printf 'IOS_INSTALLED_PROFILE=%s\n' "$destination" >> "$GITHUB_ENV"
cp "$signing_dir/profile.mobileprovision" "$destination"
