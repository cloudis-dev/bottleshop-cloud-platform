import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

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
      if (!kIsWeb) {
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
