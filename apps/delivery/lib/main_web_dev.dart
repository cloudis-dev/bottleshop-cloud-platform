import 'dart:async';

import 'package:delivery/main.dart';
import 'package:delivery/src/app.dart';
import 'package:delivery/src/config/firebase_options_dev.dart';
import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery/src/core/utils/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  setUrlStrategy(PathUrlStrategy());
  initializeLogging();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DevelopmentFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance
      .useAuthEmulator('localhost', 9099);
   FirebaseFirestore.instance
      .useFirestoreEmulator('localhost', 8080);
  FirebaseFunctions.instanceFor(
  region: 'asia-south1',
).useFunctionsEmulator(
    'localhost',
    5001,
  );
 await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final sharedPreferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
 return runApp(
    ProviderScope(
      overrides: [
        authProvider.overrideWithValue(
          AuthenticationService(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(
              scopes: AppEnvironment.googleSignInScopes,
              clientId: DevelopmentFirebaseOptions.currentClientId,
            ),
          ),
        ),
        sharedPreferencesProvider.overrideWithValue(
          SharedPreferencesService(sharedPreferences),
        ),
        cloudFunctionsProvider.overrideWithValue(
          CloudFunctionsService(
            FirebaseFunctions.instanceFor(
              region: AppEnvironment.cloudFunctionsRegion,
            ),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
