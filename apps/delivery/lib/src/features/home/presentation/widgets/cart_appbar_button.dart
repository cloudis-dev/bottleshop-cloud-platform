import 'package:delivery/src/features/home/presentation/widgets/cart_icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

class CartAppbarButton extends ConsumerWidget {
  @literal
  const CartAppbarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const CartIconWithBadge(),
      onPressed: () {},
    );
  }
}
