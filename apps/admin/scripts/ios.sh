#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROD_PLIST="$SCRIPT_DIR/../ios/Runner/prod_GoogleService-Info.plist"
DEV_PLIST="$SCRIPT_DIR/../ios/Runner/dev_GoogleService-Info.plist"
CURRENT_PLIST="$SCRIPT_DIR/../ios/Runner/GoogleService-Info.plist"
#./venv/bin/python -m pbxproj file  --help

(
  set -e
  if [ -f "$DEV_PLIST" ] && [ -f "$CURRENT_PLIST" ]; then
    echo "Plist files already for PROD, no need for switching"
  else
    mv "$CURRENT_PLIST" "$DEV_PLIST"
    mv "$PROD_PLIST" "$CURRENT_PLIST"
    echo "Switched plist files to PROD"
  fi

  flutter clean
  flutter pub get
  flutter build ipa --export-options-plist="$SCRIPT_DIR/ExportOptions.plist"
  cd $SCRIPT_DIR/../ios || exit
  bundle exec fastlane distribute
)

if [ -f "$DEV_PLIST" ] && [ -f "$CURRENT_PLIST" ]; then
  mv "$CURRENT_PLIST" "$PROD_PLIST"
  mv "$DEV_PLIST" "$CURRENT_PLIST"
  echo "Switched files back to DEV"
fi

