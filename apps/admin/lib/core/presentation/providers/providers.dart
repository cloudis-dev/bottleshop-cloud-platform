import 'package:bottleshop_admin/app_page.dart';
import 'package:bottleshop_admin/core/data/repositories/common_data_repository.dart';
import 'package:bottleshop_admin/core/data/services/authentication_service.dart';
import 'package:bottleshop_admin/core/data/services/cloud_functions_service.dart';
import 'package:bottleshop_admin/core/data/services/push_notifications_service.dart';
import 'package:bottleshop_admin/core/presentation/view_models/navigation_notifier.dart';
import 'package:bottleshop_admin/models/categories_tree_model.dart';
import 'package:bottleshop_admin/models/constant_app_data.dart';
import 'package:bottleshop_admin/models/country_model.dart';
import 'package:bottleshop_admin/models/order_type_model.dart';
import 'package:bottleshop_admin/models/unit_model.dart';
import 'package:bottleshop_admin/ui/activities/intro_activity/intro_activity.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cloudFunctionsServiceProvider = Provider((_) => CloudFunctionsService());

final commonDataRepositoryProvider = Provider((_) => CommonDataRepository());

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, List<AppPage>>(
  (ref) => NavigationNotifier(
    [IntroActivityPage()],
    ref,
  ),
);

final constantAppDataProvider =
    StateProvider<ConstantAppData>((_) => ConstantAppData.empty());

final constantAppDataFutureProvider = FutureProvider<ConstantAppData>(
  (ref) async {
    final commonData = ref.read(commonDataRepositoryProvider);
    final res = await Future.wait([
      commonData.countries(),
      commonData.categories(),
      commonData.units(),
      commonData.orderTypes(),
    ]);
    return ConstantAppData(
      countries: res[0] as List<CountryModel>,
      categories: res[1] as List<CategoriesTreeModel>,
      units: res[2] as List<UnitModel>,
      orderTypes: res[3] as List<OrderTypeModel>,
    );
  },
);

final authenticationServiceProvider = Provider<AuthenticationService>(
  (ref) => AuthenticationService(ref),
);

final pushNotificationsProvider =
    Provider<PushNotificationsService>((ref) => PushNotificationsService(ref));

final pushNotificationsInitProvider = FutureProvider.autoDispose((ref) async {
  final pushNotifs = ref.watch(pushNotificationsProvider);
  await pushNotifs.init();
});

final crashlyticsInitProvider = FutureProvider.autoDispose<void>((ref) =>
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode));

final platformInitializedProvider =
    FutureProvider.autoDispose<void>((ref) async {
  await ref.watch(crashlyticsInitProvider.future);
  await ref.watch(pushNotificationsInitProvider.future);
});
