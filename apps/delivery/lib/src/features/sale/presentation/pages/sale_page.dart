import 'package:dartz/dartz.dart';
import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/menu_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/search_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/sale_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:routeborn/routeborn.dart';

class SalePage extends RoutebornPage {
  static const String pagePathBase = 'sale';

  SalePage() : super.builder(pagePathBase, (_) => const _SalePage());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(S.of(context).wholesale);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _SalePage extends HookWidget {
  const _SalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: Text(S.of(context).wholesale),
          leading: MenuButton(drawerScaffoldKey: scaffoldKey),
          actions: [
            AuthPopupButton(scaffoldKey: scaffoldKey),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SaleSection(),
        ),
      );
    } else {
      final scrollCtrl = useScrollController();

      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        appBarActions: [
          const LanguageDropdown(),
          const SearchIconButton(),
          const CartAppbarButton(),
          AuthPopupButton(scaffoldKey: scaffoldKey),
        ],
        body: Scrollbar(
          controller: scrollCtrl,
          child: PageBodyTemplate(
            child: SingleChildScrollView(
              controller: scrollCtrl,
              child: const SaleSection(),
            ),
          ),
        ),
      );
    }
  }
}
