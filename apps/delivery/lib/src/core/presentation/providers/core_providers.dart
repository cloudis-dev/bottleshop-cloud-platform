import 'package:delivery/l10n/)dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/data/services/storage_service.dart';
import 'package:delivery/src/core/data/services/stripe_service.dart';
import 'package:delivery/src/core/utils/app_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pushNotificationsProvider = Provider<PushNotificationService>((ref) => PushNotificationService(ref));

class PushNotificationService {}

final stripeProvider = Provider<StripeService>((ref) => StripeService(ref.read));

final analyticsProvider = Provider<FirebaseAnalytics>((ref) => FirebaseAnalytics.instance);

final storageProvider = Provider<StorageService>((_) => StorageService());

final downloadUrlProvider = FutureProvider.autoDispose.family<String?, String>((ref, path) async {
  final storage = ref.watch(storageProvider);
  return storage.getDownloadURL(path);
});

final defaultProductImage = Provider.autoDispose<String>((ref) {
  final currentMode = ref.watch(currentThemeModeProvider);
  return currentMode == ThemeMode.dark ? kDefaultProductPicDark : kDefaultProductPic;
});

final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeMode = ref.watch(sharedPreferencesServiceProvider.select((value) => value.getThemeMode()));
  return themeMode;
});

final currentLocaleProvider = Provider<Locale>((ref) {
  final mode = ref.watch(sharedPreferencesServiceProvider.select((value) => value.getAppLanguage()));
  final systemLanguage = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  if (!AppLocalizations.supportedLocales.map((e) => e.languageCode).toList().contains(mode.name)) {
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

final appOrientationProvider = Provider.autoDispose.family<Orientation, BuildContext>((ref, context) {
  final orientation = AppConfig(context).appOrientation();
  return orientation ?? Orientation.portrait;
});
