// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:delivery/firebase_options_production.dart';
import 'package:delivery/src/app/app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LdIPtUfAAAAACEZhCIe8TEdRDcltugVuPqTS8RY',
  );
  runApp(const MyApp());
    FlutterError.onError =
       FirebaseCrashlytics.instance.recordFlutterFatalError;

  }, (error, stack) =>
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),);
}
