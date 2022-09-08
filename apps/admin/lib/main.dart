import 'dart:async';
import 'dart:html';
import 'dart:isolate';
import 'dart:io' as p;
import 'package:bottleshop_admin/src/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


// void main() async {
//   runZonedGuarded<Future<void>>(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//      await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyATDXyya2cT8D2V1ZFDE83ewlpUFwRZC0U", appId: "1:525277285012:web:79a4cedc090bcaac0ec281", messagingSenderId: "525277285012", projectId: "bottleshop-3-veze-dev-54908"));

//     FlutterError.onError =
//        FirebaseCrashlytics.instance.recordFlutterFatalError;

//     runApp(MyApp());
//   }, (error, stack) =>
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
// }
   

void  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyATDXyya2cT8D2V1ZFDE83ewlpUFwRZC0U", appId: "1:525277285012:web:79a4cedc090bcaac0ec281", messagingSenderId: "525277285012", projectId: "bottleshop-3-veze-dev-54908")); 
    runApp(ProviderScope(child: MyApp()));
}