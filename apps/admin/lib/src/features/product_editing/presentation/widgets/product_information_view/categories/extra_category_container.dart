import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'category_column.dart';

class ExtraCategoryContainer extends StatelessWidget {
  const ExtraCategoryContainer({
    Key? key,
    required bool isAdded,
    required CategoryModel? category,
    required int categoryId,
  })  : _isAdded = isAdded,
        _category = category,
        _categoryId = categoryId,
        super(key: key);

  final bool _isAdded;
  final CategoryModel? _category;
  final int _categoryId;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: <Widget>[
            if (_isAdded) ...{
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    final productState = context.read(editedProductProvider);
                    final newCategories = productState.state.allCategories
                        .toList()
                      ..removeAt(_categoryId);

                    productState.state =
                        productState.state.copyWith(categories: newCategories);
                  },
                  child: Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: CategoryColumn(
                  categoriesOptions: context
                      .read(constantAppDataProvider)
                      .state
                      .extraCategories(),
                  category: _category,
                  categoryId: _categoryId,
                ),
              ),
            } else ...{
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    final productState = context.read(editedProductProvider);
                    final newCategories =
                        productState.state.allCategories.toList();
                    if (newCategories.isEmpty) {
                      newCategories.add(null);
                    }
                    newCategories.add(null);

                    productState.state =
                        productState.state.copyWith(categories: newCategories);
                  },
                  child: Icon(Icons.add),
                ),
              )
            },
          ],
        ),
      );
}
