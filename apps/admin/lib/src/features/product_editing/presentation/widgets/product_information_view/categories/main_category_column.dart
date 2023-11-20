import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/product_editing/presentation/widgets/product_information_view/categories/category_column.dart';

class MainCategoryColumn extends HookWidget {
  const MainCategoryColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryColumn(
      categoriesOptions: context
          .read(constantAppDataProvider)
          .state
          .categoriesWithoutExtraCategories(),
      category: useProvider(
          editedProductProvider.select((value) => value.state.mainCategory)),
      categoryId: 0,
    );
  }
}
