import 'package:bottleshop_admin/utils/sorting_util.dart';
import 'package:flutter/foundation.dart';

import 'categories_tree_model.dart';
import 'country_model.dart';
import 'order_type_model.dart';
import 'unit_model.dart';

@immutable
class ConstantAppData {
  final List<CountryModel> countries;
  final List<CategoriesTreeModel> categories;
  final List<UnitModel> units;
  final List<OrderTypeModel> orderTypes;

  ConstantAppData.empty()
      : countries = List.unmodifiable([]),
        categories = List.unmodifiable([]),
        units = List.unmodifiable([]),
        orderTypes = List.unmodifiable([]);

  ConstantAppData({
    required List<CountryModel> countries,
    required List<CategoriesTreeModel> categories,
    required List<UnitModel> units,
    required List<OrderTypeModel> orderTypes,
  })   : countries = List.unmodifiable(
          countries
            ..sort(
              (a, b) => SortingUtil.stringSortCompare(
                a.localizedName.local,
                b.localizedName.local,
              ),
            ),
        ),
        categories = List.unmodifiable(
          categories
            ..sort(
              (a, b) => SortingUtil.stringSortCompare(
                a.categoryDetails.localizedName.local,
                b.categoryDetails.localizedName.local,
              ),
            ),
        ),
        units = List.unmodifiable(units),
        orderTypes = List.unmodifiable(orderTypes);

  List<CategoriesTreeModel> categoriesWithoutExtraCategories() => categories
      .where((element) => !element.categoryDetails.isExtraCategory)
      .toList();

  List<CategoriesTreeModel> extraCategories() => categories
      .where((element) => element.categoryDetails.isExtraCategory)
      .toList();
}
