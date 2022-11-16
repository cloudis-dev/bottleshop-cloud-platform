// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/categories/presentation/widgets/categories_view.dart';
import 'package:delivery/src/features/home/presentation/widgets/menu_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/search_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:routeborn/routeborn.dart';

class CategoriesPage extends RoutebornPage {
  static const String pagePathBase = 'categories';

  CategoriesPage()
      : super.builder(pagePathBase, (_) => const _CategoriesPage());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.categories);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _CategoriesPage extends HookWidget {
  const _CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: Text(context.l10n.categories),
          leading: MenuButton(drawerScaffoldKey: scaffoldKey),
          actions: [
            const SearchIconButton(),
            AuthPopupButton(scaffoldKey: scaffoldKey),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CategoriesView(),
        ),
      );
    } else {
      final scrollCtrl = useScrollController();

      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        // menuDrawer: const MenuDrawer(),
        // appBarTitle: Text(context.l10n.categories),
        appBarActions: [
          const LanguageDropdown(),
          const SearchIconButton(),
          const CartAppbarButton(),
          AuthPopupButton(scaffoldKey: scaffoldKey),
        ],
        body: Scrollbar(
          controller: scrollCtrl,
          child: PageBodyTemplate(
            child: CategoriesView(
              scrollCtrl: scrollCtrl,
            ),
          ),
        ),
      );
    }
  }
}
