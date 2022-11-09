import 'dart:async';

import 'package:bottleshop_admin/src/config/firebase_options_prod.dart';
import 'package:bottleshop_admin/src/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: ProductionFirebaseOptions.currentPlatform,
      );

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      runApp(ProviderScope(child: MyApp()));
    },
    (error, stack) => kIsWeb
        ? print(error)
        : FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}
