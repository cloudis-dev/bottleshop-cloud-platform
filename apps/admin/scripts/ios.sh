#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

flutter clean
flutter pub get
flutter build ipa --export-options-plist="$SCRIPT_DIR/ExportOptions.plist" --flavor production --target lib/main_production.dart
cd $SCRIPT_DIR/../ios || exit
bundle exec fastlane distribute

