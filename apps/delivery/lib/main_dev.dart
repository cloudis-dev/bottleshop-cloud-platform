// import 'dart:async';
//
// import 'package:delivery/main.dart';
// import 'package:delivery/src/app.dart';
// import 'package:delivery/src/core/data/res/app_environment.dart';
// import 'package:delivery/src/core/data/services/authentication_service.dart';
// import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
// import 'package:delivery/src/core/data/services/logger.dart';
// import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
// import 'package:delivery/src/core/presentation/providers/core_providers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// Future<void> main() async {
//   initializeLogging();
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   await Firebase.initializeApp();
//
//   await FirebaseAuth.instance
//       .useAuthEmulator('localhost', AppEnvironment.devFirebaseAuthPort);
//   final host = defaultTargetPlatform == TargetPlatform.android
//       ? '10.0.2.2'
//       : 'localhost';
//   FirebaseFirestore.instance
//       .useFirestoreEmulator(host, AppEnvironment.devFirestorePort);
//   FirebaseFunctions.instance.useFunctionsEmulator(
//     'localhost',
//     AppEnvironment.devFunctionsPort,
//   );
//
//   final sharedPreferences = await SharedPreferences.getInstance();
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   runZonedGuarded(
//     () => runApp(
//       ProviderScope(
//         overrides: [
//           authProvider.overrideWithValue(
//               AuthenticationService(firebaseAuth: FirebaseAuth.instance)),
//           sharedPreferencesProvider.overrideWithValue(
//             SharedPreferencesService(sharedPreferences),
//           ),
//           cloudFunctionsProvider.overrideWithValue(
//             CloudFunctionsService(
//               FirebaseFunctions.instance,
//             ),
//           ),
//         ],
//         observers: [
//           ProviderLogger(),
//         ],
//         child: const App(),
//       ),
//     ),
//     FirebaseCrashlytics.instance.recordError,
//   );
// }
