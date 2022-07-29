#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROD_JSON="$SCRIPT_DIR/../android/app/google-services_prod.json"
DEV_JSON="$SCRIPT_DIR/../android/app/google-services_dev.json"
CURRENT_JSON="$SCRIPT_DIR/../android/app/google-services.json"

(
  set -e
  if [ -f "DEV_JSON" ] && [ -f "CURRENT_JSON" ]; then
    echo "JSON files already for PROD, no need for switching"
  else
    mv "$CURRENT_JSON" "$DEV_JSON"
    mv "$PROD_JSON" "$CURRENT_JSON"
    echo "Switched json files to PROD"
  fi

  flutter clean
  flutter pub get
  flutter build apk --split-per-abi
  cd $SCRIPT_DIR/../android || exit
  bundle exec fastlane distribute
)

if [ -f "$DEV_JSON" ] && [ -f "$CURRENT_JSON" ]; then
  mv "$CURRENT_JSON" "$PROD_JSON"
  mv "$DEV_JSON" "$CURRENT_JSON"
  echo "Switched files back to DEV"
fi
