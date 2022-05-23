import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery/src/app/app.dart';
import 'package:delivery/src/config/environment.dart';
import 'package:delivery/src/config/firebase_options_dev.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// ignore: unused_import
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await dotenv.load(mergeWith: {'ENV': 'dev'});
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      if (Environment.fbEmulatorsEnabled) {
        await FirebaseAuth.instance.useAuthEmulator(Environment.emulatorHost, Environment.authEmuPort);
        FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
        FirebaseFirestore.instance.useFirestoreEmulator(Environment.emulatorHost, Environment.firestoreEmuPort);
        FirebaseFunctions.instance.useFunctionsEmulator(Environment.emulatorHost, Environment.functionsEmuPort);
        FirebaseStorage.instance.useStorageEmulator(Environment.emulatorHost, Environment.storagesEmuPort);
      }
      await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: Environment.recaptchSiteId);
      runApp(const MyApp());
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}
