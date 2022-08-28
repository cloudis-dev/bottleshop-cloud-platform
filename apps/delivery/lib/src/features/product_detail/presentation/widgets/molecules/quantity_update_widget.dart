import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/progress_button.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

final _quantityUpdateButtonStateProvider =
    StateProvider.autoDispose.family<ButtonState, ProductModel>(
  (ref, product) {
    return ref.watch(cartQuantityStreamProvider(product)).maybeWhen(
          data: (_) => ButtonState.idle,
          orElse: () => ButtonState.loading,
        );
  },
);

class QuantityUpdateWidget extends HookWidget {
  final ProductModel product;

  const QuantityUpdateWidget({
    Key? key,
    required this.product,
    this.actionOverride,
  }) : super(key: key);

  final VoidCallback? actionOverride;

  @override
  Widget build(BuildContext context) {
    final buttonState =
        useProvider(_quantityUpdateButtonStateProvider(product)).state;
    final currentQuantity = useProvider(cartQuantityStreamProvider(product))
        .maybeWhen(data: (quantity) => quantity, orElse: () => 0);

    return ProgressButton(
      onPressed: () {},
      state: buttonState,
      stateWidgets: {
        ButtonState.idle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkResponse(
                highlightShape: BoxShape.circle,
                child: IconButton(
                  iconSize: 20,
                  splashRadius: 20.0,
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: actionOverride ??
                      () async {
                        try {
                          if (currentQuantity == 1) {
                            return context
                                .read(cartRepositoryProvider)!
                                .removeItem(product.uniqueId);
                          }
                          return context
                              .read(cartRepositoryProvider)!
                              .setItemQty(
                                  product.uniqueId, currentQuantity - 1);
                        } catch (e) {
                          showSimpleNotification(
                            Text(S
                                .of(context)
                                .couldntChangeQuantityOfTheProductInTheCart),
                            duration: const Duration(seconds: 1),
                            slideDismissDirection: DismissDirection.horizontal,
                            context: context,
                          );
                        }
                      },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                ),
              ),
              Text(
                '${currentQuantity.toString()} ${S.of(context).inCart}',
                style: Theme.of(context).textTheme.button,
              ),
              InkResponse(
                highlightShape: BoxShape.circle,
                child: IconButton(
                  iconSize: 20,
                  splashRadius: 20.0,
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: actionOverride ??
                      (currentQuantity >= product.count
                          ? null
                          : () async {
                              context
                                  .read(_quantityUpdateButtonStateProvider(
                                      product))
                                  .state = ButtonState.loading;
                              try {
                                return context
                                    .read(cartRepositoryProvider)!
                                    .setItemQty(
                                        product.uniqueId, currentQuantity + 1);
                              } catch (e) {
                                showSimpleNotification(
                                  Text(S
                                      .of(context)
                                      .couldntChangeQuantityOfTheProductInTheCart),
                                  duration: const Duration(seconds: 1),
                                  slideDismissDirection:
                                      DismissDirection.horizontal,
                                  context: context,
                                );
                              } finally {
                                context
                                    .read(_quantityUpdateButtonStateProvider(
                                        product))
                                    .state = ButtonState.idle;
                              }
                            }),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                ),
              ),
            ],
          ),
        ),
        ButtonState.loading: Loader(
          valueColor: Theme.of(context).primaryColor,
        ),
        ButtonState.success: const SizedBox.shrink(),
        ButtonState.fail: const SizedBox.shrink(),
      },
      stateColors: Map.fromEntries(
        ButtonState.values
            .map((e) => MapEntry(e, Theme.of(context).colorScheme.secondary)),
      ),
    );
  }
}
