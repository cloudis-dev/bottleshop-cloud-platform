import 'package:bottleshop_admin/src/core/presentation/widgets/product_card.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/product_card_all_actions_menu_button.dart';
import 'package:bottleshop_admin/src/features/products/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class ProductsList extends HookWidget {
  const ProductsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsState = useProvider(
      productsStateProvider.select((value) => value.itemsState),
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          sliver: SliverPagedList<ProductModel>(
            itemsState: productsState,
            itemBuilder: (context, item, _) => ProductCard(
              product: item,
              productCardMenuButtonBuilder: (_) =>
                  ProductCardAllActionsMenuButton(
                product: item,
              ),
            ),
            requestData: () =>
                context.read(productsStateProvider).requestData(),
          ),
        )
      ],
    );
  }
}
