import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/data/repositories/common_data_repository.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/push_notification_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/data/services/storage_service.dart';
import 'package:delivery/src/core/data/services/stripe_service.dart';
import 'package:delivery/src/core/presentation/providers/crashlytics_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final authProvider =
    Provider<AuthenticationService>(((ref) => throw UnimplementedError()));

final pushNotificationsProvider =
    Provider<PushNotificationService>((_) => PushNotificationService());

final pushNotificationsInitProvider = FutureProvider.autoDispose((ref) async {
  final pushNotifs = ref.watch(pushNotificationsProvider);
  await pushNotifs.init(ref.read);
});

final stripeProvider = Provider<StripeService>((ref) {
  final cloudFunctionsService = ref.watch(cloudFunctionsProvider);
  return StripeService(cloudFunctionsService);
});

final analyticsProvider =
    Provider<FirebaseAnalytics>((_) => FirebaseAnalytics.instance);

final analyticsInitProvider = FutureProvider.autoDispose<void>((ref) async {
  final analytics = ref.watch(analyticsProvider);
  await analytics.setAnalyticsCollectionEnabled(true);
});

final storageProvider = Provider<StorageService>((_) => StorageService());

final downloadUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, path) async {
  final storage = ref.watch(storageProvider);
  return storage.getDownloadURL(path);
});

final defaultProductImage = Provider.autoDispose((ref) {
  final currentMode = ref.watch(currentThemeModeProvider);
  return currentMode == ThemeMode.dark
      ? kDefaultProductPicDark
      : kDefaultProductPic;
});

final sharedPreferencesProvider =
    Provider<SharedPreferencesService>(((ref) => throw UnimplementedError()));

final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeMode = ref.watch(sharedPreferencesProvider).getThemeMode();
  return themeMode;
});

final currentLocaleProvider = Provider<Locale>((ref) {
  final mode = ref.watch(sharedPreferencesProvider).getAppLanguage();
  final systemLanguage =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  debugPrint(
      'current locale: ${Intl.getCurrentLocale().substring(0, 2)} - current system locale: $systemLanguage');
  if (mode == null) {
    return S.delegate.supportedLocales.firstWhere(
      (element) => element.languageCode == systemLanguage,
      orElse: () => S.delegate.supportedLocales.first,
    );
  }
  return S.delegate.supportedLocales.firstWhere(
    (element) => mode.toString().contains(element.languageCode),
    orElse: () => S.delegate.supportedLocales.first,
  );
});

final platformInitializedProvider = FutureProvider.autoDispose((ref) async {
  await Future.wait(
    [
      ref.watch(crashlyticsInitProvider.future),
      ref.watch(analyticsInitProvider.future),
      ref.watch(pushNotificationsInitProvider.future),
    ],
  );
});

final cloudFunctionsProvider =
    Provider<CloudFunctionsService>(((ref) => throw UnimplementedError()));

final commonDataRepositoryProvider =
    ChangeNotifierProvider<CommonDataRepository>(
  (ref) {
    final currentLocale = ref.watch(currentLocaleProvider);
    return CommonDataRepository(currentLocale);
  },
);
