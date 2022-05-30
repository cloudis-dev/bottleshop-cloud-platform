import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static bool get crashlyticsEnabled => kIsWeb
      ? false
      : kDebugMode
          ? const bool.fromEnvironment('crashlytics_enabled',
              defaultValue: false)
          : true;
  static bool get analyticsEnabled => kDebugMode
      ? const bool.fromEnvironment('analytics_enabled', defaultValue: false)
      : true;
  static bool get fbEmulatorsEnabled => kDebugMode
      ? const bool.fromEnvironment('emulators_enabled', defaultValue: true)
      : false;
  static String get appleSignInClientId =>
      dotenv.env['APPLE_SIGNIN_CLIENT_ID'] ?? 'n/a';
  static String get applePayMerchantId => dotenv.env['APPLE_PAY_MID'] ?? 'n/a';
  static String get tcsPdfUrl => dotenv.env['TCS_PDF_URL'] ?? 'n/a';
  static String get appleSignInRedirect =>
      dotenv.env['APPLE_SIGN_IN_REDIRECT'] ?? 'n/a';
  static String get stripeApiKey => dotenv.env['STRIPE_API_KEY'] ?? 'n/a';
  static String get androidPayMode => dotenv.env['ANDROID_PAY_MODE'] ?? 'n/a';
  static String get stripeDeepLink =>
      dotenv.env['STRIPE_DEEPLINK_SCHEME'] ?? 'flutterstripe';
  static String get vapidKey => dotenv.env['VAPID_KEY'] ?? 'n/a';
  static String get recaptchSiteId => dotenv.env['WEB_RECAPTCHA'] ?? 'n/a';
  static String get runtimeEnv => kReleaseMode ? 'production' : 'development';
  static String get flavor => dotenv.env['ENV'] ?? 'prod';
  static String get emulatorHost => Environment.fbEmulatorsEnabled
      ? TargetPlatform.android == defaultTargetPlatform
          ? '10.0.22.2'
          : 'localhost'
      : 'localhost';
  static int get functionsEmuPort =>
      int.parse(dotenv.env['FUNCTIONS_PORT'] ?? '5001');
  static int get firestoreEmuPort =>
      int.parse(dotenv.env['FIRESTORE_PORT'] ?? '8080');
  static int get authEmuPort => int.parse(dotenv.env['AUTH_PORT'] ?? '9099');
  static int get storagesEmuPort =>
      int.parse(dotenv.env['STORAGE_PORT'] ?? '9199');
  static int get serverPort =>
      int.parse(dotenv.env['DEV_SERVER_PORT'] ?? '5000');
}
