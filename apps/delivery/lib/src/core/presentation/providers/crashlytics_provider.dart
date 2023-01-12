import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final crashlyticsInitProvider = FutureProvider.autoDispose<void>(
  (ref) async => !kIsWeb
      ? FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode)
      : Future<void>.value(),
);
