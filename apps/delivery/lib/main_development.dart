import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery/src/app/app.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/config/environment.dart';
import 'package:delivery/src/config/firebase_options_dev.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/data/services/wallets_availability_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// ignore: unused_import
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Loggy.initLoggy(
      logPrinter: StreamPrinter(
        const PrettyDeveloperPrinter(),
      ),
      logOptions: const LogOptions(
        LogLevel.all,
        stackTraceLevel: LogLevel.error,
      ),
    );
    await dotenv.load(mergeWith: {'ENV': 'dev'});
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    if (Environment.fbEmulatorsEnabled) {
      await FirebaseAuth.instance.useAuthEmulator(Environment.emulatorHost, Environment.authEmuPort);
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
      FirebaseFirestore.instance.useFirestoreEmulator(Environment.emulatorHost, Environment.firestoreEmuPort);
      FirebaseFunctions.instance.useFunctionsEmulator(Environment.emulatorHost, Environment.functionsEmuPort);
      FirebaseStorage.instance.useStorageEmulator(Environment.emulatorHost, Environment.storagesEmuPort);
    }
    await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: Environment.recaptchSiteId);
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    if (kIsWeb) {
      const int megabyte = 1000000;
      SystemChannels.skia.invokeMethod('Skia.setResourceCacheMaxBytes', 512 * megabyte);
      await Future<void>.delayed(Duration.zero);
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
    Stripe.publishableKey = Environment.stripeApiKey;
    Stripe.merchantIdentifier = Environment.applePayMerchantId;
    Stripe.urlScheme = Environment.stripeDeepLink;
    await Stripe.instance.applySettings();
    final walletsAvailable = await WalletsAvailability.check();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            SharedPreferencesService(sharedPreferences),
          ),
          authProvider.overrideWithValue(
            AuthenticationService(firebaseAuth: FirebaseAuth.instance),
          ),
          cloudFunctionsProvider.overrideWithValue(
            CloudFunctionsService(FirebaseFunctions.instanceFor(
              region: FirebaseCallableFunctions.region,
            )),
          ),
          walletsAvailableProvider.overrideWithValue(walletsAvailable),
        ],
        child: const MyApp(),
      ),
    );
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }, (Object error, StackTrace stack) {
    Loggy.detached('errorOutsideZone');
  });
}
