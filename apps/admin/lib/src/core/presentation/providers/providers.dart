import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/data/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/core/data/models/constant_app_data_model.dart';
import 'package:bottleshop_admin/src/core/data/models/country_model.dart';
import 'package:bottleshop_admin/src/core/data/models/unit_model.dart';
import 'package:bottleshop_admin/src/core/data/repositories/common_data_repository.dart';
import 'package:bottleshop_admin/src/core/data/services/authentication_service.dart';
import 'package:bottleshop_admin/src/core/data/services/cloud_functions_service.dart';
import 'package:bottleshop_admin/src/core/data/services/push_notifications_service.dart';
import 'package:bottleshop_admin/src/core/presentation/view_models/navigation_notifier.dart';
import 'package:bottleshop_admin/src/features/login/presentation/pages/intro_activity.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_type_model.dart';
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
    StateProvider<ConstantAppDataModel>((_) => ConstantAppDataModel.empty());

final constantAppDataFutureProvider = FutureProvider<ConstantAppDataModel>(
  (ref) async {
    final commonData = ref.read(commonDataRepositoryProvider);
    final res = await Future.wait([
      commonData.countries(),
      commonData.categories(),
      commonData.units(),
      commonData.orderTypes(),
    ]);
    return ConstantAppDataModel(
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

 final crashlyticsInitProvider = FutureProvider.autoDispose<void>(
  (ref) => !kIsWeb
      ? FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode)
      : Future<void>.value(),
);

final platformInitializedProvider =
    FutureProvider.autoDispose<void>((ref) async {
  await ref.watch(crashlyticsInitProvider.future);
  await ref.watch(pushNotificationsInitProvider.future);
});
