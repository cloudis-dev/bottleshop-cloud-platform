import 'dart:async';

import 'package:bottleshop_admin/src/config/firebase_options_prod.dart';
import 'package:bottleshop_admin/src/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: ProductionFirebaseOptions.currentPlatform,
    );
    runApp(ProviderScope(child: MyApp()));
  }, (error, stack) => print(error));
}
