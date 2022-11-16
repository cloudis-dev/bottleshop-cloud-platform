#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

flutter clean
flutter pub get
flutter build apk --split-per-abi --flavor production --target lib/main_production.dart
cd $SCRIPT_DIR/../android || exit
bundle exec fastlane distribute
