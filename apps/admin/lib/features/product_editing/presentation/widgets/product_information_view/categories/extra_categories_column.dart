import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'extra_category_container.dart';

class ExtraCategoriesColumn extends HookWidget {
  const ExtraCategoriesColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extraCategories = useProvider(
        editedProductProvider.select((value) => value.state.extraCategories));

    if (extraCategories.isEmpty) {
      return ExtraCategoryContainer(
        isAdded: false,
        category: null,
        categoryId: 1,
      );
    } else {
      return Column(
        children: [
          ...Iterable<int>.generate(extraCategories.length).map(
            (e) => ExtraCategoryContainer(
              isAdded: true,
              category: extraCategories[e],
              categoryId: e + 1,
            ),
          ),
          ExtraCategoryContainer(
            isAdded: false,
            category: null,
            categoryId: extraCategories.length + 1,
          ),
        ],
      );
    }
  }
}
