import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDescriptionTab extends HookConsumerWidget {
  final ProductModel product;

  const ProductDescriptionTab(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(currentLanguageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          title: Text(
            context.l10n.description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.getDescription(currentLang) ?? context.l10n.wereWorkingOnIt,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
    );
  }
}
