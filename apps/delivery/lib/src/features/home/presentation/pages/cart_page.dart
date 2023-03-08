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
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/cart/presentation/widgets/cart_view.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/mobile_home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((CartPage).toString());

class CartPage extends RoutebornPage {
  static const String pagePathBase = 'cart';

  CartPage() : super.builder(pagePathBase, (_) => const _CartPageView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.cart);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _CartPageView extends HookWidget {
  const _CartPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    if (shouldUseMobileLayout(context)) {
      return MobileHomePageTemplate(
        scaffoldKey: scaffoldKey,
        body: const _Body(),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        body: const PageBodyTemplate(child: _Body()),
      );
    }
  }
}

class _Body extends HookConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(isCartEmptyProvider).when(
          data: (isCartEmpty) {
            return isCartEmpty
                ? EmptyTab(
                    icon: Icons.shopping_cart_outlined,
                    message: context.l10n.emptyCart,
                    buttonMessage: context.l10n.startExploring,
                    onButtonPressed: () {
                      ref
                          .read(navigationProvider)
                          .setNestingBranch(context, NestingBranch.shop);
                    },
                  )
                : const CartView();
          },
          error: (err, stack) {
            _logger.severe('Cart failed to load', err, stack);

            return EmptyTab(
              icon: Icons.error_outline,
              message: context.l10n.upsSomethingWentWrong,
            );
          },
          loading: () => const Loader(),
        );
  }
}
