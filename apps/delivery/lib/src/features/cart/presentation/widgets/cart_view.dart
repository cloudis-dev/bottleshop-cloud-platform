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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/cart/presentation/widgets/cart_list_item.dart';
import 'package:delivery/src/features/checkout/presentation/pages/checkout_page.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((CartView).toString());

class CartView extends HookWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 120),
          padding: EdgeInsets.only(bottom: 30),
          child: CupertinoScrollbar(
            controller: scrollController,
            isAlwaysShown: false,
            child: useProvider(cartContentProvider).when(
              data: (cart) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: cart.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      await context
                          .read(cartRepositoryProvider)!
                          .removeItem(cart.elementAt(index).product.uniqueId);
                      showSimpleNotification(
                        Text(S.of(context).itemRemovedFromCart),
                        position: NotificationPosition.bottom,
                        duration: Duration(seconds: 1),
                        slideDismissDirection: DismissDirection.horizontal,
                        context: context,
                      );
                    },
                    child: CartListItem(
                      product: cart.elementAt(index).product,
                      quantity: cart.elementAt(index).count,
                    ),
                  ),
                );
              },
              loading: () => const Loader(),
              error: (err, stack) {
                _logger.severe('Failed to fetch cart content', err, stack);
                return Center(
                  child: Text(S.of(context).failedToFetchCart),
                );
              },
            ),
          ),
        ),
        useProvider(cartProvider).when(
          data: (cart) {
            return CheckoutTile(
              showPromoButton: !kIsWeb,
              actionLabel: S.of(context).proceedToShipment,
              actionCallback: () {
                context.read(navigationProvider).pushPage(
                      context,
                      AppPageNode(page: CheckoutPage()),
                      toParent: true,
                    );
              },
            );
          },
          loading: () => const Loader(),
          error: (err, stack) {
            _logger.severe('Failed to fetch cart', err, stack);
            return Center(
              child: Text(S.of(context).error),
            );
          },
        ),
      ],
    );
  }
}
