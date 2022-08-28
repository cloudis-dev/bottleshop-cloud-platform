import 'dart:async';

import 'package:delivery/src/app.dart';
import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  initializeLogging();

  FirebaseApp? app;
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    app = await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final sharedPreferences = await SharedPreferences.getInstance();
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
    runApp(
      ProviderScope(
        overrides: [
          authProvider.overrideWithValue(
              AuthenticationService(firebaseAuth: FirebaseAuth.instance)),
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
  }, (error, stack) {
    if (app != null) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}

void initializeLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    // ANSI escape codes: https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
    final logBody =
        '[${event.level.name}][${event.loggerName}]: ${event.message}';

    final rest = ((event.error?.toString() ?? '') +
                (event.stackTrace?.toString() ?? ''))
            .trim()
            .isEmpty
        ? ''
        : '\n \u001b[38;5;240m Error: ${event.error} \n StackTrace: ${event.stackTrace}\u001b[0m';

    if (event.level.name == Level.SEVERE.name) {
      if (kIsWeb) {
        FirebaseCrashlytics.instance.recordError(event.error, event.stackTrace);
      }

      if (kDebugMode) {
        debugPrint('\x1B[31;1m $logBody \x1B[0m $rest');
      }
    } else if (event.level.name == Level.WARNING.name) {
      if (kDebugMode) {
        debugPrint('\x1B[33;1m $logBody \x1B[0m $rest');
      }
    } else {
      if (kDebugMode) {
        debugPrint('\x1B[34;1m $logBody \x1B[0m $rest');
      }
    }
  });
}
