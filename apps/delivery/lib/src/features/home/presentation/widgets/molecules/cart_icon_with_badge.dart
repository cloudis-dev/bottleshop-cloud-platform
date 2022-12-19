import 'package:badges/badges.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

class CartIconWithBadge extends HookConsumerWidget {
  @literal
  const CartIconWithBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const icon = Icon(Icons.shopping_cart);

    return ref.watch(cartProvider).maybeWhen(
          data: (cart) => BottleshopBadge(
            badgeText: cart.products.length.toString(),
            showBadge: cart.products.isNotEmpty,
            position: BadgePosition.topEnd(top: -5),
            child: icon,
          ),
          orElse: () => icon,
        );
  }
}
