import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDescriptionTab extends HookWidget {
  final ProductModel product;

  const ProductDescriptionTab(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          title: Text(
            S.of(context).description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.getDescription(currentLocale) ??
                S.of(context).wereWorkingOnIt,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
    );
  }
}
