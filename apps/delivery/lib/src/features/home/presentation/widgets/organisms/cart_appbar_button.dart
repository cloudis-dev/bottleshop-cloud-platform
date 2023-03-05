import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/cart_icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

class CartAppbarButton extends HookConsumerWidget {
  @literal
  const CartAppbarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const CartIconWithBadge(),
      onPressed: () {
        ref.read(navigationProvider).setNestingBranch(
              context,
              NestingBranch.cart,
              resetBranchStack: true,
            );
      },
    );
  }
}
