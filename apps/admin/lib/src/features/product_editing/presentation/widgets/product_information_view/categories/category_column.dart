import 'package:bottleshop_admin/src/core/data/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/core/data/models/category_model.dart';
import 'package:bottleshop_admin/src/core/data/models/category_plain_model.dart';
import 'package:bottleshop_admin/src/core/utils/iterable_extension.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'category_dropdown.dart';

class CategoryColumn extends HookWidget {
  CategoryColumn({
    Key? key,
    required List<CategoriesTreeModel> categoriesOptions,
    required CategoryModel? category,
    required int categoryId,
  })  : _categoriesOptions = categoriesOptions,
        _categoryId = categoryId,
        _category = category,
        super(key: key);

  final List<CategoriesTreeModel> _categoriesOptions;
  final int _categoryId;
  final CategoryModel? _category;

  Iterable<CategoryDropdown> dropDowns({
    required BuildContext context,
    CategoryModel? currentCategoryModel,
    required List<CategoriesTreeModel> dropdownCategoriesOptions,
    required int dropdownId,
    required List<CategoryPlainModel> currentSelectedCategories,
    required List<CategoryPlainModel> initialCategories,
  }) sync* {
    if (dropdownCategoriesOptions.isEmpty) return;

    final currentValue = dropdownId < currentSelectedCategories.length
        ? currentSelectedCategories[dropdownId]
        : null;

    yield CategoryDropdown(
      currentValue: currentValue,
      categoriesOptions: dropdownCategoriesOptions,
      isSubcategory: dropdownId > 0,
      onSaved: (value) {
        if (value == null) return;

        final productState = context.read(editedProductProvider);
        final newCategories = productState.state.allCategories.toList();
        final newCategory = dropdownId >= currentSelectedCategories.length
            ? CategoryModel.appendCategory(
                currentCategoryModel,
                value,
              )
            : CategoryModel.changeCategory(
                currentCategoryModel,
                dropdownId,
                value,
              );

        if (_categoryId == newCategories.length) {
          newCategories.add(newCategory);
        } else {
          newCategories[_categoryId] = newCategory;
        }

        productState.state =
            productState.state.copyWith(categories: newCategories);
      },
      validator: (value) {
        if (value == null) {
          return 'Kategória musí byť úplna';
        }
        return null;
      },
    );

    if (dropdownId == currentSelectedCategories.length) return;

    print(currentValue);
    yield* dropDowns(
      context: context,
      currentCategoryModel: currentCategoryModel,
      dropdownCategoriesOptions: dropdownCategoriesOptions
          .firstWhere((element) => currentValue == element.categoryDetails)
          .subCategories,
      dropdownId: dropdownId + 1,
      currentSelectedCategories: currentSelectedCategories,
      initialCategories: initialCategories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCategories =
        CategoryModel.allCategoryDetails(_category).toList();
    final initialCategories = CategoryModel.allCategoryDetails(
      useProvider(initialProductProvider.select(
          (value) => value.state.allCategories)).tryGetById(_categoryId),
    ).toList();

    final allDropDowns = dropDowns(
      context: context,
      currentCategoryModel: _category,
      dropdownCategoriesOptions: _categoriesOptions,
      dropdownId: 0,
      currentSelectedCategories: currentCategories,
      initialCategories: initialCategories,
    );

    return Column(
      children: <Widget>[...allDropDowns],
    );
  }
}
