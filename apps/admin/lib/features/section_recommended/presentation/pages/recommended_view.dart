import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/features/section_recommended/presentation/providers/providers.dart';
import 'package:bottleshop_admin/features/section_recommended/presentation/widgets/product_card_recommended_menu_button.dart';
import 'package:bottleshop_admin/ui/shared_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class RecommendedView extends HookWidget {
  const RecommendedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsState = useProvider(
      recommendedProductsProvider.select((value) => value.itemsState),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomScrollView(
        slivers: [
          _InitialItem(),
          SliverPagedList(
            itemsState: productsState,
            itemBuilder: (context, dynamic item, _) => ProductCard(
              product: item,
              productCardMenuButtonBuilder: (_) =>
                  ProductCardRecommendedMenuButton(item),
            ),
            requestData: () {},
          )
        ],
      ),
    );
  }
}

class _InitialItem extends StatelessWidget {
  const _InitialItem();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Odporúčané',
              style: AppTheme.headline1TextStyle,
            ),
            Row(
              children: [
                Text(
                  'Pre pridanie produktu pokračujte cez produkty',
                  style: AppTheme.subtitle1TextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.widgets,
                    color: AppTheme.mediumGreySolid,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      );
}
