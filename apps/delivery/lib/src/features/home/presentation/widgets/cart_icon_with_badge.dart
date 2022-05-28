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

    return ref.watch(cartProviderl10n.maybeWhen(
          data: (cart) => BottleshopBadge(
            child: icon,
            badgeText: cart?.totalItems.toString() ?? '',
            showBadge: (cart?.totalItems ?? 0) > 0,
            position: BadgePosition.topEnd(top: -5),
          ),
          orElse: () => icon,
        );
  }
}
