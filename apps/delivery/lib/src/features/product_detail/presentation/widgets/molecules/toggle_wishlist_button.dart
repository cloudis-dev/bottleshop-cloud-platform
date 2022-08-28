import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/progress_button.dart';
import 'package:delivery/src/features/favorites/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

final _addToWishlistButtonStateProvider =
    StateProvider.autoDispose.family<ButtonState, ProductModel>(
  (ref, product) {
    return ref.watch(isInWishListStreamProvider(product.uniqueId)).maybeWhen(
          data: (_) => ButtonState.idle,
          orElse: () => ButtonState.loading,
        );
  },
);

class ToggleWishlistButton extends HookWidget {
  const ToggleWishlistButton({
    Key? key,
    required this.product,
    this.actionOverride,
  }) : super(key: key);

  final ProductModel product;
  final VoidCallback? actionOverride;

  @override
  Widget build(BuildContext context) {
    final buttonState =
        useProvider(_addToWishlistButtonStateProvider(product)).state;
    final loaderColor = Theme.of(context).primaryColor;

    return ProgressButton(
      minWidth: 60,
      maxWidth: 90,
      onPressed: actionOverride ??
          () {
            context.read(_addToWishlistButtonStateProvider(product)).state =
                ButtonState.loading;
            context.read(isInWishListStreamProvider(product.uniqueId)).whenData(
              (isInWishList) {
                if (isInWishList ?? false) {
                  return context
                      .read(wishListProvider)!
                      .remove(product.uniqueId)
                      .then(
                        (value) => showSimpleNotification(
                          Text(
                              '${product.name} ${S.of(context).removedFromWishList}'),
                          slideDismissDirection: DismissDirection.horizontal,
                          context: context,
                        ),
                      )
                      .catchError(
                        (_) => showSimpleNotification(
                          Text(
                              '${product.name} ${S.of(context).couldntBeSuccessfullyRemovedFromWishlist}'),
                          duration: const Duration(seconds: 1),
                          slideDismissDirection: DismissDirection.horizontal,
                          context: context,
                        ),
                      );
                } else {
                  logAddToWishlist(
                      context,
                      product.uniqueId,
                      product.name,
                      product.allCategories.first.categoryDetails.toString(),
                      1);
                  return context
                      .read(wishListProvider)!
                      .add(product.uniqueId)
                      .then(
                        (value) => showSimpleNotification(
                          Text(
                              '${product.name} ${S.of(context).addedToWishList}'),
                          duration: const Duration(seconds: 1),
                          slideDismissDirection: DismissDirection.horizontal,
                          context: context,
                        ),
                      )
                      .catchError(
                        (_) => showSimpleNotification(
                          Text(
                              '${product.name} ${S.of(context).couldntBeSuccessfullyAddedToWishlist}'),
                          duration: const Duration(seconds: 1),
                          slideDismissDirection: DismissDirection.horizontal,
                          context: context,
                        ),
                      );
                }
              },
            ).whenData(
              (value) => value.whenComplete(
                () => {
                  context
                      .read(_addToWishlistButtonStateProvider(product))
                      .state = ButtonState.idle
                },
              ),
            );
          },
      state: buttonState,
      stateWidgets: {
        ButtonState.idle: Icon(
          useProvider(isInWishListStreamProvider(product.uniqueId)).maybeWhen(
            data: (isInWishList) => (isInWishList ?? false)
                ? Icons.favorite
                : Icons.favorite_border,
            orElse: () => Icons.favorite_border,
          ),
          size: 20,
          color: Theme.of(context).colorScheme.surface,
        ),
        ButtonState.loading: Loader(valueColor: loaderColor),
        ButtonState.success: const SizedBox.shrink(),
        ButtonState.fail: const SizedBox.shrink(),
      },
      stateColors: Map.fromEntries(
        ButtonState.values.map((e) => MapEntry(e, Colors.white)),
      ),
    );
  }
}
