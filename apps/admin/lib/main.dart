import 'dart:async';
import 'dart:isolate';

import 'package:bottleshop_admin/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  Isolate.current.addErrorListener(
    RawReceivePort(
      (pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      },
    ).sendPort,
  );

  await runZonedGuarded<Future<void>>(
    () async => runApp(ProviderScope(child: MyApp())),
    FirebaseCrashlytics.instance.recordError,
  );
}
