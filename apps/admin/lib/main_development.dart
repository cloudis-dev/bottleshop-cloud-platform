import 'dart:async';

import 'package:bottleshop_admin/src/config/firebase_options_dev.dart';
import 'package:bottleshop_admin/src/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DevelopmentFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instanceFor(
      region: 'asia-south1',
    ).useFunctionsEmulator(
      '127.0.0.1',
      5001,
    );
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

    runApp(ProviderScope(child: MyApp()));
  }, (error, stack) => debugPrint(error.toString()));
}
