# Bottleshop 3 Veze Admin

Admin app for Bottleshop Tri Veze

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/cloudis-dev/bottleshop_admin/Flutter%20CI?logo=Flutter&logoColor=blue)
![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudis-dev/bottleshop_admin/Flutter%20CD/master?label=deployment&logo=Firebase)
![Firebase hosting](https://img.shields.io/static/v1?style=flat&logo=flutter&logoColor=blue&label=platform&message=android%20|%20ios%20|%20pwa&color=lightgrey)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/cloudis-dev/bottleshop_admin?include_prereleases)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
![GitHub](https://img.shields.io/github/license/cloudis-dev/bottleshop_admin?color=blue)

## Setup

### Android

1. Add the `google-services.json` to the `android/app` directory (download from the Firebase or ask the other devs for the file).
2. Add the `key.properties` file to the `android` directory.
The contents of the file are the following:
```
storePassword=cloudis
keyAlias=key
keyPassword=cloudis
storeFile=cloudis.jks
```
3. Run `flutter run` with your android emulator turned on

## Releasing

Release version for Android and iOS using Fastlane.

In the project directory is a `scripts` directory containing 
scripts `android.sh` and `ios.sh` for releasing Android and iOS respectively.

Don't forget to change the version in the `pubspec.yaml`.

Just run the scripts and the releases are done. 
In the ios and android directories are the `fastlane` directories 
containing all the needed instructions for the release.
