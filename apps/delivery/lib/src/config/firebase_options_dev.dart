// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKDk9aqNBON-PcDuahYV89cDXu3jepWj4',
    appId: '1:525277285012:web:bad81f5d913e78c20ec281',
    messagingSenderId: '525277285012',
    projectId: 'bottleshop-3-veze-dev-54908',
    authDomain: 'bottleshop-3-veze-dev-54908.firebaseapp.com',
    storageBucket: 'bottleshop-3-veze-dev-54908.appspot.com',
    measurementId: 'G-02K3SVS600',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6IPUoa-KnOsnnpEdAc45GTV6_4WzZJ0I',
    appId: '1:525277285012:android:aee210376fa2c0cc0ec281',
    messagingSenderId: '525277285012',
    projectId: 'bottleshop-3-veze-dev-54908',
    storageBucket: 'bottleshop-3-veze-dev-54908.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5Ef7KhzWkJPMhVctK4UXZaHwUIEftB4s',
    appId: '1:525277285012:ios:7f49970dde3780d30ec281',
    messagingSenderId: '525277285012',
    projectId: 'bottleshop-3-veze-dev-54908',
    storageBucket: 'bottleshop-3-veze-dev-54908.appspot.com',
    androidClientId: '525277285012-6qj6rf3lr3o7sdkovn4qoefhhd31686h.apps.googleusercontent.com',
    iosClientId: '525277285012-ls21r8r70es1jbav55094lohidfrtrqr.apps.googleusercontent.com',
    iosBundleId: 'sk.bottleshop3veze.bottleshopdeliveryapp.dev',
  );
}
