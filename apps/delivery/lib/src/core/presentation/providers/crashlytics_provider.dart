import 'package:delivery/src/core/presentation/providers/crashlytics_stub.dart'
    if (dart.library.js) 'crashlytics_stub.dart'
    if (dart.library.io) 'crashlytics.dart' as impl;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final crashlyticsInitProvider = FutureProvider.autoDispose<void>((ref) async {
  try {
    await impl.configureCrashlyticsInstance();
  } catch (_) {
    //
  }
});
