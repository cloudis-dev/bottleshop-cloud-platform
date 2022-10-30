import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/progress_button.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

final _addToCartButtonStateProvider =
    StateProvider.autoDispose.family<ButtonState, ProductModel>(
  (ref, product) {
    return ref.watch(cartQuantityStreamProvider(product)).maybeWhen(
          orElse: () => ButtonState.idle,
        );
  },
);

class AddToCartButton extends HookConsumerWidget {
  final ProductModel product;

  const AddToCartButton({
    Key? key,
    required this.product,
    this.actionOverride,
  }) : super(key: key);

  final VoidCallback? actionOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addToCartButtonState =
        ref.watch(_addToCartButtonStateProvider(product));

    return ProgressButton(
      state: addToCartButtonState,
      onPressed: actionOverride ??
          (product.count == 0
              ? null
              : () {
                  ref.read(_addToCartButtonStateProvider(product).state).state =
                      ButtonState.loading;
                  try {
                    ref.read(cartRepositoryProvider)!.add(product.uniqueId, 1);
                    logAddToCart(
                      context,
                      product.uniqueId,
                      product.name,
                      product.allCategories.first.categoryDetails.toString(),
                      1,
                    );
                    showSimpleNotification(
                      Text('${product.name} ${context.l10n.addedToCart}'),
                      duration: const Duration(seconds: 1),
                      slideDismissDirection: DismissDirection.horizontal,
                      context: context,
                    );
                  } catch (e) {
                    showSimpleNotification(
                      Text(
                          '${product.name} ${context.l10n.couldntBeAddedToTheCart}'),
                      duration: const Duration(seconds: 1),
                      slideDismissDirection: DismissDirection.horizontal,
                      context: context,
                    );
                  } finally {
                    ref
                        .read(_addToCartButtonStateProvider(product).state)
                        .state = ButtonState.idle;
                  }
                }),
      stateWidgets: {
        ButtonState.idle: Text(
          context.l10n.addToCart,
          textAlign: TextAlign.start,
        ),
        ButtonState.loading: Loader(
          valueColor: Theme.of(context).primaryColor,
        ),
        ButtonState.success: const SizedBox.shrink(),
        ButtonState.fail: const SizedBox.shrink(),
      },
      stateColors: Map.fromEntries(
        ButtonState.values
            .map((e) => MapEntry(e, Theme.of(context).primaryColor)),
      ),
    );
  }
}
