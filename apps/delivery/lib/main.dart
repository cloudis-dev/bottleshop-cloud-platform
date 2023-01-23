// import 'dart:async';
//
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:delivery/src/app.dart';
// import 'package:delivery/src/config/firebase_options_dev.dart';
// import 'package:delivery/src/core/data/res/app_environment.dart';
// import 'package:delivery/src/core/data/services/authentication_service.dart';
// import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
// import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
// import 'package:delivery/src/core/presentation/providers/core_providers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:logging/logging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   initializeLogging();
//
//   FirebaseApp? app;
//   runZonedGuarded<Future<void>>(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     app = await Firebase.initializeApp(
//         options: DevelopmentFirebaseOptions.currentPlatform);
//     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//     await SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     final sharedPreferences = await SharedPreferences.getInstance();
//     LicenseRegistry.addLicense(() async* {
//       final license = await rootBundle.loadString('assets/fonts/OFL.txt');
//       yield LicenseEntryWithLineBreaks(['google_fonts'], license);
//     });
//     runApp(
//       ProviderScope(
//         overrides: [
//           authProvider.overrideWithValue(
//               AuthenticationService(firebaseAuth: FirebaseAuth.instance)),
//           sharedPreferencesProvider.overrideWithValue(
//             SharedPreferencesService(sharedPreferences),
//           ),
//           cloudFunctionsProvider.overrideWithValue(
//             CloudFunctionsService(
//               FirebaseFunctions.instanceFor(
//                 region: AppEnvironment.cloudFunctionsRegion,
//               ),
//             ),
//           ),
//         ],
//         child: const App(),
//       ),
//     );
//   }, (error, stack) {
//     if (app != null) {
//       FirebaseCrashlytics.instance.recordError(error, stack);
//     }
//   });
// }
//
