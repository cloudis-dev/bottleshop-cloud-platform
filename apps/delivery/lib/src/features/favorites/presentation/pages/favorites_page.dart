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

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/favorites/presentation/providers/providers.dart';
import 'package:delivery/src/features/favorites/presentation/widgets/favorite_list_item.dart';
import 'package:delivery/src/features/home/presentation/widgets/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/menu_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/page_body_template.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';


class FavoritesPage extends HookConsumerWidget with UiLoggy{
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authButtonKey = useMemoized(() => GlobalKey<AuthPopupButtonState>());
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: Text(context.l10n.favoriteTabLabel),
          actions: [
            const _SearchIconButton(),
            AuthPopupButton(
              key: authButtonKey,
              scaffoldKey: scaffoldKey,
            ),
          ],
          leading: MenuButton(drawerScaffoldKey: scaffoldKey),
        ),
        body: _Body(authButtonKey),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        appBarActions: [
          const _SearchIconButton(),
          AuthPopupButton(
            key: authButtonKey,
            scaffoldKey: scaffoldKey,
          ),
        ],
        body: PageBodyTemplate(
          child: _Body(authButtonKey),
        ),
      );
    }
  }
}

class _SearchIconButton extends HookConsumerWidget {
  const _SearchIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        tooltip: MaterialLocalizations.of(context).searchFieldLabel, icon: const Icon(Icons.search), onPressed: () {});
  }
}

class _Body extends HookConsumerWidget {
  final GlobalKey<AuthPopupButtonState>? authButtonKey;

  const _Body(this.authButtonKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(wishListStreamProviderl10n.when(
          data: (favorites) {
            if (favorites?.isNotEmpty ?? false) {
              return _FavoritesListLayout(favorites: favorites!);
            }

            if (favorites == null) {
              return EmptyTab(
                icon: Icons.login,
                message: context.l10n.youNeedToLoginFirst,
                buttonMessage: context.l10n.login,
                onButtonPressed: () => authButtonKey!.currentState!.showAccountMenu(),
              );
            } else {
              return EmptyTab(
                  icon: Icons.favorite_border,
                  message: context.l10n.emptyWishList,
                  buttonMessage: context.l10n.startExploring,
                  onButtonPressed: null);
            }
          },
          loading: () => const Loader(),
          error: (error, stack) {
            loggy.error('Failed to fetch favorites', error, stack);

            return EmptyTab(
              icon: Icons.favorite_border,
              message: context.l10n.emptyWishList,
              buttonMessage: context.l10n.startExploring,
              onButtonPressed: null,
            );
          },
        );
  }
}

class _FavoritesListLayout extends HookConsumerWidget {
  final List<ProductModel> favorites;

  const _FavoritesListLayout({
    Key? key,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _messageRemoved = context.l10n.itemRemovedFromWishList;

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      scrollDirection: Axis.vertical,
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return FavoriteListItem(
          heroTag: 'favorites_list',
          product: favorites.elementAt(index),
          onDismissed: (direction) {
            loggy.info('dismissing direction: ${direction.toString()}');
            ref.read(wishListProvider)!.remove(favorites.elementAt(indexl10n.uniqueIdl10n.then(
                  (value) => showSimpleNotification(
                    Text(_messageRemoved),
                    position: NotificationPosition.bottom,
                    duration: const Duration(seconds: 1),
                    slideDismissDirection: DismissDirection.horizontal,
                    context: context,
                  ),
                );
          },
        );
      },
    );
  }
}
