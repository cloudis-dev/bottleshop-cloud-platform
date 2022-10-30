import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/menu_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/filter_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/search_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/views/home_products_body.dart';
import 'package:delivery/src/features/product_sections/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:routeborn/routeborn.dart';

import 'landing_page.dart';

class ProductsPage extends RoutebornPage {
  static const String pagePathBase = 'products';

  ProductsPage()
      : super.builder(
          pagePathBase,
          (_) => const _ProductsView(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.homeTabLabel);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _ProductsView extends HookConsumerWidget {
  const _ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is to preserve state
    ref.watch(flashSaleProductsProvider);
    ref.watch(recommendedProductsProvider);
    ref.watch(newArrivalsProductsProvider);

    ref.watch(allProductsProvider);

    return const Landing();
  }
}

class _Scaffold extends HookWidget {
  @literal
  const _Scaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerAcquirerKey =
        useMemoized(() => GlobalKey<DrawerStateAcquirerState>());
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final childScaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          actions: [
            const LanguageDropdown(),
            FilterIconButton(childScaffoldKey, drawerAcquirerKey),
            const SearchIconButton(),
            AuthPopupButton(scaffoldKey: scaffoldKey),
          ],
          title: Text(context.l10n.homeTabLabel),
          leading: MenuButton(drawerScaffoldKey: scaffoldKey),
        ),
        body: HomeProductsBody(childScaffoldKey, drawerAcquirerKey),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        appBarActions: [
          const LanguageDropdown(),
          FilterIconButton(childScaffoldKey, drawerAcquirerKey),
          const SearchIconButton(),
          const CartAppbarButton(),
          AuthPopupButton(scaffoldKey: scaffoldKey),
        ],
        body: HomeProductsBody(childScaffoldKey, drawerAcquirerKey),
      );
    }
  }
}
