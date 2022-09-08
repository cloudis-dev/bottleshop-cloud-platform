import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_section_heading.dart';
import 'package:delivery/src/features/product_sections/presentation/providers/providers.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/organisms/products_section_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SaleSection extends HookWidget {
  const SaleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsState =
        useProvider(saleProductsProvider.select((value) => value.itemsState));

    return ProductsSectionCarousel(
      data: productsState.items,
      carouselHeader: BottleshopSectionHeading(
        leading: const Icon(Icons.monetization_on),
        label: context.l10n.sale,
      ),
    );
  }
}
