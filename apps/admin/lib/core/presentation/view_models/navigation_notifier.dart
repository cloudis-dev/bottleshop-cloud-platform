import 'package:bottleshop_admin/app_page.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/app_activity.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/order_detail_page.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tab_index.dart';
import 'package:bottleshop_admin/ui/activities/intro_activity/intro_activity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationNotifier extends StateNotifier<List<AppPage>> {
  NavigationNotifier(List<AppPage> state, this._providerRef) : super(state);

  final ProviderReference _providerRef;

  void pushPage(AppPage newPage) {
    state = [...state, newPage];
  }

  bool popPage([Object? argument]) {
    if (state.length > 1) {
      final lastPage = state.last;
      state = [...state]..removeLast();
      lastPage.onPopped?.call(argument);
      return true;
    } else {
      return true;
    }
  }

  void replaceLastWith(AppPage newPage) {
    state = [...state]
      ..removeLast()
      ..add(newPage);
  }

  void replaceAllWith(List<AppPage> newPages) {
    state = [...newPages];
  }

  void openOrder(
    String? orderUniqueId,
  ) {
    final introPage = IntroActivityPage(
      onPagesAfterLogin: () => [
        AppActivityPage(initialIndex: TabIndex.orders),
        OrderDetailPage(orderUniqueId: orderUniqueId),
      ],
    );

    // check if app is in on the login activity
    if (state.length == 1 && state.first.pageName == introPage.pageName) {
      state = [introPage];
    } else {
      state = [
        AppActivityPage(initialIndex: TabIndex.orders),
        OrderDetailPage(orderUniqueId: orderUniqueId)
      ];
    }
  }

  void openProduct(String? productUid) {
    final introPage = IntroActivityPage(
      onPagesAfterLogin: () => [
        AppActivityPage(initialIndex: TabIndex.products),
        ProductEditPage(
          productUid: productUid,
          productAction: ProductAction.editing,
        ),
      ],
    );

    if (state.length == 1 && state.first.pageName == introPage.pageName) {
      state = [introPage];
    } else {
      state = [
        AppActivityPage(initialIndex: TabIndex.products),
        ProductEditPage(
          productUid: productUid,
          productAction: ProductAction.editing,
        ),
      ];
    }
  }
}
