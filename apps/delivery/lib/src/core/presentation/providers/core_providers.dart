import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
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

final authProvider =
    Provider<AuthenticationService>(((ref) => throw UnimplementedError()));

final pushNotificationsProvider =
    Provider<PushNotificationService>((_) => PushNotificationService());

final pushNotificationsInitProvider = FutureProvider.autoDispose((ref) async {
  final pushNotifs = ref.watch(pushNotificationsProvider);
  await pushNotifs.init(ref);
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

final currentLanguageProvider = Provider<LanguageMode>(
  (ref) => ref.watch(sharedPreferencesProvider).getAppLanguage(),
);

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

final countriesProvider = FutureProvider<List<CountryModel>>(
  (ref) async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.countriesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => CountryModel.fromMap(e.key, e.value))
        .toList();
  },
);

final unitsProvider = FutureProvider<List<UnitModel>>(
  (ref) async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.unitsCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data)));
    return docsMap.entries
        .map((e) => UnitModel.fromMap(e.key, e.value()))
        .toList();
  },
);
